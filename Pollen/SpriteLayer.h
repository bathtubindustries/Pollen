//
//  SpriteLayer.h
//  Pollen
//
//  Created by Eric Nelson on 5/1/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "cocos2d.h"

@class GameplayScene;
@class TreeLayer;
@class PlayerSprite;
@class FlowerSpawner;

@interface SpriteLayer : CCLayer {
    //references
    CGSize size;
    GameplayScene *scene;
    TreeLayer *bgLayer;
    
    //members
    PlayerSprite *player_;
    FlowerSpawner *spawner_;
    
    CCLabelTTF *highScoreLabel_;
    CCLabelTTF *heightLabel_;
    float highScore_;
    float playerHeight_;
}
@property float playerHeight;

//setters
-(void) setScene:(GameplayScene*)s;
-(void) setBackgroundLayer:(TreeLayer*)l;

//update
-(void) update:(ccTime)dt;

@end
