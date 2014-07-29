//
//  MainMenuLayer.m
//  jesusgetshigh
//
//  Created by garv on 4/3/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "MainMenuLayer.h"

#import "GameplayScene.h"

#import "StoreScene.h"

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
        
        //game title
        CCSprite * gameTitle;
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
			gameTitle = [CCSprite spriteWithFile:@"Default.png"];
			//background.rotation = 90;
		} else {
			gameTitle = [CCSprite spriteWithFile:@"Default-Landscape~ipad.png"];
		}
        gameTitle.position = ccp(size.width/2, size.height/2);
        gameTitle.scale = 1;
        [self addChild:gameTitle z:-103];
        
        
        NSMutableArray * circles = [NSMutableArray arrayWithObjects:[CCSprite spriteWithFile:@"breathingDot.png"],[CCSprite spriteWithFile:@"breathingDot.png"],[CCSprite spriteWithFile:@"breathingDot.png"],[CCSprite spriteWithFile:@"breathingDot.png"], nil];
        int index=1;
        
        for (CCSprite* circle  in circles)
        {
            circle.scale= [GameUtility randDub:.4 :.9];
            CCDelayTime *delay = [CCDelayTime actionWithDuration:[GameUtility randDub:.0 :1.0]];
            if (index==1)
            {
                circle.position=CGPointMake(-40 * scaleFactor + size.width/2, 65+scaleFactor+ size.height/2);
                circle.scale+=.5;
            }
            else if (index==2)
            {
                circle.position=CGPointMake([circle boundingBox].size.width/2, size.height);
            }
            else if (index==3)
            {
                circle.position=CGPointMake(size.width -[circle boundingBox].size.width*2, -55*scaleFactor + size.height/2);
            }
            else
            {
                circle.position=ccp(5*scaleFactor, 5*scaleFactor);
            }
            [self addChild:circle z:-99];
            
            id trigger = [CCCallFuncND actionWithTarget:self selector:@selector(triggerRepeatScaleForSprite:) data:(CCSprite*)circle];
            id seq = [CCSequence actions:delay,trigger,nil];
            [circle runAction:seq];
            index++;
        }

        
        
        NSMutableArray * letters = [NSMutableArray arrayWithObjects:[CCSprite spriteWithFile:@"letterP.png"],[CCSprite spriteWithFile:@"letterO.png"],[CCSprite spriteWithFile:@"letterL1.png"],[CCSprite spriteWithFile:@"letterL2.png"],[CCSprite spriteWithFile:@"letterE.png"],[CCSprite spriteWithFile:@"letterN.png"], nil];
        
        int positioner=1;
        for (CCSprite* letter in letters)
        {
            CCDelayTime *delay = [CCDelayTime actionWithDuration:[GameUtility randDub:.0 :1.0]];
            int adjustO = (positioner==2)?5:0;
            int adjustN = (positioner==6)?-5:0;
            letter.position = CGPointMake((-15-adjustO-adjustN)*scaleFactor + positioner*[letter boundingBox].size.width/2 , size.height/2);
            letter.scale=.75;
            [self addChild:letter z:-100];
            id trigger = [CCCallFuncND actionWithTarget:self selector:@selector(triggerRepeatBounceForSprite:) data:(CCSprite*)letter];
            id seq = [CCSequence actions:delay,trigger,nil];
            [letter runAction:seq];
            positioner++;
        }
        
        
        
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
                                    170);
        [self addChild:newGameLabel];
        
        //menu
        [CCMenuItemFont setFontName:@"Futura"];
        [CCMenuItemFont setFontSize:(24*scaleFactor)];
        
        CCMenuItem *itemStore = [CCMenuItemFont itemWithString:@"store" block:^(id sender) {
            #warning store button acting as score reset - debug only!
            [GameUtility saveHighScore:0];
            [GameUtility HaikuDiscovered:@"Instruct" discoverable:YES];
            [[CCDirector sharedDirector] replaceScene:
            [CCTransitionFadeUp transitionWithDuration:0.5 scene:[StoreScene node]]];
        }];
        [itemStore setColor:ccBLACK];
        
        
        
        
        CCMenuItem *leaderBoard = [CCMenuItemFont itemWithString:@"leaderboard" block:^(id sender) {
            [self showLeaderboard];
            
            
        }];
        [leaderBoard setColor:ccBLACK];
        
        
        // Sound on/off toggle
        CCMenuItem *soundOnItem = [CCMenuItemImage itemWithNormalImage:@"muteOn.png"
                                                         selectedImage:@"muteOn.png"
                                                                target:nil
                                                              selector:nil];
        
        CCMenuItem *soundOffItem = [CCMenuItemImage itemWithNormalImage:@"muteOff.png"
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


- (void) triggerRepeatBounceForSprite:(CCSprite*) sprite
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    float scaleFactor = size.height/size.width;
    float dur1 = [GameUtility randDub:.6 :.9];
    float dur2 = dur1-.2;
    float dur3 = dur2-.1;
    CCMoveBy * down1 =[CCMoveBy actionWithDuration:dur1 position:CGPointMake(0, -6*scaleFactor)];
    CCMoveBy * down2 =[CCMoveBy actionWithDuration:dur2 position:CGPointMake(0, -2.75*scaleFactor)];
    CCMoveBy * down3 =[CCMoveBy actionWithDuration:dur3 position:CGPointMake(0, -1*scaleFactor)];
    id seq = [CCSequence actions: down1,down2,down3,[down3 reverse],[down2 reverse],[down1 reverse],nil];
    id repeat = [CCRepeatForever actionWithAction:seq];
    
    [sprite runAction:repeat];
}

- (void) triggerRepeatScaleForSprite:(CCSprite*) sprite
{
    CCScaleBy * scale1 = [CCScaleBy actionWithDuration:2.3 scale:[GameUtility randDub:1.8 :2.2]];
    id seq = [CCSequence actions: scale1, [scale1 reverse],nil];
    id repeat = [CCRepeatForever actionWithAction:seq];
    
    [sprite runAction:repeat];
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
