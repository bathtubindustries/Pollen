//
//  Spiddderoso.h
//  Pollen
//
//  Created by Garv Manocha on 5/7/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "CCSprite.h"

#define SPIDDDER_POLLEN_AMOUNT 3.f

@class SpriteLayer;

@interface Spiddderoso : CCSprite {
    //references
    CGSize size;
    
    //members
    BOOL waitingDisconnect_;
    
    BOOL isComboMode;
    
    BOOL shouldFall;
    BOOL shouldRise;
    
    BOOL shouldSwangRight;
    
    float riseSpeedBoost;
    float extraYVel_;
    CGPoint velocity_;
    
    SpriteLayer* spawnLayer;
}
@property CGPoint velocity;
@property BOOL waitingDisconnect;

//setter
-(void) setExtraYVelocity:(float)vel;
-(void) updateSpeed;
//update
-(void) update:(ccTime)dt;
-(void) setComboMode:(BOOL)combo shouldFall:(BOOL) fall;

@end
