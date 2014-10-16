//
//  GameOverLayer.m
//  PollenBug
//
//  Created by Eric Nelson on 5/19/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "GameOverLayer.h"
#import "GameplayScene.h"
#import "MainMenuLayer.h"
#import "FriendsPickerViewController.h"
#import "HaikuGalleryLayer.h"
#import "GameUtility.h"

@implementation GameOverLayer

-(id) initWithScore:(float)score {
    return [self initWithScore:score toTutorial:NO];
}
-(id) initWithScore:(float)score toTutorial:(BOOL)tut {
    if(self = [super init]) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        CGPoint scaleFactor = ccp (winSize.width/(320),winSize.height/(480));
        
        _playerScore=score;
        
        CCSprite *img = [CCSprite spriteWithFile:@"treebase0.png"];
        img.anchorPoint = ccp(0, 0);
        img.position = ccp(0, 0);
        img.scaleY = winSize.height/(960.f/2.f);
        [self addChild:img];
        
        //bottom menu
        CCMenuItemImage *itemRetry = [CCMenuItemImage itemWithNormalImage:@"menuBoxRight.png"
                                                            selectedImage:@"menuBoxRight.png"
                                                            disabledImage:nil block:^(id sender){
                                                                if(tut) [GameUtility isTutorialNeeded:YES];
                                                                [[CCDirector sharedDirector] replaceScene:
                                                                 [CCTransitionFadeUp transitionWithDuration:0.5 scene:[GameplayScene node]]];
                                                            }];
        itemRetry.scaleY=1.0;
        itemRetry.scaleX=1.15;
        CCLabelTTF *retryText = [CCLabelTTF labelWithString:@"retry" fontName:@"GunnyRewritten" fontSize:36*scaleFactor.x];
        [retryText setColor:ccc3(255, 224, 51)];
        [itemRetry addChild:retryText];
        retryText.scaleY=(1/itemRetry.scaleY);
        
        
        CCMenuItemImage *mainMenuItem = [CCMenuItemImage itemWithNormalImage:@"menuBoxLeft.png" selectedImage:@"menuBoxLeft.png" disabledImage:nil block:^(id sender){
            [[CCDirector sharedDirector] replaceScene:
             [CCTransitionFadeDown transitionWithDuration:0.5 scene:[MainMenuLayer sceneWithScore:_playerScore]]];
            
        }];
        mainMenuItem.scaleY=1.0;
        mainMenuItem.scaleX=1.15;
        CCLabelTTF *mainMenuText = [CCLabelTTF labelWithString:@"menu" fontName:@"GunnyRewritten" fontSize:36*scaleFactor.x];
        [mainMenuText setColor:ccc3(255, 224, 51)];
        [mainMenuItem addChild:mainMenuText];
        mainMenuText.scaleY=(1/mainMenuItem.scaleY);
        
        
        [CCMenuItemFont setFontSize:(27*scaleFactor.x)];
        
        CCMenu *endMenu = [CCMenu menuWithItems:mainMenuItem,itemRetry, nil];
        
        [endMenu alignItemsHorizontallyWithPadding: 1*scaleFactor.x];
        [endMenu setPosition: ccp(winSize.width/2, (winSize.height*.19) -10*scaleFactor.y)];
        
        retryText.position=ccp(itemRetry.position.x-8*scaleFactor.x, itemRetry.position.y+(itemRetry.contentSize.height/2));
        mainMenuText.position=ccp(mainMenuItem.position.x+mainMenuItem.contentSize.width+5*scaleFactor.x, mainMenuItem.position.y +mainMenuItem.contentSize.height/2);
        
        
        
        //top menu
        
        
        CCMenuItemImage *itemLeaderBoard = [CCMenuItemImage itemWithNormalImage:@"UIBox.png" selectedImage:@"UIBox.png" disabledImage:nil block:^(id sender){
            [self showLeaderboard];
        }];
        itemLeaderBoard.scaleY=.4;
        itemLeaderBoard.scaleX=.95;
        
        CCSprite *leaderIcon = [CCSprite spriteWithFile:@"leaderIcon.png"];
        leaderIcon.scaleY = 1/(itemLeaderBoard.scaleY);
        leaderIcon.scaleX = 1/(itemLeaderBoard.scaleX);
        leaderIcon.position=ccp(itemLeaderBoard.position.x -20*scaleFactor.x, leaderIcon.position.y+36*scaleFactor.y);
        [itemLeaderBoard addChild:leaderIcon];
        
        CCLabelTTF *leaderText = [CCLabelTTF labelWithString:@"check the leaderboard" fontName:@"GunnyRewritten" fontSize:30*scaleFactor.x];
        [leaderText setColor:ccc3(255, 224, 51)];
        [itemLeaderBoard addChild:leaderText];
        leaderText.scaleX = (1/(itemLeaderBoard.scaleX));
        leaderText.scaleY = 1/(itemLeaderBoard.scaleY);

        
        CCMenuItemImage *itemChallenge = [CCMenuItemImage itemWithNormalImage:@"UIBox.png" selectedImage:@"UIBox.png" disabledImage:nil block:^(id sender){
            if ([[GameKitHelper sharedGameKitHelper] localPlayerIsAuthenticated]){
                [GameKitHelper showFriendsPickerViewControllerForScore:
                 score];
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not Logged In"
                                                                message:@"This features requires Game Center authentification."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            
        }];
        itemChallenge.scaleY=.4;
        itemChallenge.scaleX=.95;
        
        CCSprite *challIcon = [CCSprite spriteWithFile:@"challengeIcon.png"];
        challIcon.scaleY = 1/(itemChallenge.scaleY);
        challIcon.scaleX = 1/(itemChallenge.scaleX);
        challIcon.position=ccp(itemChallenge.position.x -20*scaleFactor.x, challIcon.position.y+36*scaleFactor.y);
        [itemChallenge addChild:challIcon];
        
        CCLabelTTF *challText = [CCLabelTTF labelWithString:@"send out a challenge" fontName:@"GunnyRewritten" fontSize: 30*scaleFactor.x];
        [challText setColor:ccc3(255, 224, 51)];
        [itemChallenge addChild:challText];
        challText.scaleY = 1/(itemChallenge.scaleY);
        challText.scaleX = 1/(itemChallenge.scaleX);
        
        CCMenuItemImage *itemHaiku = [CCMenuItemImage itemWithNormalImage:@"UIBox.png" selectedImage:@"UIBox.png" disabledImage:nil block:^(id sender){
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[HaikuGalleryLayer scene] ]];
        }];
        itemHaiku.scaleY=.4;
        itemHaiku.scaleX=.95;
        
        CCSprite *haikuIcon = [CCSprite spriteWithFile:@"heartIcon.png"];
        haikuIcon.scaleY = 1/(itemHaiku.scaleY);
        haikuIcon.scaleX = 1/(itemHaiku.scaleX);
        haikuIcon.position=ccp(itemHaiku.position.x -20*scaleFactor.x, haikuIcon.position.y+36*scaleFactor.y);
        [itemHaiku addChild:haikuIcon];
        
        CCLabelTTF *haikuText = [CCLabelTTF labelWithString:@"community haiku" fontName:@"GunnyRewritten" fontSize: 30 * scaleFactor.x ];
        [haikuText setColor:ccc3(255, 224, 51)];
        [itemHaiku addChild:haikuText];
        haikuText.scaleY = 1/(itemHaiku.scaleY);
        haikuText.scaleX = 1/(itemHaiku.scaleX);
        
        CCMenu* topMenu = [CCMenu menuWithItems:itemLeaderBoard,itemChallenge, itemHaiku, nil];
        
        [topMenu alignItemsVerticallyWithPadding: 3.0];
        [topMenu setPosition: ccp(10*scaleFactor.x + winSize.width/2, winSize.height*.80)];
        
        haikuText.position = ccp(haikuIcon.position.x+50*scaleFactor.x+haikuText.boundingBox.size.width/1.7,haikuIcon.position.y+4);
        challText.position = ccp(haikuIcon.position.x+25*scaleFactor.x+challText.boundingBox.size.width/1.7,haikuIcon.position.y+4);
        leaderText.position=ccp (leaderIcon.position.x+10*scaleFactor.x+leaderText.boundingBox.size.width/1.7, leaderIcon.position.y+4);
        
        
        
        CCSprite * scoreBg = [CCSprite spriteWithFile:@"pauseBox.png"];
        scoreBg.scaleX=1.5*scaleFactor.x;
        scoreBg.scaleY=1.3*scaleFactor.y;
        scoreBg.position= ccp(endMenu.position.x, endMenu.position.y+140*scaleFactor.y);
        
        CCSprite * divider = [CCSprite spriteWithFile:@"scoreDivider.png"];
        divider.scale=1.0;
        divider.position = ccp(scoreBg.position.x-(scoreBg.contentSize.width/1.7)*scaleFactor.x +9*scaleFactor.x, scoreBg.position.y-scoreBg.contentSize.height*1.12*scaleFactor.y);
        divider.rotation=10;
        [scoreBg addChild:divider];
        
        
        
        CCLabelTTF *climbText = [CCLabelTTF labelWithString:@"you " fontName:@"GunnyRewritten" fontSize:36*scaleFactor.x];
        [climbText setColor:ccc3(255, 204, 51)];
        [scoreBg addChild:climbText];
        climbText.scaleY=(1/scoreBg.scaleY);
        climbText.scaleX=(1/scoreBg.scaleX);
        climbText.position= ccp(scoreBg.position.x-climbText.contentSize.width*1.2*scaleFactor.x,scoreBg.position.y- scaleFactor.y* scoreBg.contentSize.height/1.4);
        
        CCLabelTTF *climbText2 = [CCLabelTTF labelWithString:@"climbed:" fontName:@"GunnyRewritten" fontSize: 36*scaleFactor.x];
        [climbText2 setColor:ccc3(255, 204, 51)];
        [scoreBg addChild:climbText2];
        climbText2.scaleY=(1/scoreBg.scaleY);
        climbText2.scaleX=(1/scoreBg.scaleX);
        climbText2.position= ccp(climbText.position.x + 10*scaleFactor.x ,climbText.position.y -15*scaleFactor.y);

        CCLabelTTF *scoreText = [CCLabelTTF labelWithString:[NSString stringWithFormat: @"%d m",(int)score ] fontName:@"Futura" fontSize:(self.playerScore <1000)? 27*scaleFactor.x :21*scaleFactor.x];
        [scoreText setColor:ccc3(255, 204, 51)];
        [scoreBg addChild:scoreText];
        scoreText.scaleY=(1/scoreBg.scaleY);
        scoreText.scaleX=(1/scoreBg.scaleX);
        scoreText.position= ccp(climbText2.position.x,climbText2.position.y-20*scaleFactor.y);
        
        
        CCLabelTTF *bestText = [CCLabelTTF labelWithString:@"your" fontName:@"GunnyRewritten" fontSize:36*scaleFactor.x];
        [bestText setColor:ccc3(255, 204, 51)];
        [scoreBg addChild:bestText];
        bestText.scaleY=(1/scoreBg.scaleY);
        bestText.scaleX=(1/scoreBg.scaleX);
        bestText.position= ccp(scoreBg.position.x-bestText.contentSize.width*2.5*scaleFactor.x-10*scaleFactor.x,scoreBg.position.y-scoreBg.contentSize.height*scaleFactor.y-12*scaleFactor.y);
        
        CCLabelTTF *bestText2 = [CCLabelTTF labelWithString:@"best:" fontName:@"GunnyRewritten" fontSize:36*scaleFactor.x];
        [bestText2 setColor:ccc3(255, 204, 51)];
        [scoreBg addChild:bestText2];
        bestText2.scaleY=(1/scoreBg.scaleY);
        bestText2.scaleX=(1/scoreBg.scaleX);
        bestText2.position= ccp(bestText.position.x + 14*scaleFactor.x ,bestText.position.y -15*scaleFactor.y);
        
        CCLabelTTF *bestScoreText = [CCLabelTTF labelWithString:[NSString stringWithFormat: @"%d m",(int)[GameUtility savedHighScore] ] fontName:@"Futura" fontSize:21*scaleFactor.x];
        [bestScoreText setColor:ccc3(255, 204, 51)];
        [scoreBg addChild:bestScoreText];
        bestScoreText.scaleY=(1/scoreBg.scaleY);
        bestScoreText.scaleX=(1/scoreBg.scaleX);
        bestScoreText.position= ccp(bestText2.position.x,bestText2.position.y-15*scaleFactor.y);
        
        [self addChild:scoreBg];
        [self addChild:endMenu];
        [self addChild:topMenu];
        
        
    }
    return self;
}

+(CCScene*) scene {
    CCScene *scene = [CCScene node];
    GameOverLayer *layer = [GameOverLayer node];
    [scene addChild:layer];
    return scene;
}

- (void) showLeaderboard{
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
    if (leaderboardController != NULL)
    {
        leaderboardController.timeScope = GKLeaderboardTimeScopeAllTime;
        leaderboardController.leaderboardDelegate = self;
        [[CCDirector sharedDirector] presentViewController:leaderboardController animated:YES completion:^(void){}];
    }
    
}
- (void) leaderboardViewControllerDidFinish: (GKLeaderboardViewController *)viewController{
    
    
    [[CCDirector sharedDirector] dismissModalViewControllerAnimated: YES];
    
}


-(void) onEnter {
    [super onEnter];
    [[CCDirector sharedDirector].touchDispatcher
     addTargetedDelegate:self priority:0 swallowsTouches:YES];
}
-(void) onExit {
    [super onExit];
    [[CCDirector sharedDirector].touchDispatcher removeDelegate:self];
}

//INPUT
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {

    return YES;
}

//UTILITY
+(CCScene*) sceneWithScore:(float)prevScore {
    return [GameOverLayer sceneWithScore:prevScore toTutorial:NO];
}
+(CCScene*) sceneWithScore:(float)prevScore toTutorial:(BOOL)tut {
    CCScene *scene = [CCScene node];
    
    GameOverLayer *layer;
    if(tut) layer = [[[GameOverLayer alloc] initWithScore:prevScore toTutorial:YES] autorelease];
    else    layer = [[[GameOverLayer alloc] initWithScore:prevScore] autorelease];
    
    [scene addChild:layer];
    return scene;
}

@end
