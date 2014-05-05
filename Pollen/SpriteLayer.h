//
//  SpriteLayer.h
//  Pollen
//
//  Created by Eric Nelson on 5/1/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "cocos2d.h"
#import "GameView.h"
#import "PlayerSprite.h"

@interface SpriteLayer : CCLayer {
    //references
    CGSize size;
    
    //members
    PlayerSprite* player;
}

+(float) lowPassFilter:(float)raw;

//update
-(void) update:(ccTime)dt;

@end
