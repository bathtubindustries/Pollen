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
    int index;
}

@property (atomic, readwrite, copy) NSString * title;
@property (atomic, readwrite, copy) NSString * filename;
@property (nonatomic, assign) CCSprite * bgSprite;
@property CGPoint velocity;

- (void) update:(ccTime)dt;
- (id) initWithFileAndTitleAndIndex: (NSString*) filenam title: (NSString *) t index: (int) inx;
@end



//add haiku bg image to continue screen
//add UI <3 X #haikus to spirtelayr
//spidder drops more eyes at higher altitude