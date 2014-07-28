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
    if (waveCount ==1){
        duration=1.5;
    }
    else if (waveCount==2)
    {
        duration=1.3;
    }
    else if (waveCount==3)
    {
        duration=1.15;
    }
    else if (waveCount==4)
    {
        duration=1.0;
    }
    else
    {
        duration=.88;
    }
    for (int i=1; i<=9; i++)
    {

        [spawns addObject:[CCDelayTime actionWithDuration:duration/i]];
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
