//
//  PlayerSprite.h
//  jesusgetshigh
//
//  Created by Eric Nelson on 4/12/14.
//  Copyright 2014 bathtubindustries. All rights reserved.
//

#import "cocos2d.h"

#define PLAYER_XACCEL 2760.f //was 2650
#define PLAYER_XMAXSPEED 440.f

#define PLAYER_GRAVITY -15.f
#define PLAYER_JUMP 555.f
#define PLAYER_INITAL_JUMP 800.f
#define PLAYER_SPIDDDER_JUMP 660.f

#define PLAYER_ATTACK_RESET 0.22f
#define PLAYER_ATTACK_FRAME_DELAY 0.05f

#define PLAYER_MAX_POLLEN 90.f
#define PLAYER_SWIPE_AMOUNT 30.f

#define PLAYER_BOOST_DECREMENT 15.f
#define PLAYER_BOOST_JUMP 360.f

#define PLAYER_COMBO_BOOST 300.0f

#define PLAYER_WIDTH 72.f //80.f
#define PLAYER_HEIGHT 83.7f //93.f

@class SpriteLayer;
@interface PlayerSprite : CCSpriteBatchNode {
    //references
    CGSize size;
    
    //members
    NSMutableArray *animationFrames;
    CCSprite *playerSprite_;
    
    enum PlayerState {
        OnGround = 0,
        Jumping,
        Attacking,
        Boosting,
        ComboBoost,
        Combo,
        ComboEnding
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
@property (nonatomic, assign) BOOL comboEnding;
@property (nonatomic, assign) SpriteLayer* spawnLayer;

//overrides
@property CGPoint position;
@property float rotation;
//@property CGRect boundingBox;

//messages
-(void) startAttack;
-(void) startAttack:(unsigned short) dir;
-(void) startJump;
-(void) startSpiddderJump;
-(void) startSwipe;
-(void) startBoost;
-(void) startComboBoost;

-(void) handleHeight:(float)h;
//update
-(void) update:(ccTime)dt;


@end
