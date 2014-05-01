//
//  SpriteLayer.h
//  Pollen
//
//  Created by Eric Nelson on 5/1/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//
#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "GameView.h"
#import "PlayerSprite.h"

@interface SpriteLayer : CCLayer {
    PlayerSprite* player;
    GameView * gestView;
    CGSize size;
}


+(CCScene*) scene;

@end
