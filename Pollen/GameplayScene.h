//
//  GameplayScene.h
//  jesusgetshigh
//
//  Created by garv on 4/3/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "CCScene.h"

@class TreeLayer;
@class SpriteLayer;
@class PauseLayer;
@class TutorialLayer;
@class LineLayer;
@class ContinueLayer;
@class ComboLayer;

@interface GameplayScene : CCScene {
    TreeLayer *bgLayer_;
    SpriteLayer *spriteLayer_;
    TutorialLayer *tutorialLayer_;
    LineLayer *lineLayer_;
    PauseLayer *pauseLayer_;
    ContinueLayer * continueLayer_;
}

@property BOOL tutorialActive;
@property BOOL waitingEvent;
@property(nonatomic) enum TutorialState tutorialState;

-(void) pause;
-(void) resume;
-(BOOL) isPausedWithMenu;
-(void) activateContinueCheck: (NSInteger)score;
-(void) makeReviveCall;
-(void) update:(ccTime)dt;
-(void) hidePause;
-(void) showPause;
-(float) getScore;

//tutorial shit
@property(nonatomic) float tutorialTimer;
-(void) sendTutorialEvent:(enum TutorialState)state;

@end
