//
//  GameplayScene.m
//  jesusgetshigh
//
//  Created by garv on 4/3/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "GameplayScene.h"
#import "GameplayScene.h"

#import "MainMenuLayer.h"
#import "TreeLayer.h"
#import "SpriteLayer.h"

#import "PlayerSprite.h"

@implementation GameplayScene


    TreeLayer *tree;

    SpriteLayer * player;

-(id) init
{
	
	if( (self=[super init]) )
	{
       /* player= [PlayerSprite node];
        player.position=ccp(100,100);
        [self addChild:player z:1];*/
        
        
        tree=[TreeLayer node];
        [self addChild:tree z:0];
        
        player = [SpriteLayer node];
        [self addChild:player z:1];
        
        
        
        //statLayer = [UILayer node];
        //[self addChild:statLayer z:1];
        
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(didSwipe:)];
       // swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:swipeLeft];
        
        

       
        
        
        
        [self scheduleUpdate];
       
        
        
        
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    NSLog((@"ay"));
    return YES;
}


-(void) update:(ccTime)deltaTime
{
    
    [player update:deltaTime];
   
}




@end
