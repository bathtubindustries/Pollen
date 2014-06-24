//
//  TreeLayer.h
//  jesusgetshigh
//
//  Created by Eric Nelson on 4/12/14.
//  Copyright 2014 bathtubindustries. All rights reserved.
//

#import "cocos2d.h"

@interface TreeLayer : CCLayer {
    //references
    CGSize size;

    //members
    CCSprite *bgGround;
    CCSprite *bgSky1;
    CCSprite *bgSky2;
    CCSprite *bgSky3;
    CCSprite *bgSky4;
    
    float yVel_;
    
    int level_;  //determines which pair of backgrounds alternate
    float altitude_;    //passed in from player, influences level swap
}

//setter
-(void) setYVelocity:(float)vel;
-(void) setAltitude:(float)alt;
//update
-(void) update:(ccTime)dt;

@end
