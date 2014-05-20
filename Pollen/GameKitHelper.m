//
//  GameKitHelper.m
//  PollenBug
//
//  Created by Eric Nelson on 5/19/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "GameKitHelper.h"
#import "FriendsPickerViewController.h"

@interface GameKitHelper ()
<GKGameCenterControllerDelegate> {
    BOOL _gameCenterFeaturesEnabled;
}
@end

@implementation GameKitHelper

#pragma mark Singleton stuff

+(id) sharedGameKitHelper {
    static GameKitHelper *sharedGameKitHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGameKitHelper =
        [[GameKitHelper alloc] init];
    });
    return sharedGameKitHelper;
}



-(BOOL) localPlayerIsAuthenticated{
    return _gameCenterFeaturesEnabled;
}


+(void)
showFriendsPickerViewControllerForScore:
(int64_t)score {
    
    
    
    FriendsPickerViewController
    *friendsPickerViewController =
    [[FriendsPickerViewController alloc]
     initWithScore:score];
    
    
    
    friendsPickerViewController.
    cancelButtonPressedBlock = ^() {
        [[CCDirector sharedDirector] dismissModalViewControllerAnimated:YES];
    };
    
    friendsPickerViewController.
    challengeButtonPressedBlock = ^() {
        [[CCDirector sharedDirector] dismissModalViewControllerAnimated:YES];
    };
    
    
    
    UINavigationController *navigationController =
    [[UINavigationController alloc]
     initWithRootViewController:
     friendsPickerViewController];
    
    [[CCDirector sharedDirector] presentViewController:navigationController animated:YES completion:^{
    
    }];
}

#pragma mark Player Authentication

-(void) authenticateLocalPlayer {
    
    GKLocalPlayer* localPlayer =
    [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler =
    ^(UIViewController *viewController,
      NSError *error) {
        
        [self setLastError:error];
        
        if ([CCDirector sharedDirector].isPaused)
            [[CCDirector sharedDirector] resume];
        
        if (localPlayer.authenticated) {
            _gameCenterFeaturesEnabled = YES;
        } else if(viewController) {
            [[CCDirector sharedDirector] pause];
            [self presentViewController:viewController];
        } else {
            _gameCenterFeaturesEnabled = NO;
        }
    };
}



-(void) setLastError:(NSError*)error {
    _lastError = [error copy];
    if (_lastError) {
        NSLog(@"GameKitHelper ERROR: %@", [[_lastError userInfo]
                                           description]);
    }
}


-(void) submitScore:(int64_t)score
           category:(NSString*)category {
    //1: Check if Game Center
    //   features are enabled
    if (!_gameCenterFeaturesEnabled) {
        CCLOG(@"Player not authenticated");
        return;
    }
    
    //2: Create a GKScore object
    GKScore* gkScore =
    [[GKScore alloc]
     initWithCategory:category];
    
    //3: Set the score value
    gkScore.value = score;
    
    //4: Send the score to Game Center
    [gkScore reportScoreWithCompletionHandler:
     ^(NSError* error) {
         
         [self setLastError:error];
         
         BOOL success = (error == nil);
         
         if ([_delegate
              respondsToSelector:
              @selector(onScoresSubmitted:)]) {
             
             [_delegate onScoresSubmitted:success];
         }
     }];
}


-(void) findScoresOfFriendsToChallenge {
    //1
    GKLeaderboard *leaderboard =
    [[GKLeaderboard alloc] init];
    
    //2
    leaderboard.category =
    @"PollenBug_Leaderboard";
    
    //3
    leaderboard.playerScope =
    GKLeaderboardPlayerScopeFriendsOnly;
    
    //4
    leaderboard.range = NSMakeRange(1, 100);
    
    //5
    [leaderboard
     loadScoresWithCompletionHandler:
     ^(NSArray *scores, NSError *error) {
         
         [self setLastError:error];
         
         BOOL success = (error == nil);
         
         if (success) {
             NSLog(@"found scores of friends");
             if (!_includeLocalPlayerScore) {
                 NSMutableArray *friendsScores =
                 [NSMutableArray array];
                 
                 for (GKScore *score in scores) {
                     if (![score.playerID
                           isEqualToString:
                           [GKLocalPlayer localPlayer]
                           .playerID]) {
                         [friendsScores addObject:score];
                     }
                 }
                 scores = friendsScores;
             }
             if ([_delegate
                  respondsToSelector:
                  @selector
                  (onScoresOfFriendsToChallengeListReceived:)]) {
                 
                 [_delegate
                  onScoresOfFriendsToChallengeListReceived:scores];
             }
         }
     }];
}


-(void) getPlayerInfo:(NSArray*)playerList {
    //1
    if (_gameCenterFeaturesEnabled == NO)
        return;
    
    //2
    if ([playerList count] > 0) {
        [GKPlayer
         loadPlayersForIdentifiers:
         playerList
         withCompletionHandler:
         ^(NSArray* players, NSError* error) {
             
             [self setLastError:error];
             
             if ([_delegate
                  respondsToSelector:
                  @selector(onPlayerInfoReceived:)]) {
                 
                 [_delegate onPlayerInfoReceived:players];
             }
         }];
    }
}


#pragma mark UIViewController stuff

-(UIViewController*) getRootViewController {
    return [UIApplication
            sharedApplication].keyWindow.rootViewController;
}

-(void)presentViewController:(UIViewController*)vc {
    UIViewController* rootVC = [self getRootViewController];
    [rootVC presentViewController:vc animated:YES
                       completion:nil];
}



-(void) sendScoreChallengeToPlayers:
(NSArray*)players
                          withScore:(int64_t)score
                            message:(NSString*)message {
    
    //1
    GKScore *gkScore =
    [[GKScore alloc]
     initWithCategory:
     @"PollenBug_Leaderboard"];
    gkScore.value = score;
    
    //2
    [gkScore issueChallengeToPlayers:
     players message:message];
}


@end