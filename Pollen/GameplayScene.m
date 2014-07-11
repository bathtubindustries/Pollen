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
#import "ContinueLayer.h"

#import "GameUtility.h"

@implementation GameplayScene

-(id) init
{
	if(self = [super init])
	{
        _tutorialActive=NO;
        bgLayer_ = [TreeLayer node];
        [self addChild:bgLayer_ z:0];

        spriteLayer_ = [SpriteLayer node];
        [spriteLayer_ setScene:self];
        [spriteLayer_ setBackgroundLayer:bgLayer_];
        [self addChild:spriteLayer_ z:1];
        
        if([GameUtility savedHighScore] == 0) {
            _tutorialActive=YES;
            tutorialLayer_ = [TutorialLayer node];
            [tutorialLayer_ setScene:self];
            [self addChild:tutorialLayer_ z:2];
            [GameUtility equipItem:0];
            [GameUtility itemPurchased:@"Dandelion Hammer" purchased:NO];
            [GameUtility itemPurchased:@"SporeTwig Staff" purchased:YES];
        }
        
        lineLayer_ = [LineLayer node];
        [lineLayer_ setSpriteLayer:spriteLayer_];
        [self addChild:lineLayer_ z:3];
        
        pauseLayer_ = [PauseLayer node];
        [pauseLayer_ setTopBuffer:spriteLayer_.topBuffer];
        [self addChild:pauseLayer_ z:4];
        
        
        continueLayer_ = [ContinueLayer node];
        [continueLayer_ setScene:self];
        
        [self addChild:continueLayer_ z:3];
        
        [self scheduleUpdate];
    }
    return self;
}

-(void) pause { [pauseLayer_ pause]; }
-(void) resume { [pauseLayer_ resume]; }
-(BOOL) isPausedWithMenu { return (pauseLayer_.pausedWithMenu || continueLayer_.paused); }

//continue screen
-(void) makeReviveCall{ [spriteLayer_ revivePlayer];}
-(void) activateContinueCheck: (NSInteger) score{[continueLayer_ checkForContinue];}



-(void) update:(ccTime)dt
{
    if(!pauseLayer_.paused && !continueLayer_.paused) {
        [continueLayer_ update:dt];
        [bgLayer_ update:dt];
        [spriteLayer_ update:dt];
    }
}

@end
