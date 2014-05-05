//
//  SpriteLayer.m
//  Pollen
//
//  Created by Eric Nelson on 5/1/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "SpriteLayer.h"



@implementation SpriteLayer

-(id)init{
    if(self=[super init])
    {
        size = [[CCDirector sharedDirector] winSize];
        player=[PlayerSprite node];
        
        
        player.position=ccp(200,200);
        [self addChild:player z:1];
        
        //[self registerWithTouchDispatcher];
    }
    return self;
}

-(void) registerWithTouchDispatcher {
    [[CCDirector sharedDirector].touchDispatcher
        addTargetedDelegate:self priority:1 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [self convertTouchToNodeSpace:touch];
    //do something with location here
    
    return YES;
}

-(void) update:(ccTime)deltaTime
{
    [player update:deltaTime];
}


@end
