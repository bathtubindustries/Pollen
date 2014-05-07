//
//  Flower.h
//  Pollen
//
//  Created by Garv Manocha on 5/6/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "CCSprite.h"

#define FLOWER_BLOOM_HEALTH 100

@interface Flower : CCSprite {
    NSString *budFile_, *bloomFile_;
    
    int color_;
    
    float bloomHealth_;
    BOOL bloomed_;
    CGPoint velocity_;
}
@property float bloomHealth;
@property BOOL bloomed;
@property CGPoint velocity;

-(id) initWithColor:(int)col;

//setter
-(void) setColor:(int)col;
-(void) bloomFlowerWithPower:(float)pow;
-(void) resetBloom;
//update
-(void) update:(ccTime)dt;

@end