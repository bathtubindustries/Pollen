//
//  GameUtility.h
//  Pollen
//
//  Created by Garv Manocha on 5/6/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "CCNode.h"

@class CCSprite;

@interface GameUtility : CCNode {}
@property(nonatomic, readonly, assign) NSUInteger savedHighScore;

//saving
+(NSUInteger) savedHighScore;
+(void) saveHighScore:(NSUInteger)val;

//utility
+(int) randInt:(int)low :(int)high;
+(void) loadTexture:(NSString*)fn Into:(CCSprite*)s;

@end