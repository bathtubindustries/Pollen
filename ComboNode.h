//
//  ComboNode.h
//  PollenBug
//
//  Created by Eric Nelson on 7/14/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "CCNode.h"

#define TAPNODE_SPEED -30.0f
#define TAPNODE_WIDTH 125.0f
#define TAPNODE_HEIGHT 125.0f
enum NodeState {
    Untapped = 0,
    Success,
    Trap
};

@interface ComboNode : CCSprite
@property (nonatomic, assign) enum NodeState state;
@property CGPoint velocity;
@property CGPoint position;
@property (nonatomic, assign) int index;
@property (nonatomic, assign) CCSprite* feedbackNode;
-(id) initWithIndex: (int) index;
-(void) update:(ccTime)dt;
-(CGRect) boundingBox;
@end
