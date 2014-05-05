//
//  PlayerSprite.m
//  jesusgetshigh
//
//  Created by Eric Nelson on 4/12/14.
//  Copyright 2014 bathtubindustries. All rights reserved.
//

#import "PlayerSprite.h"

#define GRAVITY -8
#define PLAYER_JUMP 5

@implementation PlayerSprite

@synthesize velocity = velocity_;

-(id)init{
    if(self = [super initWithFile:@"Icon-Small-50.png"]) {
        size = [[CCDirector sharedDirector] winSize];
        
        state_ = Idle;
        
        self.position = ccp(size.width/2, size.width/2);
        self.velocity = CGPointZero;
    }
    return self;
}

-(void) startJump {
    if(state_ != Jumping) {
        state_ = Jumping;
        self.velocity = ccp(self.velocity.x, PLAYER_JUMP);
    }
}

-(void) update:(ccTime)dt
{
    //update jumping state
    if(state_ == Jumping && self.velocity.y < 0.1) {
        state_ = Idle;
    }
    
    //update if above bottom edge
    if(self.position.y > self.contentSize.height/2) {
        //update the velocity with gravity
        self.velocity = ccp(self.velocity.x,
                            self.velocity.y + GRAVITY*dt);
    } else {
        //reset to bottom edge if below
        if(self.position.y < self.contentSize.height/2)
            self.position = ccp(self.position.x, self.contentSize.height/2);
        
        //zero velocity if below bottom edge
        self.velocity = CGPointZero;
    }
    
    //update sprite with velocity
    self.position = ccpAdd(self.position, self.velocity);
}


@end
