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

#import "HaikuGalleryLayer.h"

@implementation MainMenuLayer

-(id) init {
    return [self initWithScore:0];
}
-(id) initWithScore:(float)prevScore {
    if(self = [super init]) {
        CGSize size = [[CCDirector sharedDirector] winSize];
        float scaleFactor = size.height/size.width;
        
        if ([GameUtility savedHighScore] <=0)
        {
            [GameUtility isTutorialNeeded:YES];
        }
        else
        {
            [GameUtility isTutorialNeeded:NO];
        }
        
        //game title
        CCSprite * gameTitle;
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
			gameTitle = [CCSprite spriteWithFile:@"MainMenu.png"];
			//background.rotation = 90;
		} else {
			gameTitle = [CCSprite spriteWithFile:@"MainMenu-Landscape~ipad.png"];
		}
        gameTitle.position = ccp(size.width/2, size.height/2);
        gameTitle.scaleY = scaleFactor;
        [self addChild:gameTitle z:-103];
        
        
        NSMutableArray * circles = [NSMutableArray arrayWithObjects:[CCSprite spriteWithFile:@"breathingDot.png"],[CCSprite spriteWithFile:@"breathingDot.png"],[CCSprite spriteWithFile:@"breathingDot.png"],[CCSprite spriteWithFile:@"breathingDot.png"], nil];
        int index=1;
        
        for (CCSprite* circle  in circles)
        {
            double scaleOne = (index==1) ? .5 : 0;
            CCScaleTo * initScale = [CCScaleTo actionWithDuration:2.3 scale:[GameUtility randDub:.4 :.9] + scaleOne];
            
            circle.scale=0.0;
            if (index==1)
            {
                circle.position=CGPointMake(-40 * scaleFactor + size.width/2, 65+scaleFactor+ size.height/2);
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
            id seq = [CCSequence actions:initScale,trigger,nil];
            [circle runAction:seq];
            index++;
        }

        
        
        NSMutableArray * letters = [NSMutableArray arrayWithObjects:[CCSprite spriteWithFile:@"letterP.png"],[CCSprite spriteWithFile:@"letterO.png"],[CCSprite spriteWithFile:@"letterL1.png"],[CCSprite spriteWithFile:@"letterL2.png"],[CCSprite spriteWithFile:@"letterE.png"],[CCSprite spriteWithFile:@"letterN.png"], nil];
        
        int positioner=1;
        for (CCSprite* letter in letters)
        {
            CCDelayTime *initialDelay = [CCDelayTime actionWithDuration:1.5];
            CCDelayTime *delay = [CCDelayTime actionWithDuration:[GameUtility randDub:.0 :1.0]];
            int adjustO = (positioner==2)?5:0;
            int adjustN = (positioner==6)?-5:0;
            letter.position = CGPointMake((-15-adjustO-adjustN)*scaleFactor + positioner*[letter boundingBox].size.width/2 , size.height/2);
            letter.scale=.75;
            [self addChild:letter z:1];
            id trigger = [CCCallFuncND actionWithTarget:self selector:@selector(triggerRepeatBounceForSprite:) data:(CCSprite*)letter];
            id seq = [CCSequence actions:initialDelay,delay,trigger,nil];
            [letter runAction:seq];
            positioner++;
        }
        
        
        
        //high score label
        if(!([GameUtility savedHighScore] == 0 && prevScore == 0)) {
            CCLabelTTF *highScoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%im",
                                                                       (int) [GameUtility savedHighScore]]
                                                           fontName:@"Futura" fontSize:24*scaleFactor];
            highScoreLabel.position = ccp(size.width/2, size.height - 32);
            [highScoreLabel setColor:ccBLACK];
            [self addChild:highScoreLabel];
        }
        
        //menu
        [CCMenuItemFont setFontName:@"Chalkduster"];
        [CCMenuItemFont setFontSize:(24*scaleFactor)];
        
        CCMenuItem *itemStore = [CCMenuItemFont itemWithString:@"store" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:
            [CCTransitionFadeUp transitionWithDuration:0.5 scene:[StoreScene node]]];
        }];
        [itemStore setColor:ccBLACK];
        
        
        CCMenuItem *play = [CCMenuItemFont itemWithString:@"play" block:^(id sender) {
            [MainMenuLayer startGame];
            
            
        }];
        [play setColor:ccBLACK];
        
        



        CCMenu *menu = [CCMenu menuWithItems:play, itemStore, nil];
		[menu alignItemsVerticallyWithPadding:2*scaleFactor];
        [menu setPosition:ccp(size.width/2, 80*scaleFactor)];
		[self addChild:menu];
        
        
        CCMenuItem *leaderBoard = [CCMenuItemImage itemWithNormalImage:@"leaderIcon.png" selectedImage:@"leaderIcon.png" disabledImage:nil block:^(id sender){
            [self showLeaderboard];
            
            
        }];
        
        CCMenuItem *haikuWrite = [CCMenuItemImage itemWithNormalImage:@"heartIcon.png" selectedImage:@"heartIcon.png" disabledImage:nil block:^(id sender){
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[HaikuGalleryLayer scene] ]];
        }];
        
        CCMenuItem *tutIcon = [CCMenuItemImage itemWithNormalImage:@"tutorialIcon.png" selectedImage:@"tutorialIcon.png" disabledImage:nil block:^(id sender){
            [GameUtility isTutorialNeeded:YES];
            [MainMenuLayer startGame];
        }];
        
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
        CCMenu *iconMenu = [CCMenu menuWithItems:leaderBoard,haikuWrite,tutIcon, soundToggleItem,nil];
        
        [iconMenu alignItemsHorizontallyWithPadding:10*scaleFactor];
        [iconMenu setPosition:ccp(size.width/2, 20*scaleFactor)];
		[self addChild:iconMenu];
        
        
        
        
        //ui counters
        spidderEyeCounter_ = [CCSprite spriteWithFile:@"spidEyeCounter.png"];
        spidderEyeCounter_.anchorPoint = ccp(0, 1);
        spidderEyeCounter_.scale = 1.15;
        spidderEyeCounter_.position = ccp(size.width- [spidderEyeCounter_ boundingBox].size.width, size.height);
        
        
        spidderEyeLabel_ = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",[GameUtility savedSpidderEyeCount]] fontName:@"Futura" fontSize:11.4*scaleFactor];
        spidderEyeLabel_.anchorPoint = ccp(0, 1);
        spidderEyeLabel_.position = ccp(spidderEyeCounter_.position.x+spidderEyeCounter_.boundingBox.size.width/2.6,
                                        size.height - 1*scaleFactor);

        
        haikuCounter_ = [CCSprite spriteWithFile:@"haikuUI.png"];
        haikuCounter_.scale=.15;
        haikuCounter_.position = ccp([haikuCounter_ boundingBox].size.width/1.85,
                                     size.height - [haikuCounter_ boundingBox].size.height/2 + 2.5f*scaleFactor);

        
        haikuLabel_ = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"X%i", [GameUtility savedHaikuCount]]
                                         fontName:@"Futura" fontSize:12*scaleFactor];
        haikuLabel_.anchorPoint = ccp(0, 0.6);
        haikuLabel_.position = ccp(haikuCounter_.position.x+[haikuCounter_ boundingBox].size.width/2,haikuCounter_.position.y);
        
        if(!([GameUtility savedHighScore] == 0 && prevScore == 0)) {
            [self addChild: spidderEyeCounter_ z:3];
            [self addChild: spidderEyeLabel_ z:spidderEyeCounter_.zOrder+1];
            [self addChild: haikuCounter_ z:0];
            [self addChild:haikuLabel_ z:0];
        }

        
        
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
    float dur1 = [GameUtility randDub:.3 :.45];
    float dur2 = dur1-.1;
    float dur3 = dur2-.05;
    
    CCMoveBy * down00 =[CCMoveBy actionWithDuration:dur3 position:CGPointMake(0, -.5*scaleFactor)];
    CCMoveBy * down0 =[CCMoveBy actionWithDuration:dur2 position:CGPointMake(0, -1.3*scaleFactor)];
    CCMoveBy * down1 =[CCMoveBy actionWithDuration:dur1 position:CGPointMake(0, -3*scaleFactor)];
    CCMoveBy * down2 =[CCMoveBy actionWithDuration:dur2 position:CGPointMake(0, -1.3*scaleFactor)];
    CCMoveBy * down3 =[CCMoveBy actionWithDuration:dur3 position:CGPointMake(0, -.5*scaleFactor)];
    id seq = [CCSequence actions: down00, down0, down1,down2,down3,[down3 reverse],[down2 reverse],[down1 reverse], [down0 reverse], [down00 reverse], nil];
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
