//
//  MainMenuLayer.m
//  jesusgetshigh
//
//  Created by garv on 4/3/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "MainMenuLayer.h"

#import "GameplayScene.h"
#import "StoreLayer.h"

#import "SimpleAudioEngine.h"
#import "GameUtility.h"

@implementation MainMenuLayer

-(id) init {
    return [self initWithScore:0];
}
-(id) initWithScore:(float)prevScore {
    if(self = [super init]) {
        
       
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        float scaleFactor = size.height/size.width;
        
        [self setColor:ccc3(162, 160, 36)];
        [self setOpacity:255];
        
        //game title
        CCSprite *gameTitle = [CCSprite spriteWithFile:@"title.png"];
        gameTitle.position = ccp(size.width/2, size.height/2);
        gameTitle.scale = 0.9;
        [self addChild:gameTitle];
        
        
        
        
        
        //high score label
        if(!([GameUtility savedHighScore] == 0 && prevScore == 0)) {
            CCLabelTTF *highScoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%im / %im",
                                                                      (int) prevScore, (int) [GameUtility savedHighScore]]
                                                           fontName:@"Futura" fontSize:20*scaleFactor];
            highScoreLabel.position = ccp(size.width/2, size.height - 32);
            [highScoreLabel setColor:ccBLACK];
            [self addChild:highScoreLabel];
        }
        
        //tap to play
        CCLabelTTF *newGameLabel = [CCLabelTTF labelWithString:@"( tap anywhere to start )"
                                                      fontName:@"Futura" fontSize:14*scaleFactor];
        newGameLabel.position = ccp(size.width/2,
                                    gameTitle.position.y - [gameTitle boundingBox].size.height*3/4);
        [self addChild:newGameLabel];
        
        //menu
        [CCMenuItemFont setFontName:@"Futura"];
        [CCMenuItemFont setFontSize:(24*scaleFactor)];
        
        CCMenuItem *itemStore = [CCMenuItemFont itemWithString:@"store" block:^(id sender) {
            #warning store button acting as score reset - debug only!
            [GameUtility saveHighScore:0];
            [GameUtility HaikuDiscovered:@"Instruct" discoverable:YES];
            [[CCDirector sharedDirector] replaceScene:
             [CCTransitionSlideInB transitionWithDuration:0.5 scene:[StoreLayer scene]]];
        }];
        [itemStore setColor:ccBLACK];
        
        
        
        
        CCMenuItem *leaderBoard = [CCMenuItemFont itemWithString:@"leaderboard" block:^(id sender) {
            [self showLeaderboard];
            
            
        }];
        [leaderBoard setColor:ccBLACK];
        
        
        // Sound on/off toggle
        CCMenuItem *soundOnItem = [CCMenuItemImage itemFromNormalImage:@"muteOn.png"
                                                         selectedImage:@"muteOn.png"
                                                                target:nil
                                                              selector:nil];
        
        CCMenuItem *soundOffItem = [CCMenuItemImage itemFromNormalImage:@"muteOff.png"
                                                          selectedImage:@"muteOff.png"
                                                                 target:nil
                                                               selector:nil];
        
        CCMenuItemToggle * soundToggleItem;
        
        if ([[SimpleAudioEngine sharedEngine] mute])
            soundToggleItem = [CCMenuItemToggle itemWithTarget:self
                                                      selector:@selector(soundButtonTapped:)
                                                         items:soundOffItem, soundOnItem, nil];
        else
            soundToggleItem = [CCMenuItemToggle itemWithTarget:self
                                                      selector:@selector(soundButtonTapped:)
                                                         items:soundOnItem, soundOffItem, nil];


        CCMenu *menu = [CCMenu menuWithItems:itemStore, leaderBoard, soundToggleItem, nil];
		[menu alignItemsVerticallyWithPadding:2*scaleFactor];
        [menu setPosition:ccp(size.width/2, 80)];
		[self addChild:menu];
        
        
        
        
        //music
        //[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"mainMenu.wav" loop:YES];
        volumeLevel=[[SimpleAudioEngine sharedEngine] effectsVolume];
    }
    return self;
}

-(void) soundButtonTapped: (id) sender
{
 	if ([[SimpleAudioEngine sharedEngine] mute]) {
        // This will unmute the sound
        [[SimpleAudioEngine sharedEngine] setMute:0];
    }
    else {
        //This will mute the sound
        [[SimpleAudioEngine sharedEngine] setMute:1];
    }
}


//Game Center functions
- (void) showLeaderboard{
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
    if (leaderboardController != NULL)
    {
        leaderboardController.timeScope = GKLeaderboardTimeScopeAllTime;
        leaderboardController.leaderboardDelegate = self;
        [[CCDirector sharedDirector] presentViewController:leaderboardController animated:YES completion:^(void){}];
    }

}

- (void) leaderboardViewControllerDidFinish: (GKLeaderboardViewController *)viewController{
    
    
    [[CCDirector sharedDirector] dismissModalViewControllerAnimated: YES];
   
}








-(void) onEnter {
    [super onEnter];
    [self registerWithTouchDispatcher];
    
}
-(void) onExit {
    [super onExit];
    [[CCDirector sharedDirector].touchDispatcher removeDelegate:self];
}

//INPUT
-(void) registerWithTouchDispatcher {
    [[CCDirector sharedDirector].touchDispatcher
     addTargetedDelegate:self priority:0 swallowsTouches:YES];
}
-(BOOL) ccTouchBegan:(UITouch*)touch withEvent:(UIEvent*)event {
    [MainMenuLayer startGame];
    
    return YES;
}



//UTILITY
+(CCScene*) scene {
    return [MainMenuLayer sceneWithScore:0];
}
+(CCScene*) sceneWithScore:(float)prevScore {
    CCScene *scene = [CCScene node];
    MainMenuLayer *layer = [[[MainMenuLayer alloc] initWithScore:prevScore] autorelease];
    
    [scene addChild:layer];
    return scene;
}

+(void) startGame {
    [[CCDirector sharedDirector] replaceScene:
     [CCTransitionFadeUp transitionWithDuration:0.5 scene:[GameplayScene node]]];
}

@end
