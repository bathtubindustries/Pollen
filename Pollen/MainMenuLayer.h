//
//  MainMenuLayer.h
//  jesusgetshigh
//
//  Created by garv on 4/3/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import <GameKit/GameKit.h>
#import "cocos2d.h"

@interface MainMenuLayer : CCLayerColor <GKLeaderboardViewControllerDelegate>  {

    float volumeLevel;
    CCSprite *spidderEyeCounter_;
    CCLabelTTF *spidderEyeLabel_;
    CCSprite *haikuCounter_;
    CCLabelTTF *haikuLabel_;
}

-(id) initWithScore:(float)prevScore;
-(void) showLeaderboard;
+(CCScene*) scene;
+(CCScene*) sceneWithScore:(float)prevScore;
- (void) leaderboardViewControllerDidFinish: (GKLeaderboardViewController *)viewController;


@end
