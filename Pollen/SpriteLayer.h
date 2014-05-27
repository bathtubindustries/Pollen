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
@class Spiddderoso;
@class HaikuSpawner;

@class ClipSprite;


#define INITIAL_FLOWER_AMOUNT 6

@interface SpriteLayer : CCLayer {
    //references
    CGSize size;
    GameplayScene *scene;
    TreeLayer *bgLayer;
    
    //members
    PlayerSprite *player_;
    FlowerSpawner *spawner_;
    Spiddderoso *spiddder_;
    HaikuSpawner *haikuSpawner_;
    
    
    CGPoint touchBeganLocation_;
    
    CCLabelTTF *highScoreLabel_;
    CCLabelTTF *heightLabel_;
    float highScore_;
    float playerHeight_;
    
    ClipSprite *pollenBar_;
    CCSprite *pollenBarBackground_;
}
@property float playerHeight;
@property(nonatomic) float topBuffer;

-(void) revivePlayer;

//setters
-(float) getPollenMeter;
-(float) getHeight;

-(void) setScene:(GameplayScene*)s;
-(void) setBackgroundLayer:(TreeLayer*)l;


//update
-(void) update:(ccTime)dt;

@end
