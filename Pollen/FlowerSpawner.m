//
//  FlowerSpawner.m
//  Pollen
//
//  Created by Garv Manocha on 5/6/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "FlowerSpawner.h"

#import "Flower.h"
#import "SpriteLayer.h"
#import "GameUtility.h"

#define MIN_FLOWERS 3
#define HEIGHT_INCREMENT 295 //was 400
#define HEIGHT_OFFSET 60 //was 250

@implementation FlowerSpawner

@synthesize yVelocity = yVel_;
@synthesize flowers = flowers_;
@synthesize flowerAmount = numParticles_;

-(id) init {
    if(self = [super init]) {
        size = [[CCDirector sharedDirector] winSize];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"flowersUnshaded.plist"];
        
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
    if([flowers_ count] == 0 && [flowers_ count] < n) { //will not add particles after first spawning
        float particleDistance = SIZE_HEIGHT/(n-1);
        unsigned short extraParticles = 0;
        while(extraParticles * particleDistance < FLOWER_HEIGHT) extraParticles++;
        //NSLog(@"%i", extraParticles);
        
        for(int i = 0; i < n+extraParticles; i++) {
            Flower *particle = [Flower node];
            particle.visible = YES;
            
            //flip i
            float xbuf = i*(size.width/(n+extraParticles));
            particle.position = ccp([GameUtility randInt:size.width/2-xbuf :size.width/2+xbuf+1],
                                    size.height/2 + (i+1)*(SIZE_HEIGHT/(n-1)));
                                                //warning; might not work if adding particles
            
            [flowers_ addObject:particle];
            [spawnLayer addChild:particle];
        }
    }
    numParticles_ = n;
}
-(void) resetDeadFlower {
    for(int i = 0; i < [flowers_ count]; i++) {
        Flower *flower = [flowers_ objectAtIndex:i];
        if(flower.visible == NO) {
            //create top buffer to make sure particles are evenly spread out
            int buffer = SIZE_HEIGHT/(numParticles_-1);
            //subtract distance from last flower to top of screen
            int j = i-1; if(j < 0) j = [flowers_ count]-1;
            Flower *prevFlower = [flowers_ objectAtIndex:j];
            buffer -=  size.height - prevFlower.position.y;
            //minimum buffer value
            if(buffer < [flower boundingBox].size.height/2)
                buffer = [flower boundingBox].size.height/2;
            
            flower.position = ccp([GameUtility randInt:[flower boundingBox].size.width/4 //x
                                                      :size.width - [flower boundingBox].size.width/4],
                                  size.height + buffer);                                 //y
            
            [flower setColor:[GameUtility randInt:0 :2]];
            [flower resetBloom];
            
            flower.visible = YES;
            break;
        }
    }
}

-(void) handleHeight:(float)h {
    //get iterator for height increments
    int nextHeightChange = INITIAL_FLOWER_AMOUNT-self.flowerAmount+1;
    if(nextHeightChange > 0 && nextHeightChange <= INITIAL_FLOWER_AMOUNT-MIN_FLOWERS) {
        //if height has increased and amount is still old
        if((h > (nextHeightChange-1)*HEIGHT_INCREMENT + HEIGHT_OFFSET) &&
           (self.flowerAmount > INITIAL_FLOWER_AMOUNT-nextHeightChange)) {
            [self setParticleAmount:self.flowerAmount-1];
            
           // NSLog(@"height: %f, flower amount: %i", h, self.flowerAmount);
        }
    }
    //NSLog(@"iterator: %i", nextHeightChange);
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
                displayedParticles--;//
            }
            
            /*if(i < numParticles_) {
                if(flower.visible == NO) {
                    displayedParticles--;
                }
            }*/
        }
        
        if(displayedParticles < numParticles_) {
            [self resetDeadFlower];
        }
    }
}

@end
