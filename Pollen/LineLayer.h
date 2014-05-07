//
//  LineLayer.h
//  Pollen
//
//  Created by Garv Manocha on 5/7/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "CCLayer.h"

@class SpriteLayer;

@interface LineLayer : CCLayer {
    CGSize size;
    SpriteLayer *spriteLayer;
}

-(void) setSpriteLayer:(SpriteLayer*)l;

@end
