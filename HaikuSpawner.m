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



@implementation HaikuSpawner
- (id) init{
    if (self = [super init]){
        
        size = [[CCDirector sharedDirector] winSize];
        
        haikus = [[NSMutableArray alloc] init];
        [haikus addObject:[[Haiku alloc] initWithFileAndTitle:@"Instruct.png" title:@"Instruct"]];
        [haikus addObject:[[Haiku alloc] initWithFileAndTitle:@"Instruct.png" title:@"Instruct"]];

        
        
    }
    return self;
    
}

-(void) setSpawnLayer:(CCLayer *)l{
    spawnLayer=l;
}


-(void) spawnHaiku: (int) index{
    
    Haiku * haiku =[haikus objectAtIndex:index];
    
    
    //want to always spawn but animate / charge haiku once - will implement soon
    
    //prevents multiple spawns
    if ([GameUtility isHaikuDiscoverable:haiku.title]){
        
        haiku.position = ccp(size.width/2,size.height/2);
        haiku.visible=YES;
        [spawnLayer addChild:haiku];
       
        //permanently logs that player has discovered this haiku
        [GameUtility saveHaikuCount:[GameUtility savedHaikuCount]+1];
        [GameUtility HaikuDiscovered:haiku.title discoverable: NO];
        
    }
    
}



-(void) update:(ccTime)dt{
    
    //add poem.color animation
    
    for(int i = 0; i < [haikus count]; i++) {
        Haiku *poem = [haikus objectAtIndex:i];
        
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
