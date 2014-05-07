//
//  MainMenuLayer.h
//  jesusgetshigh
//
//  Created by garv on 4/3/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import <GameKit/GameKit.h>
#import "cocos2d.h"

@interface MainMenuLayer : CCLayerColor {}

-(id) initWithScore:(float)prevScore;

+(CCScene*) scene;
+(CCScene*) sceneWithScore:(float)prevScore;

@end
