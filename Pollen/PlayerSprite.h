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
    CGPoint velocity_;
}
@property CGPoint velocity;

-(void) update:(ccTime)dt;

@end
