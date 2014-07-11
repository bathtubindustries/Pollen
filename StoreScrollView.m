//
//  StoreScrollView.m
//  PollenBug
//
//  Created by Eric Nelson on 7/10/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "StoreScrollView.h"

@implementation StoreScrollView

- (BOOL)hitTestWithWorldPos:(CGPoint)pos
{
    pos = [self convertToNodeSpace:pos];
    
    if ((pos.y < 0) || (pos.y > self.contentSize.height))
    {
        return(NO);
    }
    return(YES);
}

@end
