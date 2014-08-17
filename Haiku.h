//
//  Haiku.h
//  PollenBug
//
//  Created by Eric Nelson on 5/24/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "CCSprite.h"

@interface Haiku : CCSprite

@property (atomic, assign) NSString * firstLine;
@property (atomic, assign) NSString * secondLine;
@property (atomic, assign) NSString * thirdLine;
@property (atomic, assign) NSString * firstInit;
@property (atomic, assign) NSString * secInit;
@property (atomic, assign) BOOL * approved;

@property CGPoint velocity;

- (void) update:(ccTime)dt;
- (id) initWithDictionary:(NSDictionary *) dict;
- (id) initWithHaiku:(Haiku *) copy;
- (id) initHardCoded;
@end



//add haiku bg image to continue screen
//add UI <3 X #haikus to spirtelayr
//spidder drops more eyes at higher altitude