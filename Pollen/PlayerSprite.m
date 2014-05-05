//
//  PlayerSprite.m
//  jesusgetshigh
//
//  Created by Eric Nelson on 4/12/14.
//  Copyright 2014 bathtubindustries. All rights reserved.
//

#import "PlayerSprite.h"

#define GRAVITY -5

@implementation PlayerSprite

@synthesize velocity = velocity_;

-(id)init{
    if(self = [super initWithFile:@"Icon-Small-50.png"]) {
        size = [[CCDirector sharedDirector] winSize];
        
        self.position = ccp(size.width/2, size.width/2);
        self.velocity = CGPointZero;
    }
    return self;
}

-(void) update:(ccTime)dt
{
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
