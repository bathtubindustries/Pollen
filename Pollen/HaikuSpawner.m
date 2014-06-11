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
        for (int i=0;i<100;i++){
            [haikus addObject:[[Haiku alloc] initWithFileAndTitleAndIndex:@"InstructTxt.png" title:@"Instruct" index:i]];
        }
        
    }
    return self;
    
}

-(void) setSpawnLayer:(CCLayer *)l{
    spawnLayer=l;
}


-(void) spawnHaiku: (int) index{
    
    Haiku * haiku =[haikus objectAtIndex:index];
    
    //prevents multiple spawns of first haiku
    if ([GameUtility isHaikuDiscoverable:haiku.title] || index!=0){
        
        
        //prevents the same haiku from being spawned multiple times once a certain altitude is reached
        if (haiku.parent)
        {
            return;
        }
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"haikuColorFade.plist"];
        haikuSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"haikuColorFade.png"];
        
        
        //animate haiku
        haikuAnimFrames= [[NSMutableArray alloc] init];
        haiku.bgSprite  = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"haiku1.png"]]];
        for (int i=1; i<=8; i++) {
            if (i!=2){
                [haikuAnimFrames addObject:
                 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                  [NSString stringWithFormat:@"haiku%d.png",i]]];
            }
            else{
                [haikuAnimFrames addObject:
                 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                  [NSString stringWithFormat:@"haiku%dg.png",i]]];
            }
        }
        
        haikuAnim = [CCAnimation animationWithSpriteFrames:haikuAnimFrames delay:0.18f];
        CCAction * haikuFade =[CCAnimate actionWithAnimation:haikuAnim];
        
        [haiku.bgSprite runAction:haikuFade];
        
        if (index!=0)
        {
            haiku.bgSprite.position = ccp(size.width/2,3*size.height/4);
            haiku.position = ccp(size.width/2, 3*size.height/4);
        }
        else
        {
            haiku.bgSprite.position = ccp(size.width/2, size.height/2);
            haiku.position = ccp(size.width/2, size.height/2);
        }
        
        haiku.bgSprite.scale=2.0;
        haiku.bgSprite.visible=YES;
        haiku.visible=YES;
        [haikuSpriteSheet addChild:haiku.bgSprite];
        if (!haiku.parent){
            [spawnLayer addChild:haikuSpriteSheet z:-1];
            [spawnLayer addChild:haiku z:haikuSpriteSheet.zOrder+1];
        }
       
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
            
            //first Haiku doesn't move at all
            
            [poem update:dt];
        }
        
        if(poem.position.y < -[poem boundingBox].size.height) {
            poem.visible = NO;
            poem.bgSprite.visible=NO;
        }
    }
    
}
@end
