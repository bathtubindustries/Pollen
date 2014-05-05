//
//  MainMenuLayer.m
//  jesusgetshigh
//
//  Created by garv on 4/3/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "MainMenuLayer.h"
#import "AppDelegate.h"
#import "GameplayScene.h"

#pragma mark - MainMenuLayer

@implementation MainMenuLayer

-(id) init {
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
        
        //menu
        [CCMenuItemFont setFontName:@"Futura"];
        [CCMenuItemFont setFontSize:(16*scaleFactor)];
        
        CCMenuItem *itemNewGame = [CCMenuItemFont itemWithString:@"tap to start" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[GameplayScene node]]];
        }];
        CCMenuItem *itemStore = [CCMenuItemFont itemWithString:@"store" block:^(id sender) {
            //[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[StoreScene node]]];
        }];
        
        CCMenu *menu = [CCMenu menuWithItems:itemNewGame, itemStore, nil];
		[menu alignItemsVerticallyWithPadding:6*scaleFactor];
        [menu setPosition:ccp(size.width/2, 120)];
        [menu setColor:ccBLACK];
		[self addChild:menu];
    }
    return self;
}

+(CCScene*) scene {
    CCScene *scene = [CCScene node];
    MainMenuLayer *layer = [MainMenuLayer node];
    [scene addChild:layer];
    return scene;
}

@end
