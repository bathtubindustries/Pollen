//
//  PlayerSprite.m
//  jesusgetshigh
//
//  Created by Eric Nelson on 4/12/14.
//  Copyright 2014 bathtubindustries. All rights reserved.
//

#import "PlayerSprite.h"

#import "GameUtility.h"
#import "Flower.h"

@implementation PlayerSprite

@synthesize velocity = velocity_;
@synthesize extraYVelocity = extraYVel_;
@synthesize pollenMeter = pollenMeter_;
@synthesize state = state_;
@synthesize dead = dead_;

-(id)init{
    if(self = [super initWithFile:@"pollenManGround.png"]) {
        size = [[CCDirector sharedDirector] winSize];
        [self setScale:0.9];
        
        state_ = OnGround;
        self.dead = NO;
        attackResetTimer_ = 0;
        self.pollenMeter = 0;
        
        self.position = ccp(size.width/2, [self boundingBox].size.height/2);
        self.velocity = CGPointZero;
        self.extraYVelocity = 0;
        
        gravityIncrement_ = 0;
        jumpIncrement_ = 0;
    }
    return self;
}

//MESSAGES
-(void) startAttack {
    if(state_ == OnGround) {
        //start jumping if on ground
        state_ = Jumping;
        [GameUtility loadTexture:@"pollenManJump.png" Into:self];
        self.velocity = ccp(self.velocity.x, PLAYER_INITAL_JUMP);
        self.rotation = 0;
    } else if(state_ == Jumping) {
        //start attacking
        state_ = Attacking;
        attackResetTimer_ = PLAYER_ATTACK_RESET;
        [GameUtility loadTexture:@"pollenManAttack.png" Into:self];
    } else if(state_ == Boosting) {
        self.velocity = ccp(self.velocity.x, PLAYER_BOOST_JUMP);
    }
}
-(void) startJump {
    if(self.pollenMeter < PLAYER_MAX_POLLEN)
        self.pollenMeter += FLOWER_POLLEN_AMOUNT;
    if(self.pollenMeter > PLAYER_MAX_POLLEN)
        self.pollenMeter = PLAYER_MAX_POLLEN;
    
    self.velocity = ccp(self.velocity.x, PLAYER_JUMP+jumpIncrement_);
}
-(void) startSpiddderJump {
    if(self.pollenMeter > PLAYER_MAX_POLLEN)
        self.pollenMeter = PLAYER_MAX_POLLEN;
    self.velocity = ccp(self.velocity.x, PLAYER_SPIDDDER_JUMP);
}
-(void) startSwipe {
    if(state_ != Boosting) {
        self.pollenMeter -= PLAYER_SWIPE_AMOUNT;
        if(self.pollenMeter < 0)
            self.pollenMeter = 0;

        self.velocity = ccp(self.velocity.x, PLAYER_JUMP+jumpIncrement_);
    }
}

-(void) handleHeight:(float)h {
    #warning hacky and will not scale automatically
    if(h > 1500 && gravityIncrement_ == 0) {
        gravityIncrement_ = 1;
        jumpIncrement_ = 100;
    }
    else if(h > 2000 && gravityIncrement_ == 1) {
        gravityIncrement_ = 3;
        jumpIncrement_ = 250;
    }
    else if(h > 3000 && gravityIncrement_ == 3) {
        gravityIncrement_ = 5;
        jumpIncrement_ = 320;
    }
}

//UPDATE
-(void) update:(ccTime)dt
{
    //ATTACK STATE UPDATE
    if(state_ == Attacking) {
        if(attackResetTimer_ > 0)
            attackResetTimer_ -= dt;
        else {
            state_ = Jumping;
            [GameUtility loadTexture:@"pollenManJump.png" Into:self];
        }
    }
    
    //CHECK+HANDLE BOOSTING
    if(self.pollenMeter >= PLAYER_MAX_POLLEN) {
        state_ = Boosting;
        [GameUtility loadTexture:@"pollenManBoost.png" Into:self];
    }
    if(state_ == Boosting) {
        self.pollenMeter -= PLAYER_BOOST_DECREMENT*dt;
        if(self.pollenMeter <= 0) {
            state_ = Jumping;
            [GameUtility loadTexture:@"pollenManJump.png" Into:self];
        }
    }
    
    //Y BOUNDS AND VELOCITIES
    //update if above bottom edge
    if(state_ != OnGround) {
        if(self.position.y > -[self boundingBox].size.height/2) {
            //update the velocity with gravity
            if(self.extraYVelocity > 0)
                self.extraYVelocity += PLAYER_GRAVITY-gravityIncrement_;
            if(self.extraYVelocity < 0)
                self.extraYVelocity = 0;

            if(self.extraYVelocity < -(PLAYER_GRAVITY-gravityIncrement_)) {
                self.velocity = ccp(self.velocity.x,
                                    self.velocity.y + (PLAYER_GRAVITY-gravityIncrement_) + self.extraYVelocity);
            }
        } else {
            self.velocity = CGPointZero;
            self.dead = YES;
        }
    } else {
        //reset to bottom edge if below (do not account for rotated box)
        if(self.position.y < self.contentSize.height*self.scale/2) {
            self.position = ccp(self.position.x, self.contentSize.height*self.scale/2);
            //zero velocity if below bottom edge
            self.velocity = CGPointZero;
        }
    }
    
    //X BOUNDS AND VELOCITIES
    //bound x within screen
    if(self.position.x > size.width - [self boundingBox].size.width/2) {
        self.velocity = ccp(0, self.velocity.y);
        self.position = ccp(size.width - [self boundingBox].size.width/2,
                            self.position.y);
    } else if(self.position.x < [self boundingBox].size.width/2) {
        self.velocity = ccp(0, self.velocity.y);
        self.position = ccp([self boundingBox].size.width/2,
                            self.position.y);
    }

    if(state_ != OnGround) {
        //bound velocity to max speed
        if(self.velocity.x > PLAYER_XMAXSPEED)
            self.velocity = ccp(PLAYER_XMAXSPEED, self.velocity.y);
        else if(self.velocity.x < -PLAYER_XMAXSPEED)
            self.velocity = ccp(-PLAYER_XMAXSPEED, self.velocity.y);

        //round down small velocities
        if(abs(self.velocity.x) < 0.05f) {
            self.velocity = ccp(0, self.velocity.y);
        }
    } else {
        //rotate w x vel
        int minVel = 15;
        if(self.velocity.x > minVel) {
            self.rotation = 9;
            self.position = ccp(size.width/2 + 12, self.position.y);
        }
        else if(self.velocity.x < -minVel) {
            self.rotation = -9;
            self.position = ccp(size.width/2 - 12, self.position.y);
        }
        else if(abs(self.velocity.x) < minVel-2 && self.velocity.x != 0) {
            self.rotation = 0;
            self.position = ccp(size.width/2, self.position.y);
        }
        
        self.velocity = ccp(0, self.velocity.y);
    }
    
    //UPDATE
    //update sprite with velocity
    self.position = ccp(self.position.x + self.velocity.x*dt,
                        self.position.y + self.velocity.y*dt);
    
    //HANDLE EXTRA Y VEL
    if(self.position.y > size.height/2) {
        self.extraYVelocity = self.velocity.y;
        self.velocity = ccp(self.velocity.x, 0);
        self.position = ccp(self.position.x, size.height/2);
    }
}

@end
