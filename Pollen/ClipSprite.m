//
//  ClipSprite.m
//  Pollen
//
//  Created by Garv Manocha on 5/7/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "ClipSprite.h"

#import "cocos2d.h"

@implementation ClipSprite

@synthesize clipPosition = clipPosition_;
@synthesize clipSize = clipSize_;

-(void) setClip:(CGPoint)pos :(CGPoint)size {
    clipPosition_ = pos;
    clipSize_ = size;
}

-(void) visit {
    if(!self.visible)
        return;
    
    glEnable(GL_SCISSOR_TEST);
    
    //CGSize size = [[CCDirector sharedDirector] winSize];
    CGPoint worldPosition = [self convertToWorldSpace:CGPointZero];
    CGFloat scaleFactor = [[CCDirector sharedDirector] contentScaleFactor];
    glScissor((clipPosition_.x + worldPosition.x)*scaleFactor,
              (clipPosition_.y + worldPosition.y)*scaleFactor,
              clipSize_.x*scaleFactor, clipSize_.y*scaleFactor);
    
    [super visit];
    glDisable(GL_SCISSOR_TEST);
}


@end