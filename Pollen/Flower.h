//
//  Flower.h
//  Pollen
//
//  Created by Garv Manocha on 5/6/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "CCSprite.h"

#define FLOWER_BLOOM_HEALTH 100.f
#define FLOWER_POLLEN_AMOUNT 2.f

@interface Flower : CCSpriteBatchNode {
    NSMutableArray *animationFrames;
    CCSprite *flowerSprite_;
    
    int color_;
    NSString *colorFile_;
    
    float bloomHealth_;
    BOOL bloomed_;
    CGPoint velocity_;
}
@property float bloomHealth;
@property BOOL bloomed;
@property CGPoint velocity;
@property CGPoint position;

-(id) initWithColor:(int)col;

//setter
-(void) setColor:(int)col;
-(void) bloomFlowerWithPower:(float)pow;
-(void) resetBloom;
//update
-(void) update:(ccTime)dt;

@end
