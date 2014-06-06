//
//  SpidderEye.h
//  PollenBug
//
//  Created by Eric Nelson on 6/5/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "CCSprite.h"
#define EYE_GRAVITY -15.f

@interface SpidderEye : CCSprite{
    CGSize size;
}
@property CGPoint velocity;
-(void) update:(ccTime)dt;
@end
