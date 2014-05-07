//
//  Spiddderoso.h
//  Pollen
//
//  Created by Garv Manocha on 5/7/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "CCSprite.h"

#define SPIDDDER_POLLEN_AMOUNT 10.f

@interface Spiddderoso : CCSprite {
    //references
    CGSize size;
    
    //members
    BOOL waitingDisconnect_;
    
    float extraYVel_;
    CGPoint velocity_;
}
@property CGPoint velocity;
@property BOOL waitingDisconnect;

//setter
-(void) setExtraYVelocity:(float)vel;
-(void) updateSpeed;
//update
-(void) update:(ccTime)dt;

@end
