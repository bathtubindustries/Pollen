//
//  Haiku.m
//  PollenBug
//
//  Created by Eric Nelson on 5/24/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "Haiku.h"



@implementation Haiku



-(id) initWithFileAndTitle:(NSString *)filenam title:(NSString *)t{
    if(self = [super initWithFile:filenam]) {
        
        _filename=filenam;
        _title = t;
        self.velocity = CGPointZero;
        
        redTarget=100;
        greenTarget=100;
        blueTarget=100;
    
    }
    return self;
}

-(void) update:(ccTime)dt {
    self.position = ccp(self.position.x + self.velocity.x*dt,
                        self.position.y + self.velocity.y*dt);
    
    
}


@end
