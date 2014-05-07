//
//  GameUtility.m
//  Pollen
//
//  Created by Garv Manocha on 5/6/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "GameUtility.h"

#import "cocos2d.h"

@implementation GameUtility

//SAVING
+(NSUInteger) savedHighScore {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"highScore"];
}
+(void) saveHighScore:(NSUInteger)val {
    [[NSUserDefaults standardUserDefaults] setInteger:val forKey:@"highScore"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//UTILITY
+(int) randInt:(int)low :(int)high {
    //will return an integer in between and including low, high
    return (arc4random()%(high-low+1))+low;
}

+(void) loadTexture:(NSString *)fn Into:(CCSprite*)s {
    if([[CCTextureCache sharedTextureCache] addImage:fn]) {
        CCTexture2D *texture = [[CCTextureCache sharedTextureCache] textureForKey:fn];
        [s setTexture:texture];
        [s setTextureRect:CGRectMake(0, 0, [texture contentSize].width,
                                        [texture contentSize].height)];
    }
}

@end