//
//  PauseLayer.m
//  Pollen
//
//  Created by Garv Manocha on 5/5/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "PauseLayer.h"

#import "GameplayScene.h"
#import "MainMenuLayer.h"

#define PAUSED_OPACITY 100

@implementation PauseLayer

@synthesize paused = paused_;
@synthesize pausedWithMenu = pausedWithMenu_;

-(id) init {
    if(self = [super initWithColor:ccc4(0, 0, 0, 0)]) {
        size = [[CCDirector sharedDirector] winSize];
        paused_ = NO;
        pausedWithMenu_ = NO;
        alreadyPaused_ = NO;
        
        //pause button & textures
        float scaleFactor = 1.0;
        pauseButtonTexture_ = [[CCTextureCache sharedTextureCache] textureForKey:@"pauseButton.png"];
        if(!pauseButtonTexture_) [[CCTextureCache sharedTextureCache] addImage:@"pauseButton.png"];
        
        resumeButtonTexture_ = [[CCTextureCache sharedTextureCache] textureForKey:@"resumeButton.png"];
        if(!resumeButtonTexture_) [[CCTextureCache sharedTextureCache] addImage:@"resumeButton.png"];
        
        if(pauseButtonTexture_) {
            pauseButton_ = [CCSprite spriteWithTexture:pauseButtonTexture_];
        } else {
            pauseButton_ = [CCSprite spriteWithFile:@"pauseButton.png"];
        }
        
        pauseButton_.scale = scaleFactor;
        pauseButton_.position = ccp(size.width - (pauseButton_.contentSize.width*scaleFactor)/2,
                                    size.height - (pauseButton_.contentSize.height*scaleFactor)/2);
        [self addChild:pauseButton_];
        
        //menu items and setup
        scaleFactor = size.height/size.width;
        [CCMenuItemFont setFontName:@"Futura"];
        [CCMenuItemFont setFontSize:(24*scaleFactor)];
        
        CCMenuItem *itemResume = [CCMenuItemFont itemWithString:@"resume" block:^(id sender) {
            [self togglePauseMenu];
        }];
        CCMenuItem *itemMainMenu = [CCMenuItemFont itemWithString:@"main menu" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[MainMenuLayer scene]]];
        }];
        pauseMenu_ = [CCMenu menuWithItems:itemResume, itemMainMenu, nil];
        
        [pauseMenu_ alignItemsVerticallyWithPadding: 10*scaleFactor];
        [pauseMenu_ setPosition: ccp(size.width/2, size.height/2)];
        
        [pauseMenu_ setEnabled:NO];
        [pauseMenu_ setVisible:NO];
        [self addChild:pauseMenu_];
    }
    return self;
}
-(void) onEnter {
    [super onEnter];
    [self registerWithTouchDispatcher];
}
-(void) onExit {
    [super onExit];
    [[CCDirector sharedDirector].touchDispatcher removeDelegate:self];
}

//TOUCHES
-(void) registerWithTouchDispatcher {
    [[CCDirector sharedDirector].touchDispatcher
        addTargetedDelegate:self priority:0 swallowsTouches:NO];
}

-(BOOL) ccTouchBegan:(UITouch*)touch withEvent:(UIEvent*)event {
    CGPoint location = [self convertTouchToNodeSpace:touch];
    if([self isPointInPauseButton:location]) {
        [self togglePauseMenu];
    }
    
    return YES;
}

//STATE SETTER
-(void) pause {
    if(!paused_ && !pauseMenu_.visible)
        paused_ = YES;
}
-(void) resume {
    if(paused_ && !pauseMenu_.visible) {
        paused_ = NO;
        alreadyPaused_ = NO;
    }
}

-(void) pauseWithMenu {
    if(!paused_)
        paused_ = YES;
    else
        alreadyPaused_ = YES;
    
    [self setOpacity:PAUSED_OPACITY];
    
    if([[CCTextureCache sharedTextureCache] addImage:@"resumeButton.png"]) {
        resumeButtonTexture_ = [[CCTextureCache sharedTextureCache] textureForKey:@"resumeButton.png"];
        [pauseButton_ setTexture:resumeButtonTexture_];
    }
    
    pausedWithMenu_ = YES;
    [pauseMenu_ setVisible:YES];
    [pauseMenu_ setEnabled:YES];
}
-(void) resumeWithMenu {
    if(paused_ && !alreadyPaused_)
        paused_ = NO;
    
    [self setOpacity:0];
    
    if([[CCTextureCache sharedTextureCache] addImage:@"pauseButton.png"]) {
        pauseButtonTexture_ = [[CCTextureCache sharedTextureCache] textureForKey:@"pauseButton.png"];
        [pauseButton_ setTexture:pauseButtonTexture_];
    }
    
    pausedWithMenu_ = NO;
    [pauseMenu_ setVisible:NO];
    [pauseMenu_ setEnabled:NO];
}

-(void) togglePauseMenu {
    if(!pauseMenu_.visible)
        [self pauseWithMenu];
    else if(pauseMenu_.visible)
        [self resumeWithMenu];
}

//UTILITY
-(BOOL) isPointInPauseButton:(CGPoint)cp {
    if((cp.x >= pauseButton_.position.x-(pauseButton_.contentSize.width*pauseButton_.scale/2) &&
        cp.x <= pauseButton_.position.x+(pauseButton_.contentSize.width*pauseButton_.scale/2)) && //if in x bounds
       (cp.y <= pauseButton_.position.y+(pauseButton_.contentSize.height*pauseButton_.scale/2) &&
        cp.y >= pauseButton_.position.y-(pauseButton_.contentSize.height*pauseButton_.scale/2))){ //if in y bounds
           return YES;
       } else return NO;
}

@end
