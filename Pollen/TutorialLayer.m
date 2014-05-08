//
//  TutorialLayer.m
//  Pollen
//
//  Created by Garv Manocha on 5/7/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "TutorialLayer.h"

#import "cocos2d.h"
#import "SimpleAudioEngine.h"

#define MESSAGE_COUNT 5

@implementation TutorialLayer

-(id) init {
    if(self = [super init]) {
        size = [[CCDirector sharedDirector] winSize];
        
        currentMessage_ = 0;
        messages_ = [[NSMutableArray alloc] init];
        
        for(int i = 0; i < MESSAGE_COUNT; i++)
            [messages_ addObject:[CCSprite spriteWithFile:[NSString stringWithFormat:@"tutorialMessage%i.png", i+1]]];
        
        for(CCSprite *message in messages_) {
            message.position = ccp(size.width/2, size.height/2 - 20);
            message.visible = NO;
            [self addChild:message];
        }
        
        CCSprite *firstMessage = [messages_ objectAtIndex:0];
        firstMessage.visible = YES;
        
        //sounds
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"xylophone.wav"];
    }
    return self;
}
-(void) onEnter {
    [super onEnter];
    [[CCDirector sharedDirector].touchDispatcher
     addTargetedDelegate:self priority:1 swallowsTouches:YES];
}
-(void) dealloc {
    [messages_ dealloc];
    [super dealloc];
}

//INPUT
-(BOOL) ccTouchBegan:(UITouch*)touch withEvent:(UIEvent*)event {
    currentMessage_++;
    if(currentMessage_ >= [messages_ count]) {
        CCSprite *message = [messages_ objectAtIndex:[messages_ count]-1];
        message.visible = NO;
        [[CCDirector sharedDirector].touchDispatcher removeDelegate:self];
    } else {
        for(int i = 0; i < [messages_ count]; i++) {
            CCSprite *message = [messages_ objectAtIndex:i];
            if(i == currentMessage_) {
                message.visible = YES;
            } else {
                message.visible = NO;
            }
        }
        [[SimpleAudioEngine sharedEngine] playEffect:@"xylophone.wav"];
    }
    
    return YES;
}

@end
