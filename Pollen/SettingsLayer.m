//
//  SettingsLayer.m
//  PollenBug
//
//  Created by Eric Nelson on 5/23/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "SettingsLayer.h"

@implementation SettingsLayer

-(id) init {
    if(self = [super init]) {
        CCSprite *img = [CCSprite spriteWithFile:@"pollenstorebg.png"];
        img.anchorPoint = ccp(0, 0);
        img.position = ccp(0, 0);
        [self addChild:img];
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        
        
    }
    return self;
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
     [CCTransitionSlideInT transitionWithDuration:0.5 scene:[MainMenuLayer scene]]];
    return YES;
}

//UTILITY
+(CCScene*) scene {
    CCScene *scene = [CCScene node];
    SettingsLayer *layer = [SettingsLayer node];
    [scene addChild:layer];
    return scene;
}



@end
