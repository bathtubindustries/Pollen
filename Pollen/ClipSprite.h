//
//  ClipSprite.h
//  Pollen
//
//  Created by Garv Manocha on 5/7/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "CCSprite.h"

@interface ClipSprite : CCSprite {
    CGPoint clipPosition_;
    CGPoint clipSize_;
}
@property CGPoint clipPosition;
@property CGPoint clipSize;

-(void) setClip:(CGPoint)pos :(CGPoint)size;

@end
