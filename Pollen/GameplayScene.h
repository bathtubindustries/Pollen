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

@interface GameplayScene : CCScene {
    TreeLayer *bgLayer_;
    SpriteLayer *spriteLayer_;
    TutorialLayer *tutorialLayer_;
    LineLayer *lineLayer_;
    PauseLayer *pauseLayer_;
    ContinueLayer * continueLayer_;
}

@property BOOL tutorialActive;
-(void) pause;
-(void) resume;
-(BOOL) isPausedWithMenu;
-(void) activateContinueCheck: (NSInteger)score;
-(void) makeReviveCall;

-(void) update:(ccTime)dt;

@end
