//
//  PauseLayer.h
//  Pollen
//
//  Created by Garv Manocha on 5/5/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "cocos2d.h"

@interface PauseLayer : CCLayerColor {
    //references
    CGSize size;
    
    //members
    BOOL paused_;
    BOOL pausedWithMenu_;
    BOOL alreadyPaused_;
    
    CCMenu *pauseMenu_;
    CCSprite *pauseButton_;
    
    CCTexture2D *pauseButtonTexture_;
    CCTexture2D *resumeButtonTexture_;
}
@property BOOL paused;
@property BOOL pausedWithMenu;

//state setter
-(void) pause;
-(void) resume;

-(void) pauseWithMenu;
-(void) resumeWithMenu;
-(void) togglePauseMenu;

//utility
-(BOOL) isPointInPauseButton:(CGPoint)cp;

@end
