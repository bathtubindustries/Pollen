//
//  PlayerSprite.h
//  jesusgetshigh
//
//  Created by Eric Nelson on 4/12/14.
//  Copyright 2014 bathtubindustries. All rights reserved.
//

#import "cocos2d.h"

@interface PlayerSprite : CCSprite {
    //references
    CGSize size;
    
    //members
    enum PlayerState {
        Idle = 0,
        Jumping
    };
    enum PlayerState state_;
    
    CGPoint velocity_;
}
@property CGPoint velocity;

//messages
-(void) startJump;

//update
-(void) update:(ccTime)dt;

@end
