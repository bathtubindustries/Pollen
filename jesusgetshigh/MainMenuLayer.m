//
//  MainMenuLayer.m
//  jesusgetshigh
//
//  Created by garv on 4/3/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "MainMenuLayer.h"
#import "AppDelegate.h"

#pragma mark - MainMenuLayer

@implementation MainMenuLayer

-(id) init {
    if(self = [super init]) {
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCLabelTTF *gameTitleLabel = [CCLabelTTF labelWithString:@"jesusgetshigh"
                                                        fontName:@"Verdana-Bold" fontSize:24];
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
