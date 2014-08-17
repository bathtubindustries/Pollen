//
//  HaikuLayer.m
//  PollenBug
//
//  Created by Eric Nelson on 8/6/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "HaikuLayer.h"
#import "MainMenuLayer.h"
#import "Haiku.h"

@implementation HaikuLayer

-(id) init{
    if(self = [super init]) {
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        float scaleFactor = winSize.height/winSize.width;
        
        CCSprite *img = [CCSprite spriteWithFile:@"treebase0.png"];
        img.anchorPoint = ccp(0, 0);
        img.position = ccp(0, 0);
        [self addChild:img];
        
        CCLabelTTF* backOut = [CCLabelTTF labelWithString:@"In Progress: using player " fontName:@"Chalkduster" fontSize:12*scaleFactor];
        backOut.anchorPoint = ccp(0, 1);
        backOut.position = ccp( 5*scaleFactor, winSize.height/2);
        [self addChild: backOut];
        [backOut setColor:ccc3(255, 224, 51)];
        
        CCLabelTTF* backOut1 = [CCLabelTTF labelWithString:@"submitted haikus in 'real'" fontName:@"Chalkduster" fontSize:12*scaleFactor];
        backOut1.anchorPoint = ccp(0, 1);
        backOut1.position = ccp( 5*scaleFactor, -20*scaleFactor + winSize.height/2);
        [self addChild: backOut1];
        [backOut1 setColor:ccc3(255, 224, 51)];
        
        CCLabelTTF* backOut2 = [CCLabelTTF labelWithString:@" time after approval" fontName:@"Chalkduster" fontSize:12*scaleFactor];
        backOut2.anchorPoint = ccp(0, 1);
        backOut2.position = ccp( 5*scaleFactor, -40*scaleFactor + winSize.height/2);
        [self addChild: backOut2];
        [backOut2 setColor:ccc3(255, 224, 51)];
        
        
    }
    return self;
}
-(void) onEnter {
    [super onEnter];
    [[CCDirector sharedDirector].touchDispatcher
     addTargetedDelegate:self priority:0 swallowsTouches:YES];
}
-(void) onExit {
    [super onExit];
    [[CCDirector sharedDirector].touchDispatcher removeDelegate:self];
}

//INPUT
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    [[CCDirector sharedDirector] replaceScene:
     [CCTransitionFadeDown transitionWithDuration:0.5 scene:[MainMenuLayer scene]]];
    return YES;
}
+(CCScene*) scene{
    CCScene *scene = [CCScene node];
    HaikuLayer *layer = [[[HaikuLayer alloc] init] autorelease];
    [scene addChild:layer];
    return scene;
}

@end
