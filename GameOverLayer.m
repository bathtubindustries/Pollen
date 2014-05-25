//
//  GameOverLayer.m
//  PollenBug
//
//  Created by Eric Nelson on 5/19/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "GameOverLayer.h"
#import "GameplayScene.h"
#import "MainMenuLayer.h"
#import "FriendsPickerViewController.h"

@implementation GameOverLayer
-(id) initWithScore:(float)score {
    if(self = [super init]) {
        CCSprite *img = [CCSprite spriteWithFile:@"treebody4.png"];
        img.anchorPoint = ccp(0, 0);
        img.position = ccp(0, 0);
        [self addChild:img];
        
        _playerScore=score;
        
        
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        float scaleFactor = winSize.height/winSize.width;
        [CCMenuItemFont setFontName:@"Futura"];
        [CCMenuItemFont setFontSize:(16*scaleFactor)];
        
        CCMenuItem *retry = [CCMenuItemFont itemWithString:@"( tap anywhere to retry )" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:
             [CCTransitionFadeUp transitionWithDuration:0.5 scene:[GameplayScene node]]];
        }];
        [retry setColor:ccWHITE];
        
        
        CCMenuItem *menu = [CCMenuItemFont itemWithString:@"Main Menu" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:
             [CCTransitionFadeDown transitionWithDuration:0.5 scene:[MainMenuLayer sceneWithScore:_playerScore]]];
            
        }];
        [menu setColor:ccWHITE];

        
        
        [CCMenuItemFont setFontSize:(12*scaleFactor)];
        CCMenuItem *challenge = [CCMenuItemFont itemWithString:@"Challenge friends to beat this score" block:^(id sender) {
            //challenges
            if ([[GameKitHelper sharedGameKitHelper] localPlayerIsAuthenticated]){
            [GameKitHelper showFriendsPickerViewControllerForScore:
             score];
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not Logged In"
                                                                message:@"This features requires Game Center authentification."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            
            
        }];
        
        
        
        
        
        
        
        CCMenu *endMenu = [CCMenu menuWithItems:challenge, menu,retry, nil];
        
        
        [endMenu alignItemsVerticallyWithPadding:12*scaleFactor];
        [endMenu setPosition:ccp(winSize.width/2, winSize.height/2)];
        [self addChild:endMenu];
        
        
        
    }
    return self;
}

+(CCScene*) scene {
    CCScene *scene = [CCScene node];
    GameOverLayer *layer = [GameOverLayer node];
    [scene addChild:layer];
    return scene;
}


-(void) onEnter {
    [super onEnter];
    [[CCDirector sharedDirector].touchDispatcher
     addTargetedDelegate:self priority:0 swallowsTouches:YES];
}
-(void) onExit {
    [super onExit];
    [[CCDirector sharedDirector].touchDispatcher removeDelegate:self];
}

//INPUT
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    [[CCDirector sharedDirector] replaceScene:
     [CCTransitionFadeUp transitionWithDuration:0.5 scene:[GameplayScene node]]];
    return YES;
}

//UTILITY
+(CCScene*) sceneWithScore:(float)prevScore {
    CCScene *scene = [CCScene node];
    GameOverLayer *layer = [[[GameOverLayer alloc] initWithScore:prevScore] autorelease];
    [scene addChild:layer];
    return scene;
}

@end
