//
//  PlayerLayer.h
//  jesusgetshigh
//
//  Created by Eric Nelson on 4/12/14.
//  Copyright 2014 bathtubindustries. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "PlayerSprite.h"

@interface PlayerLayer : CCLayer {
    PlayerSprite *player;
    CGSize size;
    
}

@end
