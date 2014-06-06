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

//saving
+(NSUInteger) savedHighScore;
+(void) saveHighScore:(NSUInteger)val;

+(void) saveHaikuCount:(NSUInteger) val;
+(NSUInteger) savedHaikuCount;
+(void) HaikuDiscovered: (NSString*) t discoverable: (BOOL) b;
+(BOOL) isHaikuDiscoverable: (NSString*) title;


//utility
+(int) randInt:(int)low :(int)high;
+(void) loadTexture:(NSString*)fn Into:(CCSprite*)s;
+(BOOL) isCollidingRect:(CCSprite*)s1 WithRect:(CCSprite*)s2;

@end