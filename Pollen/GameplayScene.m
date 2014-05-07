//
//  GameplayScene.m
//  jesusgetshigh
//
//  Created by garv on 4/3/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "GameplayScene.h"

#import "TreeLayer.h"
#import "SpriteLayer.h"
#import "TutorialLayer.h"
#import "LineLayer.h"
#import "PauseLayer.h"

#import "GameUtility.h"

@implementation GameplayScene

-(id) init
{
	if(self = [super init])
	{
        bgLayer_ = [TreeLayer node];
        [self addChild:bgLayer_ z:0];

        spriteLayer_ = [SpriteLayer node];
        [spriteLayer_ setScene:self];
        [spriteLayer_ setBackgroundLayer:bgLayer_];
        [self addChild:spriteLayer_ z:1];
        
        if([GameUtility savedHighScore] == 0) {
            tutorialLayer_ = [TutorialLayer node];
            [self addChild:tutorialLayer_ z:2];
        }
        
        lineLayer_ = [LineLayer node];
        [lineLayer_ setSpriteLayer:spriteLayer_];
        [self addChild:lineLayer_ z:3];
        
        pauseLayer_ = [PauseLayer node];
        [pauseLayer_ setTopBuffer:spriteLayer_.topBuffer];
        [self addChild:pauseLayer_ z:4];
        
        [self scheduleUpdate];
    }
    return self;
}

-(void) pause { [pauseLayer_ pause]; }
-(void) resume { [pauseLayer_ resume]; }
-(BOOL) isPausedWithMenu { return pauseLayer_.pausedWithMenu; }

-(void) update:(ccTime)dt
{
    if(!pauseLayer_.paused) {
        [bgLayer_ update:dt];
        [spriteLayer_ update:dt];
    }
}

@end
