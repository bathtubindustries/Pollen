//
//  PlayerSprite.h
//  jesusgetshigh
//
//  Created by Eric Nelson on 4/12/14.
//  Copyright 2014 bathtubindustries. All rights reserved.
//

#import "cocos2d.h"

#define PLAYER_XACCEL 1500.f
#define PLAYER_XMAXSPEED 400.f

#define PLAYER_GRAVITY -15.f
#define PLAYER_JUMP 400.f

#define PLAYER_ATTACK_RESET 0.15f

@interface PlayerSprite : CCSprite {
    //references
    CGSize size;
    
    //members    
    enum PlayerState {
        OnGround = 0,
        Jumping,
        Attacking
    };
    enum PlayerState state_;
    BOOL dead_;
    
    float attackResetTimer_;
    
    CGPoint velocity_;
    float extraYVel_;
}
@property CGPoint velocity;
@property float extraYVelocity;
@property BOOL dead;

//messages
-(void) startAttack;

//update
-(void) update:(ccTime)dt;

@end
