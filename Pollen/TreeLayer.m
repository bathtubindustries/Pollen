//
//  TreeLayer.h
//  jesusgetshigh
//
//  Created by Eric Nelson on 4/12/14.
//  Copyright 2014 bathtubindustries. All rights reserved.
//

#import "TreeLayer.h"

@implementation TreeLayer

-(id)init
{
    if(self=[super init])
    {
        //references
        size = [[CCDirector sharedDirector] winSize];
        
        //background image
		background = [CCSprite spriteWithFile:@"loltree.png"];
        background.position = ccp(size.width/2, size.height/2);
		[self addChild: background z:0];
    }
    return self;
}

@end
