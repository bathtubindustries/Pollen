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
#import "SpidderEye.h"
#import "SimpleAudioEngine.h"
#import "Haiku.h"

@implementation ComboLayer

- (id) init
{
        if (self = [super init])
        {
            size= [[CCDirector sharedDirector] winSize];
             scaleFactor= size.height/size.width;
            
            buffer = [[CCLayerColor alloc] initWithColor:ccc4(106, 35, 193, 190)];
            //[buffer setOpacity:190];
            [self addChild:buffer z:10];
            factory = [[ComboNodeFactory alloc]init];
            [factory setSpawnLayer:self];
            [self addChild:factory];
            waveCount=1;
            activeIndexForWave=1;
            
            eyes_ = [[NSMutableArray alloc] init];
            eyesToRemove_ = [[NSMutableArray alloc] init];
            
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
    
    if ([self.children containsObject:self.haikuSpawned])
    {
        [self removeChild:self.haikuSpawned];
        [spawnLayer addChild:self.haikuSpawned z:-4];
    }
    
}

-(void) update:(ccTime)delta
{
    if(![scene isPausedWithMenu])
    {
    [factory update:delta];
    factory.waveCount=waveCount;
    }
    //removes spidder eye drops when they leave screen
    if ([eyes_ count]!=0) {
        for (SpidderEye* eye in eyes_){
            if (eye.visible){
                [eye update:delta];
            }
            else{
                [eyesToRemove_ addObject:eye];
            }
        }
    }
    
    [eyes_ removeObjectsInArray:eyesToRemove_];
    [eyesToRemove_ removeAllObjects];
    
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
                    {//swame
                        
                        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"spidderEyeDrop.plist"];
                        eyeSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"spidderEyeDrop.png"];
                        [self addChild:eyeSpriteSheet z:1000];
                        
                        //drop an eye
                        //spidder eye animation
                        
                            eyeAnimFrames = [NSMutableArray array];
                            for (int i=1; i<=16; i++) {
                                [eyeAnimFrames addObject:
                                 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                                  [NSString stringWithFormat:@"eye%d.png",i]]];
                            }
                            eyeAnim = [CCAnimation animationWithSpriteFrames:eyeAnimFrames delay:0.1f];
                            [eyes_ addObject:[[SpidderEye alloc] init ]];
                            CCAction * flash =[CCAnimate actionWithAnimation:eyeAnim];
                            
                            ((SpidderEye*)[eyes_ lastObject]).position = ccp(size.width/2, size.height*.90);
                            [[eyes_ lastObject] runAction:[CCScaleTo actionWithDuration:0.0 scale:1.5]];
                            [[eyes_ lastObject] runAction:flash];
                            [eyeSpriteSheet addChild:[eyes_ lastObject]];
                        
                        
                        
                        [GameUtility saveSpidderEyeCount:([GameUtility savedSpidderEyeCount]+1)];
                        
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
