//
//  GameUtility.h
//  Pollen
//
//  Created by Garv Manocha on 5/6/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "CCNode.h"


;

@class CCSprite;

@interface GameUtility : CCNode {}
@property(nonatomic, readonly, assign) NSUInteger savedHighScore;
@property(nonatomic, readonly, assign) NSUInteger haikuCount;
@property(nonatomic, assign) NSMutableArray* isItemPurchased;   //lookup by product number
@property(nonatomic, assign) NSUInteger itemEquipped; //also by product number

//saving
+(NSUInteger) savedHighScore;
+(void) saveHighScore:(NSUInteger)val;

+(void) saveHaikuCount:(NSUInteger) val;
+(NSUInteger) savedHaikuCount;

+(void) saveSpidderEyeCount:(NSUInteger) val;
+(NSUInteger) savedSpidderEyeCount;

+(void) HaikuDiscovered: (NSString*) t discoverable: (BOOL) b;
+(BOOL) isHaikuDiscovered: (NSString*) title;

+(void) itemPurchased: (NSString*) t purchased: (BOOL) b;
+(BOOL) isItemPurchased: (NSString*) title;

+(void) equipItem:(NSUInteger) val;
+(NSUInteger) equippedItem;

+(void) isTutorialNeeded: (BOOL) needed;
+(BOOL) needsTutorial;

+(void) countFirebaseHaikus;
+(int) firebaseHaikuCount;
+(int) approvedFirebaseHaikuCount;

//utility
+(int) randInt:(int)low :(int)high;
+(double) randDub:(double)low :(double)high;
+(void) loadTexture:(NSString*)fn Into:(CCSprite*)s;
+(BOOL) isCollidingRect:(CCSprite*)s1 WithRect:(CCSprite*)s2;

@end