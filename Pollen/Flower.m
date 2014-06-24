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
    color_ = col;
    
    if(self = [super initWithFile:[NSString stringWithFormat:@"flowersUnshaded.pvr.ccz"] capacity:4]) {
        animationFrames = [[NSMutableArray alloc] init];
        for(int i = 0; i < 4; i++) {
            [animationFrames addObject: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                                         [NSString stringWithFormat:@"%@%i.png", colorFile_, i]]];
        }
        
        flowerSprite_ = [CCSprite spriteWithSpriteFrame:[animationFrames objectAtIndex:0]];
        [self addChild: flowerSprite_];
        
        self.bloomHealth = FLOWER_BLOOM_HEALTH;
        self.bloomed = NO;
        self.velocity = CGPointZero;
    }
    return self;
}

//setter
-(void) setColor:(int)col {
    //set flower to new color
    if(color_ != col)
        color_ = col;
    else
        color_ = color_ + 1;
    
    if(color_ > 2)
        color_ = 0;
    
    //update files
    [self setFiles:color_];
    
    [animationFrames removeAllObjects];
    for(int i = 0; i < 4; i++) {
        [animationFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                                    [NSString stringWithFormat:@"%@%i.png", colorFile_, i]]];
    }
    
    //update sprite
    if(self.bloomed)
        [flowerSprite_ setDisplayFrame:[animationFrames objectAtIndex:[animationFrames count]-1]];
    else
        [flowerSprite_ setDisplayFrame:[animationFrames objectAtIndex:0]];
}

-(void) bloomFlowerWithPower:(float)pow {
    if(self.bloomHealth > 0 && !self.bloomed) {
        self.bloomHealth -= pow;
    }
    
    if(self.bloomHealth <= 0) {
        self.bloomed = YES;
        
        CCAnimation *flowerAnimation = [CCAnimation animationWithSpriteFrames:animationFrames delay:0.065f];
        CCAction *animationAction = [CCAnimate actionWithAnimation:flowerAnimation];
        [flowerSprite_ runAction:animationAction];
    }
}

-(void) resetBloom {
    self.bloomed = NO;
    self.bloomHealth = FLOWER_BLOOM_HEALTH;
    
    //reset to first frame
    [flowerSprite_ stopAllActions];
    [flowerSprite_ setDisplayFrame:[animationFrames objectAtIndex:0]];
}

//update
-(void) update:(ccTime)dt {
    self.position = ccp(self.position.x + self.velocity.x*dt,
                        self.position.y + self.velocity.y*dt);
}

//overrides
-(CGPoint) position { return flowerSprite_.position; }
-(void) setPosition:(CGPoint)position {
    flowerSprite_.position = position;
}
-(CGRect) boundingBox {
    return CGRectMake(self.position.x - FLOWER_WIDTH/2, self.position.y - FLOWER_HEIGHT/2, FLOWER_WIDTH, FLOWER_HEIGHT);
}

//utility
-(void) setFiles:(int)col {
    switch(col) {
        case 0:
            colorFile_ = @"blueFlowerUnshaded";
            break;
        case 1:
            colorFile_ = @"redFlowerUnshaded";
            break;
        case 2:
        default:
            colorFile_ = @"whiteFlowerUnshaded";
            break;
    }
}

@end
