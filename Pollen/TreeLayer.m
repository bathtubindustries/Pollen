//
//  TreeLayer.h
//  jesusgetshigh
//
//  Created by Eric Nelson on 4/12/14.
//  Copyright 2014 bathtubindustries. All rights reserved.
//

#import "TreeLayer.h"

@implementation TreeLayer

-(id)init
{
    if(self=[super init])
    {
        //references
        size = [[CCDirector sharedDirector] winSize];
        yVel_ = 0;
        
        //background images
		bgGround = [CCSprite spriteWithFile:@"treebase.png"];
        bgGround.anchorPoint = ccp(0.5, 0);
        bgGround.position = ccp(size.width/2, 0);
		[self addChild: bgGround z:2];
        
        bgSky1 = [CCSprite spriteWithFile:@"treebody1.png"];
        bgSky1.anchorPoint = ccp(0.5, 0);
        bgSky1.position = ccp(bgGround.position.x, bgGround.position.y + [bgGround boundingBox].size.height);
        [self addChild: bgSky1 z:1];
        
        bgSky2 = [CCSprite spriteWithFile:@"treebody2.png"];
        bgSky2.anchorPoint = ccp(0.5, 0);
        bgSky2.position = ccp(bgSky1.position.x, bgSky1.position.y + [bgSky1 boundingBox].size.height);
        bgSky2.visible = NO;
        [self addChild: bgSky2 z:0];
    }
    return self;
}

//SETTER
-(void) setYVelocity:(float)vel {
    yVel_ = vel;
}

//UPDATE
-(void) update:(ccTime)dt {
    //base ground img
    if(bgGround.visible) {
        if(bgGround.position.y < -[bgGround boundingBox].size.height) {
            bgGround.visible = NO;
            bgSky2.visible = YES;
            //[self removeChild:bgGround];
        } else {
            bgGround.position = ccp(bgGround.position.x, bgGround.position.y - yVel_*dt);
        }
    }
    
    //sky imgs
    bgSky1.position = ccp(bgSky1.position.x, bgSky1.position.y - yVel_*dt);
    bgSky2.position = ccp(bgSky2.position.x, bgSky2.position.y - yVel_*dt);
    
    if(bgSky1.position.y < -[bgSky1 boundingBox].size.height)
        bgSky1.position = ccp(bgSky1.position.x, bgSky2.position.y + [bgSky2 boundingBox].size.height);
    if(bgSky2.position.y < -[bgSky2 boundingBox].size.height)
        bgSky2.position = ccp(bgSky2.position.x, bgSky1.position.y + [bgSky1 boundingBox].size.height);
}

@end
