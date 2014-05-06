//
//  PlayerSprite.h
//  jesusgetshigh
//
//  Created by Eric Nelson on 4/12/14.
//  Copyright 2014 bathtubindustries. All rights reserved.
//

#import "cocos2d.h"

#define PLAYER_XACCEL 80.f
#define PLAYER_XMAXSPEED 5.f

@interface PlayerSprite : CCSprite {
    //references
    CGSize size;
    
    //members
    enum PlayerState {
        OnGround = 0,
        Jumping
        
    };
    enum PlayerState state_;
    BOOL dead_;
    
    CGPoint velocity_;
    float extraYVel_;
}
@property CGPoint velocity;
@property float extraYVelocity;
@property BOOL dead;

//messages
-(void) startJump;

//update
-(void) update:(ccTime)dt;

@end
