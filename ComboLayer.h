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

@interface ComboLayer : CCLayer{

    CCLayerColor *buffer;
    ComboNodeFactory *factory;
    int waveCount;
    int activeIndexForWave;
    GameplayScene *scene;
    SpriteLayer* spawnLayer;
}

@property (nonatomic, assign) BOOL waveInterrupted;

-(void) update:(ccTime)delta;
-(void) setScene:(GameplayScene*)s;
-(GameplayScene*) getScene;
-(void) waveEnded;
-(void) comboEnding;
-(void) setSpawnLayer:(SpriteLayer*)s;

@end
