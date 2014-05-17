//
//  SpriteLayer.m
//  Pollen
//
//  Created by Eric Nelson on 5/1/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "SpriteLayer.h"

#import "GameplayScene.h"
#import "TreeLayer.h"
#import "MainMenuLayer.h"

#import "PlayerSprite.h"
#import "FlowerSpawner.h"
#import "Flower.h"
#import "Spiddderoso.h"

#import "ClipSprite.h"
#import "GameUtility.h"
#import "SimpleAudioEngine.h"

#define HEIGHT_FACTOR 15.f

@implementation SpriteLayer

@synthesize playerHeight = playerHeight_;
-(float) topBuffer { return [pollenBarBackground_ boundingBox].size.height; }

-(id) init {
    if(self = [super init])
    {
        //setup
        size = [[CCDirector sharedDirector] winSize];
        self.accelerometerEnabled = YES;
        
        //pollen meter
        pollenBarBackground_ = [CCSprite spriteWithFile:@"pollenBarBackground.png"];
        pollenBarBackground_.position = ccp(size.width/2,
                                            size.height - [pollenBarBackground_ boundingBox].size.height/2);
        [self addChild:pollenBarBackground_ z:1000];
        
        pollenBar_ = [ClipSprite spriteWithFile:@"pollenBar.png"];
        pollenBar_.position = pollenBarBackground_.position;
        [pollenBar_ setClip:ccp(0, 0) :ccp(0, [pollenBar_ boundingBox].size.height)];
        [self addChild:pollenBar_ z:1001];
        
        //section off top of screen
        size.height -= [pollenBarBackground_ boundingBox].size.height;
        
        //player
        player_ = [PlayerSprite node];
        [self addChild:player_ z:1];
        
        //spawner
        spawner_ = [[FlowerSpawner alloc] init];
        [spawner_ setSpawnLayer:self];
        [spawner_ setParticleAmount:INITIAL_FLOWER_AMOUNT];
        
        //spiddder
        spiddder_ = [Spiddderoso node];
        [self addChild:spiddder_ z:2];
        
        //height
        float scaleFactor = size.height/size.width;
        
        highScore_ = [GameUtility savedHighScore];
        highScoreLabel_ = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%im", (int) highScore_]
                                             fontName:@"Futura" fontSize:12*scaleFactor];
        highScoreLabel_.anchorPoint = ccp(0, 1);
        highScoreLabel_.position = ccp(4, size.height);
        [self addChild:highScoreLabel_ z:4];
        
        heightLabel_ = [CCLabelTTF labelWithString:@"0m" fontName:@"Futura" fontSize:12*scaleFactor];
        heightLabel_.anchorPoint = ccp(0, 1);
        heightLabel_.position = ccp(highScoreLabel_.position.x,
                                    highScoreLabel_.position.y - [highScoreLabel_ boundingBox].size.height);
        [self addChild: heightLabel_ z:3];
        
        playerHeight_ = 0;
        
        //music
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    }
    return self;
}
-(void) onEnter {
    [super onEnter];
    [self registerWithTouchDispatcher];
}
-(void) onExit {
    [super onExit];
    [[CCDirector sharedDirector].touchDispatcher removeDelegate:self];
}
-(void) dealloc {
    [spawner_ dealloc];
    [super dealloc];
}

//INPUT
-(void) registerWithTouchDispatcher {
    [[CCDirector sharedDirector].touchDispatcher
        addTargetedDelegate:self priority:2 swallowsTouches:YES];
}
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [self convertTouchToNodeSpace:touch];
    
    if(scene && ![scene isPausedWithMenu])
    if(location.x > 0 && location.x < size.width &&
       location.y > 0 && location.y < size.height) {
        touchBeganLocation_ = location;
        
        //spiddder
        if(!spiddder_.waitingDisconnect) {
            if(player_.state == OnGround)
                [spiddder_ updateSpeed];
            
            if([GameUtility isCollidingRect:player_ WithRect:spiddder_]) {
                spiddder_.waitingDisconnect = YES;
                [spiddder_ updateSpeed];
                player_.pollenMeter += SPIDDDER_POLLEN_AMOUNT;
                [player_ startSpiddderJump];
            }
        }
        
        [player_ startAttack];
        if(player_.state != Boosting)
        for(Flower* flower in spawner_.flowers) {
            if(!flower.bloomed && [GameUtility isCollidingRect:player_ WithRect:flower]) {
                [flower bloomFlowerWithPower:100];
                if(flower.bloomed) {
                    [player_ startJump];
                }
                //break; //used to bloom only one flower at a time (will activate lowest flower)
            }
        }
    }
    
    return YES;
}
-(void) ccTouchEnded:(UITouch*)touch withEvent:(UIEvent*)event {
    CGPoint location = [self convertTouchToNodeSpace:touch];
    
    if(scene && ![scene isPausedWithMenu]) {
        CGPoint swipe = ccpSub(location, touchBeganLocation_);
        float swipeLength = ccpLength(swipe);
        
        if(swipeLength > 25 && swipeLength < 400) {
            //begin swipe
            if(player_.pollenMeter >= PLAYER_SWIPE_AMOUNT) {
                [player_ startSwipe];
            }
        }
    }
}

-(void) accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration {
    //low pass filter
    float lpfFilter = 0.1f;
	player_.velocity = ccp(acceleration.x*lpfFilter*PLAYER_XACCEL + player_.velocity.x*(1.0f-lpfFilter),
                          player_.velocity.y);
}

//UPDATE
-(void) update:(ccTime)dt
{
    [player_ handleHeight:self.playerHeight];
    [player_ update:dt];
    [spawner_ handleHeight:self.playerHeight];
    [spawner_ update:dt];
    [spiddder_ update:dt];
    
    //update spiddder
    if(spiddder_.waitingDisconnect && ![GameUtility isCollidingRect:player_ WithRect:spiddder_]) {
        spiddder_.waitingDisconnect = NO;
    }
    
    //update pollen meter
    [self updatePollenBar];
    
    //handle extra velocity
    if(bgLayer) {
        [bgLayer setYVelocity:player_.extraYVelocity];
    }
    [spawner_ setYVelocity:-player_.extraYVelocity];
    [spiddder_ setExtraYVelocity:-player_.extraYVelocity];
    
    self.playerHeight += player_.extraYVelocity*dt / HEIGHT_FACTOR;
    
    if(bgLayer) {//lets background know when to change level
        [bgLayer setAltitude:self.playerHeight];
    }
    
    //score labels
    [heightLabel_ setString:[NSString stringWithFormat:@"%im", (int)round(self.playerHeight)]];
    if(playerHeight_ > highScore_) [highScoreLabel_ setString:heightLabel_.string];
    
    //handle lose condition
    if(player_.dead) {
        if(playerHeight_ > highScore_) {
            [GameUtility saveHighScore:playerHeight_];
        }
        
        [[CCDirector sharedDirector] replaceScene:
         [CCTransitionFadeDown transitionWithDuration:0.5 scene:[MainMenuLayer sceneWithScore:playerHeight_]]];
        
        player_.dead = NO; //so no repeat transition is activated
    }
}

//UTILITY
-(float) getPollenMeter {
    return player_.pollenMeter;
}
-(float) getHeight {
    return size.height;
}

-(void) setScene:(GameplayScene*)s {
    scene = s;
}
-(void) setBackgroundLayer:(TreeLayer*)l {
    bgLayer = l;
}
-(void) updatePollenBar {
    pollenBar_.clipSize = ccp([pollenBar_ boundingBox].size.width*(player_.pollenMeter/PLAYER_MAX_POLLEN),
                              pollenBar_.clipSize.y);
}

@end
