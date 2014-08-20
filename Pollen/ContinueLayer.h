//
//  ContinueLayer.h
//  PollenBug
//
//  Created by Eric Nelson on 5/24/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "CCLayer.h"
#import "GameOverLayer.h"
#import "GameUtility.h"
#import "GameplayScene.h"
#import "HaikuSpawner.h"

@interface ContinueLayer : CCLayerColor{
    
    CCMenu *continueMenu_;
    CGSize size;
    CCLabelTTF *continueLabel;
    CCLabelTTF *haikuLabel;
    CCLabelTTF *warningLabel;
    GameplayScene* gameScene;
    HaikuSpawner * randSpawner;
    CCSprite *haikuCounter_;
    CCLabelTTF *reviveHaikuText;
    Haiku * toFeature;
    
    BOOL warned;
    int haikuCost;
    NSUInteger haikuNum;
}
@property BOOL paused;
@property float playerScore;

+(CCScene*) scene;

-(void) setScene: (GameplayScene*) s;
-(void) checkForContinue;
-(void) resumeWithContinue;
-(void) update:(ccTime)dt;

@end
