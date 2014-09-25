//
//  ComboNode.m
//  PollenBug
//
//  Created by Eric Nelson on 7/14/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "ComboNode.h"
#import "GameUtility.h"



@implementation ComboNode

-(id) initWithIndex: (int) index
{
    if(self = [super initWithFile:(index%2 ==0 )? @"redNode.png": @"yellowNode.png"])
    {
        CGSize size = [[CCDirector sharedDirector] winSize];
        float scaleFactor = size.height/size.width;
        self.velocity= CGPointMake([GameUtility randInt:-60 :60], TAPNODE_SPEED* [GameUtility randDub:.8 :1.2]);
        self.index = index;
        self.state=Untapped;
        self.visible=YES;
        self.position = CGPointMake([GameUtility randInt: 0:size.width], size.height);
        
        CCLabelTTF * label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",index] fontName:@"Chalkduster" fontSize:22*scaleFactor];
        label.visible=YES;
        label.color = ccc3(0, 0, 0);
        label.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
        [self addChild:label z:self.zOrder+1];
        self.feedbackNode = [CCSprite spriteWithFile:@"feedbackNode.png"];
        [self.feedbackNode setOpacity:0];
        self.feedbackNode.position=CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
        [self addChild:self.feedbackNode];

    }
    
    return self;
}
-(CGRect) boundingBox {
    return CGRectMake(self.position.x - TAPNODE_WIDTH/2, self.position.y - TAPNODE_HEIGHT/2, TAPNODE_WIDTH, TAPNODE_HEIGHT+TAPNODE_HEIGHT/6);
}
-(void) update:(ccTime)dt {
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    self.position = ccp(self.position.x + self.velocity.x*dt,
                        self.position.y + self.velocity.y*dt);
    
    if(self.position.x > size.width - self.contentSize.width/2) {
        self.velocity = ccp(-self.velocity.x, self.velocity.y);
        self.position = ccp(size.width - self.contentSize.width/2,
                            self.position.y);
    } else if(self.position.x < self.contentSize.width/2) {
        self.velocity = ccp(-self.velocity.x, self.velocity.y);
        self.position = ccp(self.contentSize.width/2,
                            self.position.y);
    }


}

@end
