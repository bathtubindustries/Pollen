//
//  ComboNodeFactory.h
//  PollenBug
//
//  Created by Eric Nelson on 7/14/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "CCNode.h"
@class ComboNode;
@class ComboLayer;

@interface ComboNodeFactory : CCNode{
    CGSize size;
    ComboLayer *spawnLayer;
    NSMutableArray *nodes_;
    BOOL playerFailed;
    NSMutableArray *pauseQueue;
}
-(void) update:(ccTime)delta;
-(void) setSpawnLayer:(ComboLayer*)l;
-(void) spawnWave:(int) waveCount;
@property float yVelocity;
@property(nonatomic, retain) NSMutableArray *nodes;
@property int nodeCount;
@property int waveCount;

@end
