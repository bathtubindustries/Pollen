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
        
        CCLabelTTF *gameTitleLabel = [CCLabelTTF labelWithString:@"Pollen"
                                                        fontName:@"Verdana-Bold" fontSize:24];
        CCMenuItem *itemNewGame = [CCMenuItemFont itemWithString:@"New Game" block:^(id sender) {
            
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[GameplayScene node]]];
			
		}];
        
        CCMenu *menu = [CCMenu menuWithItems:itemNewGame, nil];
		
		[menu alignItemsVerticallyWithPadding:20];
        if(size.height > size.width)
        {
            [menu setPosition:ccp( size.height/2, size.width/2 - 125)];
        }
		else{
            [menu setPosition:ccp(size.width/2,size.height/2-125)];
        }
		
		// Add the menu to the layer
		[self addChild:menu];

        
        gameTitleLabel.position = ccp(size.width/2, size.height/2);
        [self addChild:gameTitleLabel];
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
