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

+(NSUInteger) savedHaikuCount {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"haikuCount"];
}
+(void) saveHaikuCount:(NSUInteger)val {
    [[NSUserDefaults standardUserDefaults] setInteger:val forKey:@"haikuCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//PASS IN 'NO' TO MARK THIS HAIKU AS DISCOVERED.
+(void) HaikuDiscovered: (NSString*) title discoverable:(BOOL)b {
    [[NSUserDefaults standardUserDefaults] setBool:b  forKey:title];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL) isHaikuDiscoverable: (NSString*) title{
    
    //if userdefaults contains a key with this haiku title
    if ([[NSUserDefaults standardUserDefaults]  objectForKey:title]!=nil)
        return [[NSUserDefaults standardUserDefaults] boolForKey:title];
    
    else{
        return NO;
    }
}


+(void) saveSpidderEyeCount:(NSUInteger) val{
    [[NSUserDefaults standardUserDefaults] setInteger:val forKey:@"spidderEyeCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSUInteger) savedSpidderEyeCount{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"spidderEyeCount"];

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

+(BOOL) isCollidingRect:(CCSprite*)s1 WithRect:(CCSprite*)s2 {
    return CGRectIntersectsRect([s1 boundingBox], [s2 boundingBox]);
}

@end