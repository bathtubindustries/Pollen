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

    
    [self setTouchEnabled:YES];
    size = [[CCDirector sharedDirector] winSize];
    player=[PlayerSprite node];
    
    
    player.position=ccp(200,200);
    
    [self addChild:player z:1];
    }
    
    
    return self;
    
}

-(void) update:(ccTime)deltaTime
{
    
    [player update:deltaTime];
    
}


@end
