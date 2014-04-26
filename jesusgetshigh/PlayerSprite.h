//
//  PlayerSprite.h
//  jesusgetshigh
//
//  Created by Eric Nelson on 4/12/14.
//  Copyright 2014 bathtubindustries. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface PlayerSprite : CCSprite {
    
    float gravity;
    float ySpeed;
    float xSpeed;
    CGSize size;  
    float posx;
    CGPoint m_Direction;
}
-(void) update:(ccTime)dt;
@property CGPoint direction;
@property float speed;
@end
