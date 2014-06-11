//
//  Haiku.m
//  PollenBug
//
//  Created by Eric Nelson on 5/24/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "Haiku.h"



@implementation Haiku



-(id) initWithFileAndTitleAndIndex:(NSString *)filenam title:(NSString *)t index: (int) indx{
    if(self = [super initWithFile:filenam]) {
        
        _filename=filenam;
        _title = t;
        self.velocity = CGPointZero;
        
        redTarget=100;
        greenTarget=100;
        blueTarget=100;
    
        index=indx;
    }
    return self;
}


-(void) update:(ccTime)dt {
    if (index!=0)
    {
        self.position = ccp(self.position.x + self.velocity.x*dt,
                        self.position.y + (self.velocity.y*dt)/2);
    }
    else{   //first haiku doesn't move at all
        self.position = ccp(self.position.x + self.velocity.x*dt,
                            self.position.y + (self.velocity.y*dt));
    }
    if (self.bgSprite)
        self.bgSprite.position = self.position;
}


@end
