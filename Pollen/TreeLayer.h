//
//  TreeLayer.h
//  jesusgetshigh
//
//  Created by Eric Nelson on 4/12/14.
//  Copyright 2014 bathtubindustries. All rights reserved.
//

#import "cocos2d.h"

@interface TreeLayer : CCLayer {
    //references
    CGSize size;

    //members
    CCSprite *bgGround;
    CCSprite *bgSky1;
    CCSprite *bgSky2;
}

//setter
-(void) scroll:(float)vel;

@end
