//
//  HaikuSpawner.h
//  PollenBug
//
//  Created by Eric Nelson on 5/24/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "CCNode.h"

@interface HaikuSpawner : CCNode{
    
    
    CCScene * scene;
    CGSize size;
    CCLayer *spawnLayer;
    NSMutableArray *haikus;
    
    CCAnimation *haikuAnim;
    CCSpriteBatchNode *haikuSpriteSheet;
    NSMutableArray *haikuAnimFrames;
}
@property float yVelocity;
-(void) update:(ccTime)dt;
-(void) setSpawnLayer:(CCLayer*)l;
-(void) spawnHaiku: (int) index;

@end
