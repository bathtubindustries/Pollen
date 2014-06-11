//
//  ContinueLayer.h
//  PollenBug
//
//  Created by Eric Nelson on 5/24/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "GameOverLayer.h"
#import "GameUtility.h"
#import "GameplayScene.h"

@interface ContinueLayer : CCLayerColor{
    
    CCMenu *continueMenu_;
    CGSize size;
    CCLabelTTF *continueLabel;
    CCLabelTTF *haikuLabel;
    CCLabelTTF *warningLabel;
    GameplayScene* gameScene;
    
    CCSprite *haikuCounter_;
    
    BOOL warned;
    NSUInteger haikuNum;
}
@property BOOL paused;
@property NSInteger playerScore;

+(CCScene*) scene;

-(void) setScene: (GameplayScene*) s;
-(void) checkForContinue;
-(void) resumeWithContinue;
-(void) update:(ccTime)dt;

@end
