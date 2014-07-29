//
//  ComboNodeFactory.m
//  PollenBug
//
//  Created by Eric Nelson on 7/14/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "ComboNodeFactory.h"
#import "ComboNode.h"
#import "GameUtility.h"
#import "ComboLayer.h"
#import "GameplayScene.h"
@implementation ComboNodeFactory
@synthesize nodes=nodes_;


-(id) init{
    if (self = [super init])
    {
        self.nodeCount=0;
        playerFailed = NO;
        nodes_ = [[NSMutableArray alloc] init];

    }
    return self;
}

-(void) update:(ccTime)dt {
    //update nodes

    if([nodes_ count] >= 1)
    {
        for(int i = 0; i < [nodes_ count]; i++) {
            ComboNode *node = [nodes_ objectAtIndex:i];
            
            if(node.visible) {
                //update node velocity
                node.velocity = ccp(node.velocity.x, node.velocity.y-self.waveCount);
                [node update:dt];
               
            }
            
            if(node.position.y < -[node boundingBox].size.height || !node.visible) {
                node.visible = NO;
                [nodes_ removeObject:node];
                if (!playerFailed && !node.state==Success)
                {
                    [spawnLayer comboEnding];
                    playerFailed=YES;
                }
            }
        }
    }

}

-(void) spawnWave:(int) waveCount
{
    NSMutableArray *spawns = [NSMutableArray array];
    float duration=0;
    self.nodeCount=waveCount+4;
    if (waveCount ==1){
        duration=1.4;
    }
    else if (waveCount==2)
    {
        duration=1.2;
    }
    else if (waveCount==3)
    {
        duration=1.12;
    }
    else if (waveCount==4)
    {
        duration=1.0;
    }
    else if (waveCount<10)
    {
        duration=.88;
    }
    else if (waveCount<15)
    {
        duration=.80;
    }
    else {
        duration=.74;
    }
    for (int i=1; i<=self.nodeCount; i++)
    {

        float spawnIntervalDelay;
        spawnIntervalDelay=(i>6) ? duration/6 : duration/i;
        if (i==1 && waveCount!=1)
        {
            spawnIntervalDelay*=.2;
        }
        
        [spawns addObject:[CCDelayTime actionWithDuration:(i>6) ? duration/6 : duration/i]];
        [spawns addObject:[CCCallBlock actionWithBlock:^(void){
            
            ComboNode *nod =[[[ComboNode alloc]initWithIndex:i] autorelease];
            nod.visible=YES;
            [nodes_ addObject:nod];
            [spawnLayer addChild:nod z:15];
            
        }]];

         
        
    }
    
    [spawnLayer runAction:[CCSequence actionWithArray:[NSArray arrayWithArray:(NSArray*)spawns]]];
    
        
        
    
}


-(void) setSpawnLayer:(ComboLayer*)l {
    spawnLayer = l;
}

-(void) dealloc {
    [nodes_ dealloc];
    [super dealloc];
}

@end