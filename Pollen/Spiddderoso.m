//
//  Spiddderoso.m
//  Pollen
//
//  Created by Garv Manocha on 5/7/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "Spiddderoso.h"

#import "cocos2d.h"

#define SPIDDDER_INIT_VELOCITY 200.f
#define SPIDDDER_VELOCITY_INCREMENT 60.f
#define SPIDDDER_VELOCITY_DECREMENT 10.f
#define SPIDDDER_CEILING 500.f
#define SPIDDDER_RETURN_TIME 0.5f

@implementation Spiddderoso

@synthesize velocity = velocity_;
@synthesize waitingDisconnect = waitingDisconnect_;

-(id) init {
    if(self = [super initWithFile:@"spiddderoso.png"]) {
        size = [[CCDirector sharedDirector] winSize];
        
        self.velocity = CGPointZero;
        self.position = ccp(size.width/2, size.height);
        
        self.waitingDisconnect = NO;
    }
    return self;
}

//SETTER
-(void) setExtraYVelocity:(float)vel {
    extraYVel_ = vel;
}
-(void) updateSpeed {
    if(self.velocity.y == 0) {
        self.velocity = ccp(self.velocity.x, SPIDDDER_INIT_VELOCITY);
    } else {
        self.velocity = ccp(self.velocity.x, self.velocity.y+SPIDDDER_VELOCITY_INCREMENT);
    }
}

//UPDATE
-(void) update:(ccTime)dt {
    //set visibility for optimization
    if(self.position.y > size.height + [self boundingBox].size.height)
        self.visible = NO;
    else
        self.visible = YES;
    
    //add velocity to position
    self.position = ccp(self.position.x + self.velocity.x*dt,
                        self.position.y + (self.velocity.y+extraYVel_)*dt);
    
    //decrement if too high
    if(self.position.y - size.height > SPIDDDER_CEILING) {
        self.position = ccp(self.position.x, size.height+SPIDDDER_CEILING);
        self.velocity = ccp(self.velocity.x, self.velocity.y-SPIDDDER_VELOCITY_DECREMENT);
        if(self.velocity.y < SPIDDDER_INIT_VELOCITY)
            self.velocity = ccp(self.velocity.x, SPIDDDER_INIT_VELOCITY);
    }
    
    //update opacity when waiting disconnect
    if(self.waitingDisconnect) {
        self.opacity = 100;
        self.position = ccp(self.position.x, self.position.y
                                           + (size.height - self.position.y)/SPIDDDER_RETURN_TIME*dt);
    } else {
        self.opacity = 255;
    }
}

@end