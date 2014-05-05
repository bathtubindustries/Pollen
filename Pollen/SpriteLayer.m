//
//  SpriteLayer.m
//  Pollen
//
//  Created by Eric Nelson on 5/1/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "SpriteLayer.h"

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
        player.position = ccp(size.width/2, size.height/2);
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
        [player startJump];
    }
    
    return YES;
}

-(void) accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration {
    NSLog(@"acceleration: x:%f / y:%f / z:%f",
          acceleration.x, acceleration.y, acceleration.z);
    if(acceleration.x > 0.5) {
        player.velocity = ccp(5, player.velocity.y);
    } else if(acceleration.x < 0.5) {
        player.velocity = ccp(-5, player.velocity.y);
    } else {
        player.velocity = ccp(0, player.velocity.y);
    }
}

//UPDATE
-(void) update:(ccTime)dt
{
    [player update:dt];
}


@end
