//
//  FlowerSpawner.h
//  Pollen
//
//  Created by Garv Manocha on 5/6/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "cocos2d.h"

@interface FlowerSpawner : CCNode {
    //references
    CGSize size;
    CCLayer *spawnLayer;
    
    //members
    int numParticles_;
    NSMutableArray *flowers_;
    float yVel_;
}
@property float yVelocity;
@property(nonatomic, retain) NSMutableArray *flowers;
@property int flowerAmount;

//setter
-(void) setSpawnLayer:(CCLayer*)l;
-(void) setParticleAmount:(int)n;
-(void) setHeight:(float)h;
//update
-(void) update:(ccTime)dt;

@end
