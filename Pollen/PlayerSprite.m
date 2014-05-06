//
//  PlayerSprite.m
//  jesusgetshigh
//
//  Created by Eric Nelson on 4/12/14.
//  Copyright 2014 bathtubindustries. All rights reserved.
//

#import "PlayerSprite.h"

@implementation PlayerSprite

@synthesize velocity = velocity_;
@synthesize extraYVelocity = extraYVel_;
@synthesize dead = dead_;

-(id)init{
    if(self = [super initWithFile:@"pollenManGround.png"]) {
        size = [[CCDirector sharedDirector] winSize];
        [self setScale:0.9];
        
        state_ = OnGround;
        self.dead = NO;
        attackResetTimer_ = 0;
        
        self.position = ccp(size.width/2, [self boundingBox].size.height/2);
        self.velocity = CGPointZero;
        self.extraYVelocity = 0;
    }
    return self;
}

-(void) startAttack {
    if(state_ == OnGround) {
        //start jumping if on ground
        state_ = Jumping;
        [self chooseTexture:@"pollenManJump.png"];
        self.velocity = ccp(self.velocity.x, PLAYER_JUMP*2);
    } else if(state_ != Attacking) {
        //start attacking
        state_ = Attacking;
        attackResetTimer_ = PLAYER_ATTACK_RESET;
        [self chooseTexture:@"pollenManAttack.png"];
        self.velocity = ccp(self.velocity.x, PLAYER_JUMP);
    }
}

-(void) update:(ccTime)dt
{
    //ATTACK STATE UPDATE
    if(state_ == Attacking) {
        if(attackResetTimer_ > 0)
            attackResetTimer_ -= dt;
        else {
            state_ = Jumping;
            [self chooseTexture:@"pollenManJump.png"];
        }
    }
    
    //Y BOUNDS AND VELOCITIES
    //update if above bottom edge
    if(state_ != OnGround) {
        if(self.position.y > -[self boundingBox].size.height/2) {
            //update the velocity with gravity
            if(self.extraYVelocity > 0)
                self.extraYVelocity += PLAYER_GRAVITY;
            if(self.extraYVelocity < 0)
                self.extraYVelocity = 0;

            if(self.extraYVelocity < -PLAYER_GRAVITY) {
                self.velocity = ccp(self.velocity.x,
                                    self.velocity.y + PLAYER_GRAVITY + self.extraYVelocity);
            }
        } else {
            self.velocity = CGPointZero;
            self.dead = YES;
        }
    } else {
        //reset to bottom edge if below
        if(self.position.y < [self boundingBox].size.height/2) {
            self.position = ccp(self.position.x, [self boundingBox].size.height/2);
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

//UTILITY
-(void) chooseTexture:(NSString*)fn {
    if([[CCTextureCache sharedTextureCache] addImage:fn]) {
        CCTexture2D *texture = [[CCTextureCache sharedTextureCache] textureForKey:fn];
        [self setTexture:texture];
        [self setTextureRect:CGRectMake(0, 0, [texture contentSize].width,
                                              [texture contentSize].height)];
    }
}

@end
