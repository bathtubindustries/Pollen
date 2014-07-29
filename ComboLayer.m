//
//  ComboLayer.m
//  PollenBug
//
//  Created by Eric Nelson on 7/17/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "ComboLayer.h"
#import "GameplayScene.h"
#import "ComboNodeFactory.h"
#import "GameUtility.h"
#import "ComboNode.h"
#import "SpriteLayer.h"
#import "SimpleAudioEngine.h"

@implementation ComboLayer

- (id) init
{
        if (self = [super init])
        {
            buffer = [[CCLayerColor alloc] initWithColor:ccc4(106, 35, 193, 190)];
            //[buffer setOpacity:190];
            [self addChild:buffer z:10];
            factory = [[ComboNodeFactory alloc]init];
            [factory setSpawnLayer:self];
            [self addChild:factory];
            waveCount=1;
            activeIndexForWave=1;
            
            
        }
    return self;
}
-(GameplayScene*) getScene
{
    return scene;
}

-(void) setSpawnLayer:(SpriteLayer *)s
{
    spawnLayer=s;
}

-(void) onEnter
{
    [super onEnter];
    [self registerWithTouchDispatcher];
    [factory spawnWave:waveCount];
}

-(void) comboEnding{
    NSMutableArray*comboFailedActions = [NSMutableArray array];
    
    [comboFailedActions addObject:[CCTintTo actionWithDuration:.5 red:255 green:0 blue:0]];
    [comboFailedActions addObject:[CCFadeOut actionWithDuration:.15]];
    [comboFailedActions addObject:[CCFadeIn actionWithDuration:.15]];
    [comboFailedActions addObject:[CCFadeOut actionWithDuration:.15]];
    [comboFailedActions addObject:[CCCallBlock actionWithBlock:^{
        [spawnLayer comboEnded];
    }]];
    
    [buffer runAction:[CCSequence actionWithArray:comboFailedActions]];
}

-(void) onExit {
    [super onExit];
    [[CCDirector sharedDirector].touchDispatcher removeDelegate:self];
    
}

-(void) update:(ccTime)delta
{
    if(![scene isPausedWithMenu])
    {
    [factory update:delta];
    factory.waveCount=waveCount;
    }
    
}

-(void) registerWithTouchDispatcher {
    [[CCDirector sharedDirector].touchDispatcher
     addTargetedDelegate:self priority:3 swallowsTouches:YES];
    
}

-(void) setScene:(GameplayScene*)s{
    scene=s;
}

-(void) waveEnded
{
    [self onExit];
    
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    if(![scene isPausedWithMenu])
    {

    
        CGPoint location = [self convertTouchToNodeSpace:touch];
        
        for(ComboNode* node in factory.nodes) {
            if(CGRectContainsPoint([node boundingBox], location)) {
                
                if (node.index==activeIndexForWave)
                {
                    node.state = Success;
                    activeIndexForWave++;
                    NSMutableArray *successActions = [NSMutableArray array];
                    [successActions addObject:[CCFadeIn actionWithDuration:.5]];
                    [successActions addObject:[CCCallBlock actionWithBlock:^(void){
                        node.visible=NO;
                        [[factory nodes] removeObject:node];
                    }]];
                        

                    
                    [node.feedbackNode runAction:[CCSequence actionWithArray:[NSArray arrayWithArray:(NSArray*)successActions]]];
                    [node runAction:[CCScaleTo actionWithDuration:.5 scale:1.3]];
                    [[SimpleAudioEngine sharedEngine] playEffect:[NSString stringWithFormat:@"bloop%d.wav",[GameUtility randInt:1 :3]]];
                    
                    
                    
                    if (node.index==[factory nodeCount])
                    {
                        waveCount++;
                        [factory spawnWave:waveCount];
                        activeIndexForWave=1;
                    }
                        
                    break;
                }
            }
        }
    }

    return YES;
}

@end
