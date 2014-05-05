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
#import "PauseLayer.h"

@implementation GameplayScene

-(id) init
{
	if(self = [super init])
	{
        bgLayer_ = [TreeLayer node];
        [self addChild:bgLayer_ z:0];
        
        spriteLayer_ = [SpriteLayer node];
        [self addChild:spriteLayer_ z:1];

        //statLayer = [UILayer node];
        //[self addChild:statLayer z:1];
        
        pauseLayer_ = [PauseLayer node];
        [self addChild:pauseLayer_ z:2];
        
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
