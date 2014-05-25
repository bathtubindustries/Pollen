//
//  TutorialLayer.h
//  Pollen
//
//  Created by Garv Manocha on 5/7/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "CCLayer.h"
#import "GameplayScene.h"

@interface TutorialLayer : CCLayer {
    //references
    CGSize size;
    GameplayScene *scene;
    //members
    int currentMessage_;
    NSMutableArray *messages_;
}

-(void) setScene:(GameplayScene *) s;

@end
