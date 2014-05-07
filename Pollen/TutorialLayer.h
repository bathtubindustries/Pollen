//
//  TutorialLayer.h
//  Pollen
//
//  Created by Garv Manocha on 5/7/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "CCLayer.h"

@interface TutorialLayer : CCLayer {
    //references
    CGSize size;
    
    //members
    int currentMessage_;
    NSMutableArray *messages_;
}

@end
