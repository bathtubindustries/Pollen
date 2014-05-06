//
//  PlayerSprite.m
//  jesusgetshigh
//
//  Created by Eric Nelson on 4/12/14.
//  Copyright 2014 bathtubindustries. All rights reserved.
//

#import "PlayerSprite.h"

#define PLAYER_GRAVITY -10
#define PLAYER_JUMP 8

@implementation PlayerSprite

@synthesize velocity = velocity_;
@synthesize extraYVelocity = extraYVel_;
@synthesize dead = dead_;

-(id)init{
    if(self = [super initWithFile:@"Icon-Small-50.png"]) {
        size = [[CCDirector sharedDirector] winSize];
        [self setScale:1.5];
        
        state_ = OnGround;
        self.dead = NO;
        
        self.position = ccp(size.width/2, [self boundingBox].size.height/2);
        self.velocity = CGPointZero;
        self.extraYVelocity = 0;
    }
    return self;
}

-(void) startJump {
    if(state_ == OnGround) {
        state_ = Jumping;
        self.velocity = ccp(self.velocity.x, PLAYER_JUMP*1.2);
    } else {
        self.velocity = ccp(self.velocity.x, PLAYER_JUMP);
    }
}

-(void) update:(ccTime)dt
{
    //Y BOUNDS AND VELOCITIES
    //update if above bottom edge
    if(state_ != OnGround) {
        if(self.position.y > -[self boundingBox].size.height/2) {
            //update the velocity with gravity
            float currentGrav = PLAYER_GRAVITY*dt;
            currentGrav += self.extraYVelocity;
            
            if(currentGrav < 0)
                self.velocity = ccp(self.velocity.x,
                                    self.velocity.y + PLAYER_GRAVITY*dt);
            else
                self.extraYVelocity += PLAYER_GRAVITY*dt;
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
    
    //HANDLE EXTRA Y VEL
    if(self.position.y + self.velocity.y > size.height/2) {
        self.extraYVelocity = (self.position.y+self.velocity.y) - size.height/2;
        self.velocity = ccp(self.velocity.x, size.height/2 - self.position.y);
    }
    
    //UPDATE
    //update sprite with velocity
    self.position = ccpAdd(self.position, self.velocity);
}


@end
