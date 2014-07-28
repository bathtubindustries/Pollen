//
//  PlayerSprite.h
//  jesusgetshigh
//
//  Created by Eric Nelson on 4/12/14.
//  Copyright 2014 bathtubindustries. All rights reserved.
//

#import "cocos2d.h"

#define PLAYER_XACCEL 2150.f
#define PLAYER_XMAXSPEED 445.f

#define PLAYER_GRAVITY -15.f
#define PLAYER_JUMP 555.f
#define PLAYER_INITAL_JUMP 800.f
#define PLAYER_SPIDDDER_JUMP 660.f

#define PLAYER_ATTACK_RESET 0.14f

#define PLAYER_MAX_POLLEN 90.f
#define PLAYER_SWIPE_AMOUNT 30.f

#define PLAYER_BOOST_DECREMENT 15.f
#define PLAYER_BOOST_JUMP 360.f

#define PLAYER_COMBO_BOOST 300.0f

@class SpriteLayer;
@interface PlayerSprite : CCSprite {
    //references
    CGSize size;
    
    //members    
    enum PlayerState {
        OnGround = 0,
        Jumping,
        Attacking,
        Boosting,
        ComboBoost,
        Combo,
    };
    enum PlayerState state_;
    BOOL dead_;
    
    float gravityIncrement_;
    float jumpIncrement_;
    
    float attackResetTimer_;
    float pollenMeter_;
    
    CGPoint velocity_;
    float extraYVel_;
}
@property CGPoint velocity;
@property float extraYVelocity;
@property float pollenMeter;
@property(nonatomic) enum PlayerState state;
@property BOOL dead;
@property (nonatomic, assign) SpriteLayer* spawnLayer;
//messages
-(void) startAttack;
-(void) startJump;
-(void) startSpiddderJump;
-(void) startSwipe;
-(void) startBoost;
-(void) startComboBoost;

-(void) handleHeight:(float)h;
//update
-(void) update:(ccTime)dt;


@end
