//
//  TutorialLayer.h
//  Pollen
//
//  Created by Garv Manocha on 5/7/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "CCLayer.h"
#import "GameplayScene.h"

#define MESSAGE_LOCK_TIME 0.8f

@interface TutorialLayer : CCLayer {
    //references
    CGSize size;
    GameplayScene *scene;
    
    //enums
    enum TutorialState {
        Tilt = 0,
        Tap,
        Swipe,
        Spiddder,
        CatchMyEye,
        Haikus
    };
    
    //members
    BOOL waitingEvent_;
    enum TutorialState tutorialState_;
    
    float messageLockTimer_;

    NSMutableArray *messages_;
}
@property enum TutorialState tutorialState;
@property BOOL waitingEvent;
@property float messageLockTimer;

-(void) setScene:(GameplayScene *) s;
-(void) updateMessages;

@end

/*
6) fill up meter -> catch my eye

7) haikus = extra lives
*/

////display tilt left/right
////wait for input -> start game w jump
//when bug gets close to flower, pause
//display tap message
//wait for input -> bloom flower, continue game
//bug gets a swipe in pollen meter, pause
//display swipe message
//wait for input -> use swipe, continue game
//bug continues? pause
//display spiddder attack message
//wait for input -> attack spidder
//fill up meter, pause
//display cme message
//wait for tap to continue, start cme
//player dies, pause
//display haiku message
//tap to continue -> go to haiku screen

//if player dies before tutorial end, pause
//display you failed message
//wait for input, restart tutorial