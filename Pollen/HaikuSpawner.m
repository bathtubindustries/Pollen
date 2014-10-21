//
//  HaikuSpawner.m
//  PollenBug
//
//  Created by Eric Nelson on 5/24/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "HaikuSpawner.h"
#import "Haiku.h"
#import "GameUtility.h"
#import <Firebase/Firebase.h>
#import "SpriteLayer.h"
#import "ComboLayer.h"


@implementation HaikuSpawner
- (id) init{
    if (self = [super init]){
        haikuBank = [[NSMutableArray alloc] init];
        haikusAdded = [[NSMutableArray alloc] init];
        lastHeightSpawned=0;

        size = [[CCDirector sharedDirector] winSize];
        
        if ([GameUtility firebaseHaikuCount]>1)
        {
            Firebase* myRootRef = [[Firebase alloc] initWithUrl:@"https://ytl3fdvvuk7.firebaseio-demo.com/Haikus"];

            [myRootRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
                
                int index=0;
                for( FDataSnapshot* datum in snapshot.children )
                {
                    NSDictionary*dict = [datum value];
                    
                    if ([[dict objectForKey:@"approved"] isEqualToString:@"yes"])
                    {
                        Haiku * poem = [[Haiku alloc] initWithDictionary:dict];
                        [haikuBank addObject:poem];
                        index++;
                    }
                }
                
            }];
        }

        else
        {
            for (int i=0;i<1;i++){
                [haikuBank addObject:[[Haiku alloc] initHardCoded]];
            }
        }
        
        
        
    }
    return self;
    
}

-(void) setSpawnLayer:(SpriteLayer *)l{
    spawnLayer=l;
}


-(void) spawnHaiku: (int) height{
    
    //make a new haiku with initHaikuWithHaiku or something, parenting is preventing spawns
    
    Haiku * haiku =[[Haiku alloc] initWithHaiku:[haikuBank objectAtIndex:[GameUtility randInt:0 :[haikuBank count]-1]]];
    
      //prevents the same haiku from being spawned multiple times once a certain altitude is reached
    if (lastHeightSpawned != height)
    {
        lastHeightSpawned=height;
        [haikusAdded addObject:haiku];
        
        haiku.position = ccp(size.width/2, size.height/2);
        
        
        haiku.visible=YES;

        /*if (spawnLayer.comboTransitionStarted)
        {
            spawnLayer.comboLayer.haikuSpawned=haiku;
            [spawnLayer.comboLayer addChild:spawnLayer.comboLayer.haikuSpawned z:11];
            
        }*/
        //else
        //{
            [spawnLayer addChild:haiku z:-4];
        //}
        
            
        
        
        [GameUtility saveHaikuCount:[GameUtility savedHaikuCount]+1];
        
    }
    
}


-(Haiku*) getRandomHaiku
{
    int index = [GameUtility randInt:0 :([haikuBank count]-1)];
    return [haikuBank objectAtIndex:index];
}


-(void) update:(ccTime)dt{
    
    //add poem.color animation
    
    for(int i = 0; i < [haikusAdded count]; i++) {
        Haiku *poem = [haikusAdded objectAtIndex:i];
        
        if(poem.visible) {
            //update haiku velocity
            poem.velocity = ccp(poem.velocity.x, self.yVelocity);
            
            [poem update:dt];
        }
        
        if(poem.position.y < -[poem boundingBox].size.height) {
            poem.visible = NO;
        }
    }
    
}
@end