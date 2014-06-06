//
//  Haiku.h
//  PollenBug
//
//  Created by Eric Nelson on 5/24/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "CCSprite.h"

@interface Haiku : CCSprite{
    int redTarget;
    int blueTarget;
    int greenTarget;
}

@property (atomic, readwrite, copy) NSString * title;
@property (atomic, readwrite, copy) NSString * filename;

@property CGPoint velocity;

- (void) update:(ccTime)dt;
- (id) initWithFileAndTitle: (NSString*) filenam title: (NSString *) t;

@end
