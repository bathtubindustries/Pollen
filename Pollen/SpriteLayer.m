//
//  SpriteLayer.m
//  Pollen
//
//  Created by Eric Nelson on 5/1/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "SpriteLayer.h"

#import "TreeLayer.h"
#import "PlayerSprite.h"
#import "MainMenuLayer.h"

@implementation SpriteLayer

-(id) init{
    if(self = [super init])
    {
        //setup
        size = [[CCDirector sharedDirector] winSize];
        [self registerWithTouchDispatcher];
        self.accelerometerEnabled = YES;
        
        //player
        player = [PlayerSprite node];
        [self addChild:player z:1];
    }
    return self;
}

//INPUT
-(void) registerWithTouchDispatcher {
    [[CCDirector sharedDirector].touchDispatcher
        addTargetedDelegate:self priority:1 swallowsTouches:YES];
}
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [self convertTouchToNodeSpace:touch];
    if(location.x > 20 && location.x < size.width - 20 &&
       location.y > 20 && location.y < size.height - 20) {
        [player startAttack];
    }
    
    return YES;
}

-(void) accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration {
    //low pass filter
    float lpfFilter = 0.1f;
	player.velocity = ccp(acceleration.x*lpfFilter*PLAYER_XACCEL + player.velocity.x*(1.0f-lpfFilter),
                          player.velocity.y);
}

//UPDATE
-(void) update:(ccTime)dt
{
    [player update:dt];
    
    //handle extra velocity
    if(bgLayer) {
        [bgLayer setYVelocity:player.extraYVelocity];
    }
    
    //handle lose condition
    if(player.dead) {
        [[CCDirector sharedDirector] replaceScene:
         [CCTransitionFadeDown transitionWithDuration:0.5 scene:[MainMenuLayer scene]]];
        
        player.dead = NO; //so no repeat transition is activated
    }
}

//UTILITY
-(void) setBackgroundLayer:(TreeLayer*)l {
    bgLayer = l;
}

@end
