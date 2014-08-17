//
//  SpidderEye.m
//  PollenBug
//
//  Created by Eric Nelson on 6/5/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "SpidderEye.h"

@implementation SpidderEye
-(id)init{
    if (self = [super initWithSpriteFrameName:@"eye1.png"]){
        self.velocity = ccp((rand()%600-300), rand()%5);
        size =[[CCDirector sharedDirector] winSize];
    }
    return self;
}

-(void) update:(ccTime)dt{
    //update the velocity with gravity
    self.velocity = ccp(self.velocity.x,self.velocity.y + (EYE_GRAVITY));
    self.position = ccp(self.position.x + self.velocity.x*dt,
                        self.position.y + self.velocity.y*dt);
    //bound x within screen
    //uses visibility to remove from scene
    if(self.position.x > size.width - [self boundingBox].size.width/2) {
        self.visible=NO;
    } else if(self.position.x < [self boundingBox].size.width/2) {
        self.visible=NO;
    }
    if(self.position.y <= -[self boundingBox].size.height/2) {
        self.visible=NO;
    }


}
@end
