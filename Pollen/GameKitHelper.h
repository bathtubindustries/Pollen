//
//  GameKitHelper.h
//  PollenBug
//
//  Created by Eric Nelson on 5/19/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//
//   Include the GameKit framework
#import <GameKit/GameKit.h>
#import "cocos2d.h"
//   Protocol to notify external
//   objects when Game Center events occur or
//   when Game Center async tasks are completed
@protocol GameKitHelperProtocol<NSObject>
-(void) onScoresSubmitted:(bool)success;

-(void) onScoresOfFriendsToChallengeListReceived:
(NSArray*) scores;
-(void) onPlayerInfoReceived:
(NSArray*)players;
@end

@interface GameKitHelper : NSObject

@property (nonatomic, assign)
id<GameKitHelperProtocol> delegate;

@property (nonatomic, readwrite)
BOOL includeLocalPlayerScore;

@property (nonatomic, readwrite) BOOL isAuthenticated;

// This property holds the last known error
// that occured while using the Game Center API's
@property (nonatomic, readonly) NSError* lastError;

+ (id) sharedGameKitHelper;

// Player authentication, info
-(void) authenticateLocalPlayer;
-(void) submitScore:(int64_t)score
           category:(NSString*)category;

//For in-Game Challenges

-(void) findScoresOfFriendsToChallenge;

-(void) getPlayerInfo:(NSArray*)playerList;

-(void) sendScoreChallengeToPlayers:
(NSArray*)players
                          withScore:(int64_t)score
                            message:(NSString*)message;

+(void)showFriendsPickerViewControllerForScore:(int64_t)score;

-(BOOL) localPlayerIsAuthenticated;

@end
