//
//  StoreScene.h
//  PollenBug
//
//  Created by Eric Nelson on 7/11/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "CCScene.h"

@class StoreLayer;

@interface StoreScene : CCScene{
    StoreLayer *storeLayer_;
}

-(void) update:(ccTime)delta;

@end
