//
//  StoreLayer.m
//  Pollen
//
//  Created by Garv Manocha on 5/7/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "StoreLayer.h"

#import "MainMenuLayer.h"

@implementation StoreLayer

-(id) init {
    if(self = [super init]) {
        CCSprite *img = [CCSprite spriteWithFile:@"pollenstorebg.png"];
        img.anchorPoint = ccp(0, 0);
        img.position = ccp(0, 0);
        [self addChild:img];
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        
        
        ProductMenuItem * sporeTwig = [[ProductMenuItem alloc]initWithProductNumber:0];
        sporeTwig.position = ccp(winSize.width/2 - sporeTwig.activeArea.size.width/1.38, winSize.height - sporeTwig.activeArea.size.height);
        
        ProductMenuItem * Dandelion = [[ProductMenuItem alloc]initWithProductNumber:1];
        Dandelion.position = ccp(winSize.width - Dandelion.activeArea.size.width/1.38, winSize.height - Dandelion.activeArea.size.height);
        

        
        CCMenu *pauseMenu = [CCMenu menuWithItems:sporeTwig,Dandelion, nil];
        pauseMenu.position = CGPointZero;
        [self addChild:pauseMenu];
        
        
        
    }
    return self;
}



-(void) onEnter {
    [super onEnter];
    [[CCDirector sharedDirector].touchDispatcher
     addTargetedDelegate:self priority:0 swallowsTouches:YES];
}
-(void) onExit {
    [super onExit];
    [[CCDirector sharedDirector].touchDispatcher removeDelegate:self];
}

//INPUT
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    [[CCDirector sharedDirector] replaceScene:
     [CCTransitionSlideInT transitionWithDuration:0.5 scene:[MainMenuLayer scene]]];
    return YES;
}

//UTILITY
+(CCScene*) scene {
    CCScene *scene = [CCScene node];
    StoreLayer *layer = [StoreLayer node];
    [scene addChild:layer];
    return scene;
}

@end
