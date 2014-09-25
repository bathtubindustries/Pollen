//
//  GameUtility.m
//  Pollen
//
//  Created by Garv Manocha on 5/6/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "GameUtility.h"

#import "cocos2d.h"
#import <Firebase/Firebase.h>

#define ARC4RANDOM_MAX 0x100000000

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

+(BOOL) isHaikuDiscovered: (NSString*) title{
    
    //if userdefaults contains a key with this haiku title
    if ([[NSUserDefaults standardUserDefaults]  objectForKey:title]!=nil)
        return [[NSUserDefaults standardUserDefaults] boolForKey:title];
    
    else{
        return NO;
    }
}

+(void) itemPurchased: (NSString*) title purchased:(BOOL)b {
    [[NSUserDefaults standardUserDefaults] setBool:b  forKey:title];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL) isItemPurchased: (NSString*) title{
    
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


+(void) equipItem:(NSUInteger) val{
    [[NSUserDefaults standardUserDefaults] setInteger:val forKey:@"itemEquipped"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSUInteger) equippedItem{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"itemEquipped"];
    
}

+(BOOL) needsTutorial{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"tutorialNeeded"];
}

+(void) isTutorialNeeded: (BOOL) needed{
    [[NSUserDefaults standardUserDefaults] setBool:needed forKey:@"tutorialNeeded"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


//UTILITY
//fibonacci
+(int) fib:(int)n {
    if(n == 1) return 1;
    else if(n == 2) return 1;
    else if(n > 2) return ([GameUtility fib:(n-1)]+[GameUtility fib:(n-2)]);
    else return 0;
}

+(int) randInt:(int)low :(int)high {
    //will return an integer in between and including low, high
    return (arc4random()%(high-low+1))+low;
}
+(double)randDub:(double)low : (double) high {
    return ((double)arc4random() / ARC4RANDOM_MAX * (high - low)) + low;
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

+(void) countFirebaseHaikus
{
    Firebase* myRootRef = [[Firebase alloc] initWithUrl:@"https://ytl3fdvvuk7.firebaseio-demo.com/Haikus"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"onlineHaikuCount"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"approvedHaikuCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [myRootRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        int approvedIndex=0;
        int index=0;
        for( FDataSnapshot* datum in snapshot.children )
        {
           
            if (datum)
                index++;
             NSDictionary* dict = [datum value];
            if ([[dict objectForKey:@"approved"] isEqualToString:@"yes"])
                approvedIndex++;
            
            
        }
        [[NSUserDefaults standardUserDefaults] setInteger:index forKey:@"onlineHaikuCount"];
        [[NSUserDefaults standardUserDefaults] setInteger:approvedIndex forKey:@"approvedHaikuCount"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }];
}

+(int) approvedFirebaseHaikuCount
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"approvedHaikuCount"];
}
+(int) firebaseHaikuCount
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"onlineHaikuCount"];
}

@end