//
//  GameplayScene.m
//  jesusgetshigh
//
//  Created by garv on 4/3/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "GameplayScene.h"
#import "GameplayScene.h"
#import "UILayer.h"
#import "MainMenuLayer.h"
#import "TreeLayer.h"
#import "PlayerLayer.h"
#import "PlayerSprite.h"

@implementation GameplayScene

    UILayer *statLayer;
    TreeLayer *tree;
    PlayerLayer *player;
    PlayerSprite * player1;

-(id) init
{
	
	if( (self=[super init]) )
	{
        
        
        
        tree=[TreeLayer node];
        [self addChild:tree];
        
        
        //statLayer = [UILayer node];
        //[self addChild:statLayer z:1];
        
        player=[PlayerLayer node];
        [self addChild:player z:1];
        
        player1= [PlayerSprite node];
        player1.position=ccp(100,100);
        [self addChild:player1 z:1];
        
        [self scheduleUpdate];
       
        
        
        
    }
    return self;
}


-(void) update:(ccTime)deltaTime
{
    [player update:deltaTime];
    [player1 update:deltaTime];
   
}




@end
