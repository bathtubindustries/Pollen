//
//  LineLayer.m
//  Pollen
//
//  Created by Garv Manocha on 5/7/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "LineLayer.h"

#import "cocos2d.h"

#import "PlayerSprite.h"
#import "SpriteLayer.h"

@implementation LineLayer

-(id) init {
    if(self = [super init]) {
        size = [[CCDirector sharedDirector] winSize];
    }
    return self;
}

-(void) setSpriteLayer:(SpriteLayer*)l {
    spriteLayer = l;
}

//DRAW
-(void) draw {
    [super draw];

    if(spriteLayer) {
        //draw pollen meter lines
        glLineWidth(50.f);
        for(int i = 0; i < (PLAYER_MAX_POLLEN/PLAYER_SWIPE_AMOUNT)-1; i++) {
            int tabWidth;
            if([spriteLayer getPollenMeter] >= (i+1)*PLAYER_SWIPE_AMOUNT) {
                ccDrawColor4B(255, 255, 255, 255);
                tabWidth = 20;
            } else {
                ccDrawColor4B(0, 0, 0, 255);
                tabWidth = 10;
            }
            
            CGPoint rectOrigin = ccp((i+1)*(PLAYER_SWIPE_AMOUNT/PLAYER_MAX_POLLEN)*size.width - tabWidth/2.f, size.height);
            CGPoint rectSize = ccp(tabWidth + rectOrigin.x, [spriteLayer getHeight] - size.height + rectOrigin.y);
            ccDrawRect(rectOrigin, rectSize);
        }
    }
}

@end
