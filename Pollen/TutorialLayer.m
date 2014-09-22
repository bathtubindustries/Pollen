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

@synthesize tutorialState = tutorialState_;
@synthesize waitingEvent = waitingEvent_;

-(id) init {
    if(self = [super init]) {
        size = [[CCDirector sharedDirector] winSize];
        
        waitingEvent_ = NO;
        tutorialState_ = 0;

        messages_ = [[NSMutableArray alloc] init];
        for(int i = 0; i < MESSAGE_COUNT; i++)
            [messages_ addObject:[CCSprite spriteWithFile:[NSString stringWithFormat:@"tutorialMessage%i.png", i+1]]];
        
        for(CCSprite *message in messages_) {
            message.position = ccp(size.width/2, size.height/2);
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
     addTargetedDelegate:self priority:1 swallowsTouches:NO];
}
-(void) dealloc {
    [messages_ dealloc];
    [super dealloc];
}

//UTILITY
-(void) setScene:(GameplayScene*)s{
    scene=s;
}
-(void) updateMessages {
    for(int i = 0; i < [messages_ count]; i++) {
        CCSprite *message = [messages_ objectAtIndex:i];
        if(i == tutorialState_ && !waitingEvent_) {
            message.visible = YES;
        } else {
            message.visible = NO;
        }
    }
}

//INPUT
-(BOOL) ccTouchBegan:(UITouch*)touch withEvent:(UIEvent*)event {
    if(!waitingEvent_) {
        if(tutorialState_ >= Tilt)
            waitingEvent_ = YES;
        if(tutorialState_ >= Tap)
            [scene resume];
        
        tutorialState_++;
       [[SimpleAudioEngine sharedEngine] playEffect:@"xylophone.wav"];
    }
    
    
    if(tutorialState_ >= [messages_ count]) {
        CCSprite *message = [messages_ objectAtIndex:[messages_ count]-1];
        message.visible = NO;
        scene.tutorialActive=NO;
        [[CCDirector sharedDirector].touchDispatcher removeDelegate:self];
    } else {
        [self updateMessages];
    }
    
    return YES;
}

@end
