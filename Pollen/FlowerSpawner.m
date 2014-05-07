//
//  FlowerSpawner.m
//  Pollen
//
//  Created by Garv Manocha on 5/6/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "FlowerSpawner.h"

#import "GameUtility.h"

#import "Flower.h"

@implementation FlowerSpawner

@synthesize yVelocity = yVel_;

-(id) init {
    if(self = [super init]) {
        size = [[CCDirector sharedDirector] winSize];
        
        self.yVelocity = 0;
        
        numParticles_ = 0;
        flowers_ = [[NSMutableArray alloc] init];
    }
    return self;
}
-(void) dealloc {
    [flowers_ dealloc];
    [super dealloc];
}

//SETTER
-(void) setSpawnLayer:(CCLayer*)l {
    spawnLayer = l;
}

-(void) setParticleAmount:(int)n {
    if([flowers_ count] < n) {
        for(int i = 0; i < n-numParticles_; i++) {
            Flower *particle = [Flower node];
            particle.visible = YES;
            particle.position = ccp([GameUtility randInt:0 :size.width],
                                    size.height/4 + (i+1)*(size.height/(n-numParticles_-1)));
                                                //warning; might not work if adding particles
            
            [flowers_ addObject:particle];
            [spawnLayer addChild:particle];
        }
    }
    numParticles_ = n;
}
-(void) resetDeadFlower {
    for(Flower *flower in flowers_) {
        if(flower.visible == NO) {
            flower.position = ccp([GameUtility randInt:0 :size.width],
                                  size.height + [flower boundingBox].size.height/2);
            [flower setColor:[GameUtility randInt:0 :2]];
            flower.visible = YES;
            break;
        }
    }
}

//UPDATE
-(void) update:(ccTime)dt {
    //update flowers
    if([flowers_ count] >= 1) {
        int displayedParticles = numParticles_;
        for(int i = 0; i < [flowers_ count]; i++) {
            Flower *flower = [flowers_ objectAtIndex:i];
            
            if(flower.visible) {
                //update flower velocity
                flower.velocity = ccp(flower.velocity.x, self.yVelocity);
                [flower update:dt];
            }

            if(flower.position.y < -[flower boundingBox].size.height) {
                flower.visible = NO;
            }
            
            if(i < numParticles_) {
                if(flower.visible == NO) {
                    displayedParticles--;
                }
            }
        }
        
        if(displayedParticles < numParticles_) {
            [self resetDeadFlower];
        }
    }
}

@end
