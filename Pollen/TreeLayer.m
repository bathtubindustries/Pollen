//
//  TreeLayer.h
//  jesusgetshigh
//
//  Created by Eric Nelson on 4/12/14.
//  Copyright 2014 bathtubindustries. All rights reserved.
//

#import "TreeLayer.h"

@implementation TreeLayer
#define LEVEL_2_BEGINS 300

-(id)init
{
    if(self=[super init])
    {
        //references
        size = [[CCDirector sharedDirector] winSize];
        yVel_ = 0;
        level_=0;
        //background images
		bgGround = [CCSprite spriteWithFile:@"treebase.png"];
        bgGround.anchorPoint = ccp(0.5, 0);
        bgGround.position = ccp(size.width/2, 0);
		[self addChild: bgGround z:4];
        
        bgSky1 = [CCSprite spriteWithFile:@"treebody1.png"];
        bgSky1.anchorPoint = ccp(0.5, 0);
        bgSky1.position = ccp(bgGround.position.x, bgGround.position.y + [bgGround boundingBox].size.height);
        [self addChild: bgSky1 z:3];
        
        bgSky2 = [CCSprite spriteWithFile:@"treebody2.png"];
        bgSky2.anchorPoint = ccp(0.5, 0);
        bgSky2.position = ccp(bgSky1.position.x, bgSky1.position.y + [bgSky1 boundingBox].size.height);
        bgSky2.visible = NO;
        [self addChild: bgSky2 z:2];
        
        bgSky3 = [CCSprite spriteWithFile:@"treebody3.png"];
        bgSky3.anchorPoint = ccp(0.5, 0);
        bgSky3.position = ccp(bgSky1.position.x, bgSky2.position.y + [bgSky2 boundingBox].size.height);
        bgSky3.visible = NO;
        [self addChild: bgSky3 z:1];
        
        bgSky4 = [CCSprite spriteWithFile:@"treebody4.png"];
        bgSky4.anchorPoint = ccp(0.5, 0);
        bgSky4.position = ccp(bgSky1.position.x, bgSky3.position.y + [bgSky3 boundingBox].size.height);
        bgSky4.visible = NO;
        [self addChild: bgSky4 z:0];
    }
    return self;
}

//SETTER
-(void) setYVelocity:(float)vel {
    yVel_ = vel;
}


-(void) setAltitude:(float)alt {
    altitude_ = alt;
}

//UPDATE
-(void) update:(ccTime)dt {
    //base ground img
    if(bgGround.visible) {
        if(bgGround.position.y < -[bgGround boundingBox].size.height) {
            bgGround.visible = NO;
            bgSky2.visible = YES;
            level_=1;
            //[self removeChild:bgGround];
        } else {
            bgGround.position = ccp(bgGround.position.x, bgGround.position.y - yVel_*dt);
        }
    }
    
    //check lvl before rearranging bg images
    if (level_ == 1){
        if(bgSky1.position.y < -[bgSky1 boundingBox].size.height)
            bgSky1.position = ccp(bgSky1.position.x, bgSky2.position.y + [bgSky2 boundingBox].size.height);
        if(bgSky2.position.y < -[bgSky2 boundingBox].size.height)
            bgSky2.position = ccp(bgSky2.position.x, bgSky1.position.y + [bgSky1 boundingBox].size.height);
    }
    
    
    //switches level
    if (altitude_ > LEVEL_2_BEGINS && level_< 2){    //Level 2 begins at defined altitude
        
        NSLog (@"Level two begins");
        if(bgSky2.position.y < -[bgSky2 boundingBox].size.height){
            bgSky2.position = ccp(bgSky2.position.x, bgSky1.position.y + [bgSky1 boundingBox].size.height);
            bgSky3.position = ccp(bgSky3.position.x, bgSky2.position.y + [bgSky2 boundingBox].size.height);
            
        }
        
        level_=2;
    }
    
    
    else if (level_== 2){
        
        bgSky3.visible=YES;
        bgSky4.visible=YES;
        
        if(bgSky3.position.y < -[bgSky3 boundingBox].size.height)
            bgSky3.position = ccp(bgSky3.position.x, bgSky4.position.y + [bgSky4 boundingBox].size.height);
        if(bgSky4.position.y < -[bgSky4 boundingBox].size.height){
            bgSky4.position = ccp(bgSky4.position.x, bgSky3.position.y + [bgSky3 boundingBox].size.height);
        }
        
        
        if (bgSky2.visible){
            if(bgSky2.position.y < -[bgSky2 boundingBox].size.height)
                bgSky2.visible=NO;
            if(bgSky1.position.y < -[bgSky1 boundingBox].size.height)
                bgSky1.visible=NO;
        }
        
    }
    
    //sky imgs
    bgSky1.position = ccp(bgSky1.position.x, bgSky1.position.y - yVel_*dt);
    bgSky2.position = ccp(bgSky2.position.x, bgSky2.position.y - yVel_*dt);
    bgSky3.position = ccp(bgSky3.position.x, bgSky3.position.y - yVel_*dt);
    bgSky4.position = ccp(bgSky4.position.x, bgSky4.position.y - yVel_*dt);
    
    
    
    
}

@end
