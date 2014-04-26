//
//  PlayerLayer.m
//  jesusgetshigh
//
//  Created by Eric Nelson on 4/12/14.
//  Copyright 2014 bathtubindustries. All rights reserved.
//

#import "PlayerLayer.h"


@implementation PlayerLayer



-(id)init{
    
    [self setTouchEnabled:YES];
    size = [[CCDirector sharedDirector] winSize];
    player=[PlayerSprite node];
    player.position=ccp(200,200);
    
    [self addChild:player];
    
    
    
    return self;
    
}

@end
