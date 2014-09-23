//
//  Spiddderoso.m
//  Pollen
//
//  Created by Garv Manocha on 5/7/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "Spiddderoso.h"
#import "SpriteLayer.h"
#import "cocos2d.h"

#define SPIDDDER_COMBO_VELOCITY 105.f //was 78
#define SPIDDDER_COMBO_VELOCITY_FALL -95.f
#define SPIDDDER_VELOCITY_INCREMENT 50.f //was 30.f
#define SPIDDDER_VELOCITY_DECREMENT 10.f
#define SPIDDDER_CEILING 500.f
#define SPIDDDER_RETURN_TIME 0.5f

#define SPIDDDER_ROTATION_DEGREES 7.f

@implementation Spiddderoso

@synthesize velocity = velocity_;
@synthesize waitingDisconnect = waitingDisconnect_;

-(id) init {
    if(self = [super initWithFile:@"spiddderoso.png"]) {
        size = [[CCDirector sharedDirector] winSize];
        
        self.velocity = CGPointZero;
        self.position = ccp(size.width/2, size.height);
        isComboMode=NO;
        self.waitingDisconnect = NO;
        shouldSwangRight=YES;
        
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

-(void) setComboMode:(BOOL)combo shouldFall:(BOOL)fall{
    isComboMode=combo;
    if (fall)
    {
        shouldFall=YES;
    }
    else
    {
        shouldFall=NO;
    }
    if (!combo)
    {
        shouldFall=NO;
        shouldRise=YES;
    }
}

//UPDATE
-(void) update:(ccTime)dt {
    //set visibility for optimization
    if(self.position.y > size.height + [self boundingBox].size.height)
        self.visible = NO;
    else
        self.visible = YES;

    //rotations
    if (self.rotation > SPIDDDER_ROTATION_DEGREES)
    {
        shouldSwangRight=NO;
    }
    
    else if (self.rotation < -SPIDDDER_ROTATION_DEGREES)
    {
        shouldSwangRight=YES;
    }
    
    
    if (shouldSwangRight)
    {
        self.rotation+=(isComboMode ? 0.7:0.3);
    }
    
    else
    {
        self.rotation-=(isComboMode ? 0.7:0.3);
    }
    
    //combo mode
    if (isComboMode)
    {
        
        self.velocity = ccp(self.velocity.x, (shouldFall) ? SPIDDDER_COMBO_VELOCITY_FALL : SPIDDDER_COMBO_VELOCITY);
    }
    if (shouldRise)
    {
        riseSpeedBoost=250;
        self.velocity = ccp(self.velocity.x, self.velocity.y+riseSpeedBoost);
        shouldRise=NO;
    }
    
    //add velocity to position
    self.position = ccp(self.position.x + self.velocity.x*dt,
                        self.position.y + (self.velocity.y+extraYVel_)*dt);
    
    riseSpeedBoost= (riseSpeedBoost >=10) ? riseSpeedBoost/100 : 0;
    
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
