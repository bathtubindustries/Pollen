//
//  Flower.m
//  Pollen
//
//  Created by Garv Manocha on 5/6/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "Flower.h"

#import "cocos2d.h"
#import "GameUtility.h"

#define FLOWER_BLOOM_HEALTH 100

@implementation Flower

@synthesize bloomHealth = bloomHealth_;
@synthesize bloomed = bloomed_;
@synthesize velocity = velocity_;

-(id) init {
    //choose random flower
    int flowerColor = [GameUtility randInt:0 :2];
    return [self initWithColor:flowerColor];
}
-(id) initWithColor:(int)col {
    //set flower img files
    [self setFiles:col];
    
    if(self = [super initWithFile:budFile_]) {
        self.bloomHealth = FLOWER_BLOOM_HEALTH;
        self.bloomed = NO;
        self.velocity = CGPointZero;
    }
    return self;
}

//setter
-(void) setColor:(int)col {
    //set flower to new color
    color_ = col;
    [self setFiles:col];
    if(self.bloomed)
        [GameUtility loadTexture:bloomFile_ Into:self];
    else
        [GameUtility loadTexture:budFile_ Into:self];
}

-(void) bloomFlowerWithPower:(float)pow {
    if(self.bloomHealth > 0 && !self.bloomed) {
        self.bloomHealth -= pow;
    }
    
    if(self.bloomHealth <= 0) {
        self.bloomed = YES;
        [GameUtility loadTexture:bloomFile_ Into:self];
    }
}

//update
-(void) update:(ccTime)dt {
    self.position = ccp(self.position.x + self.velocity.x*dt,
                        self.position.y + self.velocity.y*dt);
}

//utility
-(void) setFiles:(int)col {
    switch(col) {
        case 0:
            budFile_ = @"flowerGreenBud.png";
            bloomFile_ = @"flowerGreenBloom.png";
            break;
        case 1:
            budFile_ = @"flowerRedBud.png";
            bloomFile_ = @"flowerRedBloom.png";
            break;
        case 2:
        default:
            budFile_ = @"flowerBlueBud.png";
            bloomFile_ = @"flowerBlueBloom.png";
            break;
    }
}

@end
