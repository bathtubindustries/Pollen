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
        
        if([GameUtility needsTutorial]) {
            _tutorialActive=YES;
            tutorialLayer_ = [TutorialLayer node];
            [tutorialLayer_ setScene:self];
            [self addChild:tutorialLayer_ z:2];
            [GameUtility equipItem:0];
            [GameUtility isTutorialNeeded:NO];
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
-(void) hidePause{pauseLayer_.visible=NO;}
-(void) showPause{pauseLayer_.visible=YES;}
//continue screen
-(void) makeReviveCall{ [spriteLayer_ revivePlayer];}
-(void) activateContinueCheck: (NSInteger) score{
    continueLayer_.playerScore=score;
    [continueLayer_ checkForContinue];}

-(float) getScore{
    return spriteLayer_.playerHeight;
}

-(void) update:(ccTime)dt
{
    if(!self.isPausedWithMenu) {
        [tutorialLayer_ update:dt];
    }
    
    if(!pauseLayer_.paused && !continueLayer_.paused) {
        [continueLayer_ update:dt];
        [bgLayer_ update:dt];
        [spriteLayer_ update:dt];
    }
    if (pauseLayer_.paused)
    {
        [spriteLayer_ pauseCombo];
    }
}

//property
-(BOOL) waitingEvent {
    if(tutorialLayer_) return tutorialLayer_.waitingEvent;
    else return NO;
}
-(void) setWaitingEvent:(BOOL)we {
    tutorialLayer_.waitingEvent = we;
}

-(enum TutorialState) tutorialState {
    return tutorialLayer_.tutorialState;
}
-(float) tutorialTimer {
    return tutorialLayer_.messageLockTimer;
}

//TUTORIAL SHIT
-(void) sendTutorialEvent:(enum TutorialState)state {
    if(tutorialLayer_ && tutorialLayer_.waitingEvent) {
        tutorialLayer_.waitingEvent = NO;
        [tutorialLayer_ updateMessages];
        tutorialLayer_.messageLockTimer = MESSAGE_LOCK_TIME;
        
        [self pause];
        
        if(state == Tap)
            NSLog(@"received tap event");
        else if(state == Swipe)
            NSLog(@"received swipe event");
        else if(state == Spiddder)
            NSLog(@"received spiddder event");
        else if(state == CatchMyEye)
            NSLog(@"received catch my eye event");
        else if(state == Haikus)
            NSLog(@"received haikus event");
    }
}

@end
