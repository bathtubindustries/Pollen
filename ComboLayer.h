//
//  ComboLayer.h
//  PollenBug
//
//  Created by Eric Nelson on 7/17/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "CCLayer.h"
@class GameplayScene;
@class ComboNodeFactory;
@class SpriteLayer;
@class Haiku;

@interface ComboLayer : CCLayer{
    CGSize size;
    float scaleFactor;

    CCLayerColor *buffer;
    ComboNodeFactory *factory;
    int waveCount;
    int activeIndexForWave;
    GameplayScene *scene;
    SpriteLayer* spawnLayer;
    
    NSMutableArray *eyes_;
    NSMutableArray *eyesToRemove_;
    
    //animations
    CCAnimation *eyeAnim;
    CCSpriteBatchNode *eyeSpriteSheet;
    NSMutableArray *eyeAnimFrames;
}

@property (nonatomic, assign) BOOL waveInterrupted;
@property (nonatomic, assign)Haiku * haikuSpawned;
-(void) update:(ccTime)delta;
-(void) setScene:(GameplayScene*)s;
-(GameplayScene*) getScene;
-(void) waveEnded;
-(void) comboEnding;
-(void) setSpawnLayer:(SpriteLayer*)s;

@end
