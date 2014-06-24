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
#import "GameOverLayer.h"

#import "PlayerSprite.h"
#import "FlowerSpawner.h"
#import "Flower.h"
#import "Spiddderoso.h"
#import "SpidderEye.h"

#import "ClipSprite.h"
#import "GameUtility.h"
#import "SimpleAudioEngine.h"
#import "HaikuSpawner.h"
#import "Haiku.h"

#define HEIGHT_FACTOR 15.f

//if you are testing or just want to see a bunch of haikus spawn, lower this to around 50 and play
#define HAIKU_SPAWN_GAP 500

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
        player_.spawnLayer = self;
        
        //spawner
        spawner_ = [[FlowerSpawner alloc] init];
        [spawner_ setSpawnLayer:self];
        [spawner_ setParticleAmount:INITIAL_FLOWER_AMOUNT];
        
        haikuSpawner_ = [[HaikuSpawner alloc]init];
        [haikuSpawner_ setSpawnLayer:self];
        
        //spiddder
        spiddder_ = [Spiddderoso node];
        [self addChild:spiddder_ z:2];
        //eyes
        eyes_ = [[NSMutableArray alloc] init];
        eyesToRemove_ = [[NSMutableArray alloc] init];
        
        //height
        float scaleFactor = size.height/size.width;
        
                //put this on top of high score
        spidderEyeCounter_.anchorPoint = ccp(0, 1);
         [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"spidderEyeCounter.plist"];
        spidderEyeCounter_ = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"counter1.png"]]];
        spidderEyeCounter_.scale=1.10;
        spidderEyeCounter_.position = ccp(1 + [spidderEyeCounter_ boundingBox].size.width/2, size.height - [spidderEyeCounter_ boundingBox].size.height/2);
        [self addChild: spidderEyeCounter_ z:0];
        counterAnimFrames = [[NSMutableArray alloc]init ];
        
        
        
        spidderEyeLabel_ = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",[GameUtility savedSpidderEyeCount]] fontName:@"Futura" fontSize:10*scaleFactor];
        spidderEyeLabel_.anchorPoint = ccp(0, 1);
        spidderEyeLabel_.position = ccp( [spidderEyeCounter_ boundingBox].size.width*.6 , size.height-[spidderEyeCounter_ boundingBox].size.height/4);
        [self addChild: spidderEyeLabel_ z:spidderEyeCounter_.zOrder+1];
        
        highScore_ = [GameUtility savedHighScore];
        highScoreLabel_ = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%im", (int) highScore_]
                                             fontName:@"Futura" fontSize:12*scaleFactor];
        highScoreLabel_.anchorPoint = ccp(0, 1);
        highScoreLabel_.position = ccp(4,
                                       spidderEyeCounter_.position.y - [spidderEyeCounter_ boundingBox].size.height/2);
        [self addChild:highScoreLabel_ z:4];
        
        heightLabel_ = [CCLabelTTF labelWithString:@"0m" fontName:@"Futura" fontSize:12*scaleFactor];
        heightLabel_.anchorPoint = ccp(0, 1);
        heightLabel_.position = ccp(highScoreLabel_.position.x,
                                    highScoreLabel_.position.y - [highScoreLabel_ boundingBox].size.height);
        [self addChild: heightLabel_ z:3];
        
        haikuCounter_ = [CCSprite spriteWithFile:@"haikuUI.png"];
        haikuCounter_.scale=.16;
        haikuCounter_.position = ccp(size.width - [haikuCounter_ boundingBox].size.width*1.4, size.height - [haikuCounter_ boundingBox].size.height*1.25);
        [self addChild: haikuCounter_ z:0];
        
        haikuLabel_ = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"X%i", [GameUtility savedHaikuCount]]
                                             fontName:@"Futura" fontSize:12*scaleFactor];
        haikuLabel_.anchorPoint = ccp(0, 1);
        haikuLabel_.position = ccp(haikuCounter_.position.x+[haikuCounter_ boundingBox].size.width/2,haikuCounter_.position.y);
        [self addChild:haikuLabel_ z:0];


        
        //set to 4 to see lots of eyes drop
        self.treeLevel=1;
        
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
                
                [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"spidderEyeDrop.plist"];
                eyeSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"spidderEyeDrop.png"];
                [self addChild:eyeSpriteSheet];
                
                //drop an eye
                //spidder eye animation
                for (int i=0;i<self.treeLevel*2;i++){
                    eyeAnimFrames = [NSMutableArray array];
                    for (int i=1; i<=16; i++) {
                        [eyeAnimFrames addObject:
                         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                          [NSString stringWithFormat:@"eye%d.png",i]]];
                    }
                    eyeAnim = [CCAnimation animationWithSpriteFrames:eyeAnimFrames delay:0.1f];
                    [eyes_ addObject:[[SpidderEye alloc] init ]];
                    CCAction * flash =[CCAnimate actionWithAnimation:eyeAnim];
                    
                    ((SpidderEye*)[eyes_ lastObject]).position = ccp(spiddder_.position.x, spiddder_.position.y);
                    [[eyes_ lastObject] runAction:[CCScaleTo actionWithDuration:0.0 scale:1.5]];
                    [[eyes_ lastObject] runAction:flash];
                    [eyeSpriteSheet addChild:[eyes_ lastObject]];
                }
                
                
                [GameUtility saveSpidderEyeCount:([GameUtility savedSpidderEyeCount]+self.treeLevel*2)];
                
                [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"spidderEyeCounter.plist"];
                counterSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"spidderEyeCounter.png"];
                [self addChild:counterSpriteSheet];
                
                CCSprite * spidderCounter  = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"counter1.png"]]];
                counterAnimFrames = [NSMutableArray array];
                
                for (int i=1; i<=14; i++) {
                    if (i!=10)
                        [counterAnimFrames addObject:
                         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                          [NSString stringWithFormat:@"counter%d.png",i]]];
                    else{
                        [counterAnimFrames addObject:
                         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                          [NSString stringWithFormat:@"count%d.png",i]]];
                    }
                }
                
                counterAnim = [CCAnimation animationWithSpriteFrames:counterAnimFrames delay:0.1f];
                CCAction * eyeCounterFlash =[CCAnimate actionWithAnimation:counterAnim];
                spidderCounter.visible=YES;
                
                [spidderCounter runAction:eyeCounterFlash];
                spidderCounter.scale=1.25;
                spidderCounter.position= ccp(spidderEyeCounter_.position.x, spidderEyeCounter_.position.y);
                if (spidderEyeCounter_.visible) //sets the static counter to invisible once the animated counter appears
                    spidderEyeCounter_.visible=NO;
                [counterSpriteSheet addChild:spidderCounter];
                [spidderEyeLabel_ setString:[NSString stringWithFormat:@"%d",[GameUtility savedSpidderEyeCount]]];
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
    //updates and handling height
    [player_ handleHeight:self.playerHeight];
    [player_ update:dt];
    [spawner_ handleHeight:self.playerHeight];
    [spawner_ update:dt];
    [haikuSpawner_ update:dt];
    [spiddder_ update:dt];
    
    //removes spidder eye drops when they leave screen
    if ([eyes_ count]!=0) {
        for (SpidderEye* eye in eyes_){
            if (eye.visible){
                [eye update:dt];
            }
            else{
                [eyesToRemove_ addObject:eye];
            }
        }
    }
    
    [eyes_ removeObjectsInArray:eyesToRemove_];
    [eyesToRemove_ removeAllObjects];
    
    
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
    [haikuSpawner_ setYVelocity:-player_.extraYVelocity];
    
    
    [spiddder_ setExtraYVelocity:-player_.extraYVelocity];
    
    self.playerHeight += player_.extraYVelocity*dt / HEIGHT_FACTOR;
    
    
    if(bgLayer) {//lets background know when to change level
        [bgLayer setAltitude:self.playerHeight];
    }
    
    //spawn haiku every specified number of meters
    if (((int)playerHeight_ % HAIKU_SPAWN_GAP==0) && !scene.tutorialActive)
        [haikuSpawner_ spawnHaiku:((int)playerHeight_ / HAIKU_SPAWN_GAP)];
    

    
    
    //score labels
    [heightLabel_ setString:[NSString stringWithFormat:@"%im", (int)round(self.playerHeight)]];
    if(playerHeight_ > highScore_) [highScoreLabel_ setString:heightLabel_.string];
    //haiku label
    [haikuLabel_ setString:[NSString stringWithFormat:@"X%i", [GameUtility savedHaikuCount]]];
    
    //handle lose condition
    if(player_.dead) {
        if(playerHeight_ > highScore_) {
            [GameUtility saveHighScore:playerHeight_];
        }
        
        if ([[GameKitHelper sharedGameKitHelper] localPlayerIsAuthenticated]){
        [[GameKitHelper sharedGameKitHelper]
         submitScore:(int64_t)playerHeight_
         category:@"PollenBug_Leaderboard"];
        }
        
        player_.dead = NO; //so no repeat transition is activated
        
        
        
        
        //Checks if player wants to continue by consuming a haiku
        
        [scene  activateContinueCheck: playerHeight_];
    }
}


-(void) revivePlayer{
    
    CGPoint respawnPoint;
    BOOL respawnFound=NO;
   
    player_.pollenMeter= PLAYER_MAX_POLLEN/2;
    [player_ startBoost];
    
    //find a good flower to respawn above
    for(Flower* flower in spawner_.flowers) {
        if (!flower.bloomed && flower.visible && fabsf(flower.position.x - (size.width/2))<size.width/3 && fabsf(flower.position.y - (size.height/2))<size.height/3)
        {
            respawnPoint = flower.position;
            respawnFound=YES;
        }
    
    }
    //or respawn in middle of screen if no good flower
    if (!respawnFound){
        respawnPoint = ccp(size.width/2,size.height/2);
    }
    player_.position = respawnPoint;
    player_.dead=NO;
    [player_ startJump];
    
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
