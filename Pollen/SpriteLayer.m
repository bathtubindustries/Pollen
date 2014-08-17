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

#import "ComboLayer.h"

#define HEIGHT_FACTOR 15.f
#define END_COMBO_POLLEN_AMOUNT PLAYER_MAX_POLLEN/2

//if you are testing or just want to see a bunch of haikus spawn, lower this to around 50 and play
#define HAIKU_SPAWN_GAP 350
//used to be 500

@implementation SpriteLayer

@synthesize playerHeight = playerHeight_;
-(float) topBuffer { return spidderEyeCounter_.contentSize.height-1; }

-(id) init {
    if(self = [super init])
    {
        //setup
        size = [[CCDirector sharedDirector] winSize];
        scaleFactor = size.height/size.width;
        self.accelerometerEnabled = YES;
        touchEnabled=YES;
        comboPaused=NO;
        //pollen meter
        pollenBarBackground_ = [CCSprite spriteWithFile:@"tubeBack.png"];
        pollenBarBackground_.position = ccp(pollenBarBackground_.boundingBox.size.width/2,
                                            size.height-pollenBarBackground_.boundingBox.size.height/2);
        [self addChild:pollenBarBackground_ z:500];
        
        pollenBar_ = [ClipSprite spriteWithFile:@"tubeFull.png"];
        pollenBar_.position = ccp(pollenBarBackground_.position.x - pollenBar_.boundingBox.size.width-4*scaleFactor, pollenBarBackground_.position.y-10*scaleFactor);
        [pollenBar_ setClip:ccp(0, 0) :ccp([pollenBar_ boundingBox].size.height ,0)];
        [self addChild:pollenBar_ z:501];
        
        pollenBarTube_ = [CCSprite spriteWithFile:@"tubeEmpty.png"];
        pollenBarTube_.position = ccp(pollenBarBackground_.position.x-pollenBarTube_.boundingBox.size.width+2*scaleFactor,
                                            pollenBarBackground_.position.y-15*scaleFactor);
        [self addChild:pollenBarTube_ z:502];
        
        //section off top of screen
        //size.height -= [pollenBarBackground_ boundingBox].size.height;
        
        
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
        
        //player
        player_ = [PlayerSprite node];
        [self addChild:player_ z:3];
        player_.spawnLayer = self;

        
                //put this on top of high score
        spidderEyeCounter_ = [CCSprite spriteWithFile:@"spidEyeCounter.png"];
        spidderEyeCounter_.anchorPoint = ccp(0, 1);
        spidderEyeCounter_.scaleX=1.2;
        spidderEyeCounter_.position = ccp(size.width- [spidderEyeCounter_ boundingBox].size.width, size.height);
        [self addChild: spidderEyeCounter_ z:3];
        
        
        
        spidderEyeLabel_ = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",[GameUtility savedSpidderEyeCount]] fontName:@"Futura" fontSize:10*scaleFactor];
        spidderEyeLabel_.anchorPoint = ccp(.5, .5);
        spidderEyeLabel_.position = ccp( spidderEyeCounter_.position.x+spidderEyeCounter_.boundingBox.size.width/1.7 , size.height-[spidderEyeCounter_ boundingBox].size.height/1.9);
        [self addChild: spidderEyeLabel_ z:spidderEyeCounter_.zOrder+1];
        
        scoreLeaf_ = [CCSprite spriteWithFile:@"scoreLeaf.png"];
        scoreLeaf_.position= ccp(scoreLeaf_.boundingBox.size.width/2,size.height-scoreLeaf_.boundingBox.size.height/2);
        scoreLeaf_.scaleX=1.1;
        [self addChild:scoreLeaf_];
        
        
        highScore_ = [GameUtility savedHighScore];
        highScoreLabel_ = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%im", (int) highScore_]
                                             fontName:@"Futura" fontSize:12*scaleFactor];
        highScoreLabel_.anchorPoint = ccp(0, 1);
        highScoreLabel_.position = ccp(4*scaleFactor,
                                       size.height-3*scaleFactor);
        [highScoreLabel_ setColor:ccBLACK];
        [self addChild:highScoreLabel_ z:4];
        
        heightLabel_ = [CCLabelTTF labelWithString:@"0m" fontName:@"Futura" fontSize:12*scaleFactor];
        heightLabel_.anchorPoint = ccp(0, 1);
        heightLabel_.position = ccp(highScoreLabel_.position.x,
                                    highScoreLabel_.position.y - [highScoreLabel_ boundingBox].size.height);
        [heightLabel_ setColor:ccBLACK];
        [self addChild: heightLabel_ z:3];
        
        /*haikuCounter_ = [CCSprite spriteWithFile:@"haikuUI.png"];
        haikuCounter_.scale=.16;
        haikuCounter_.position = ccp(size.width - [haikuCounter_ boundingBox].size.width*1.4, size.height - [haikuCounter_ boundingBox].size.height*1.25);
        [self addChild: haikuCounter_ z:0];
        
        haikuLabel_ = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"X%i", [GameUtility savedHaikuCount]]
                                             fontName:@"Futura" fontSize:12*scaleFactor];
        haikuLabel_.anchorPoint = ccp(0, 1);
        haikuLabel_.position = ccp(haikuCounter_.position.x+[haikuCounter_ boundingBox].size.width/2,haikuCounter_.position.y);
        [self addChild:haikuLabel_ z:0];*/


        
        //set to 4 to see lots of eyes drop
        self.treeLevel=1;
        
        playerHeight_ = 0;
        
        //music
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        
        //combo fx
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"bloop1.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"bloop2.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"bloop3.wav"];
        
        
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
        addTargetedDelegate:self priority:2 swallowsTouches:NO];
}
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [self convertTouchToNodeSpace:touch];
    
    if(scene && ![scene isPausedWithMenu] && touchEnabled)
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
                

                
            }
        }
        
        [player_ startAttack];
        if(player_.state != Boosting)
        for(Flower* flower in spawner_.flowers) {
            if(!flower.bloomed && [GameUtility isCollidingRect:player_ WithRect:(CCSprite*)flower]) {
                [flower bloomFlowerWithPower:100];
                if(flower.bloomed) {
                    [player_ startJump];
                }
                break; //used to bloom only one flower at a time (will activate lowest flower)
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
    
    
    if (comboPaused && player_.state==Combo)
    {
        [comboLayer_ resumeSchedulerAndActions];
        comboPaused=NO;
    }
    
    //updates and handling height
    [player_ handleHeight:self.playerHeight];
    [player_ update:dt];
    [spawner_ handleHeight:self.playerHeight];
    [spawner_ update:dt];
    [haikuSpawner_ update:dt];
    [spiddder_ update:dt];
    if ([[self children] containsObject:comboLayer_])
    {
        [comboLayer_ update:dt];
    }
    if ([spidderEyeLabel_.string intValue] != [GameUtility savedSpidderEyeCount])
    {
        [spidderEyeLabel_ setString:[NSString stringWithFormat:@"%d",[GameUtility savedSpidderEyeCount]]];
        CCScaleBy * scale1 = [CCScaleTo actionWithDuration:.15 scale:1.5];
        CCScaleBy * scale2 = [CCScaleTo actionWithDuration:.15 scale:1.0];
        id seq = [CCSequence actions: scale1, scale2,nil];
        [spidderEyeLabel_ runAction:seq];
    }
    
    if (player_.state == ComboBoost)
    {
        
        if (player_.position.y >= spiddder_.position.y-50*scaleFactor || spiddder_.waitingDisconnect){
            
            player_.state=Combo;
            spiddder_.waitingDisconnect=NO;
            [spiddder_ setComboMode:YES shouldFall:NO];
            
        }
    }
    else if (player_.state == Combo)
    {
        
        player_.velocity = CGPointMake(player_.velocity.x,0 );
        player_.extraYVelocity = spiddder_.velocity.y;
        if (!comboTransitionStarted)
        {
            
            comboLayer_ = [ComboLayer node];
            [comboLayer_ setSpawnLayer:self];
            [self addChild:comboLayer_ z:1000];
            [comboLayer_ setScene:scene];
            //[player_ setZOrder:player_.zOrder+10]; player might be confused on mechanic if bug is still on closest layer
            [spiddder_ setZOrder:spiddder_.zOrder+1000];
            [spidderEyeCounter_ setZOrder:spiddder_.zOrder+1000];
            [spidderEyeLabel_ setZOrder:spiddder_.zOrder+1000];
            spiddder_.position= CGPointMake (spiddder_.position.x, size.height*8/9);
            [self startComboTransition];
        }
        comboTransitionStarted=YES; //dont set this to false until state is no longer combo
    }
    if (player_.pollenMeter >= PLAYER_MAX_POLLEN )
    {
        [player_ startComboBoost];
        player_.pollenMeter=END_COMBO_POLLEN_AMOUNT;
        //if spidder is too far away, have him fall down to meet player
        if (spiddder_.position.y - player_.position.y >=200)
        {
            [spiddder_ setComboMode:YES shouldFall:YES];
        }
        else
        {
            [spiddder_ setComboMode:YES shouldFall:NO];
        }
    }
    if (player_.state == ComboBoost)
    {
        touchEnabled=NO;
    }
    
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
    if (((int)playerHeight_ % HAIKU_SPAWN_GAP==0) && !scene.tutorialActive && (int)playerHeight_!=0)
    {
        [haikuSpawner_ spawnHaiku:((int)playerHeight_ / HAIKU_SPAWN_GAP)];
    }
    
    //score labels
    [heightLabel_ setString:[NSString stringWithFormat:@"%im", (int)round(self.playerHeight)]];
    if(playerHeight_ > highScore_) [highScoreLabel_ setString:heightLabel_.string];
    
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


-(void) startComboTransition
{
    CCSprite* banner= [CCSprite spriteWithFile:@"comboBanner1.png"];
    banner.position = ccp(-banner.contentSize.width *scaleFactor, size.height/2);
    [self addChild:banner z:1015];
    banner.visible=YES;
    [banner runAction:[CCSequence actionWithArray:[NSArray arrayWithObjects:
                                                   [CCMoveTo actionWithDuration:.15 position:ccp(size.width/2,size.height/2)],
                                                   [CCDelayTime actionWithDuration:.2],
                                                   [CCCallBlock actionWithBlock:^(void){
                                                    [banner setTexture:[[CCTextureCache sharedTextureCache] addImage:@"comboBanner2.png"]];
                                                    }],
                                                   [CCDelayTime actionWithDuration:.2],
                                                   [CCCallBlock actionWithBlock:^(void){
                                                    [banner setTexture:[[CCTextureCache sharedTextureCache] addImage:@"comboBanner1.png"]];
                                                    }],
                                                   [CCDelayTime actionWithDuration:.2],
                                                   [CCCallBlock actionWithBlock:^(void){
                                                    [banner setTexture:[[CCTextureCache sharedTextureCache] addImage:@"comboBanner2.png"]];
                                                    }],
                                                   [CCDelayTime actionWithDuration:.2],
                                                   [CCCallBlock actionWithBlock:^(void){
                                                    [banner setTexture:[[CCTextureCache sharedTextureCache] addImage:@"comboBanner1.png"]];
                                                    }],
                                                    [CCDelayTime actionWithDuration:.2],
                                                    [CCCallBlock actionWithBlock:^(void){
                                                    [banner setTexture:[[CCTextureCache sharedTextureCache] addImage:@"comboBanner2.png"]];
                                                    }],
                                                   [CCMoveTo actionWithDuration:.15 position:ccp(size.width+banner.contentSize.width*scaleFactor,size.height/2)],
                                                   [CCCallBlock actionWithBlock:^(void){
                                                    banner.visible=NO;
                                                    [self removeChild:banner];
                                                    }],
                                                   nil]]
     ];
    
}


-(void) pauseCombo{
    
    if ([[self children] containsObject:comboLayer_] && player_.state==Combo)
    {
        [comboLayer_ pauseSchedulerAndActions]; //interrupts the ccaction that spawns all nodes
        comboPaused=YES;
    }
}
-(void) comboEnded{
    
    [self removeChild:comboLayer_];
    
    
    [spiddder_ setZOrder:spiddder_.zOrder-1000];
    [spidderEyeCounter_ setZOrder:spiddder_.zOrder-1000];
    [spidderEyeLabel_ setZOrder:spiddder_.zOrder-1000];
    
    
    
    
    touchEnabled=YES;
    comboTransitionStarted=NO;
    [spiddder_ setComboMode:NO shouldFall:NO];
    player_.pollenMeter= END_COMBO_POLLEN_AMOUNT;
    [player_ startBoost];
    player_.comboEnding=YES;
    comboPaused=NO;
    
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
    pollenBar_.clipSize = ccp(pollenBar_.clipSize.x,
                                 [pollenBar_ boundingBox].size.height*(player_.pollenMeter/PLAYER_MAX_POLLEN));
}

@end
