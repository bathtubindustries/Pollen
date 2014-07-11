//
//  StoreLayer.h
//  Pollen
//
//  Created by Garv Manocha on 5/7/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "cocos2d.h"
#import "ProductMenuItem.h"
#import "IAPManager_objc.h"

@interface StoreLayer : CCLayer{
    
    CCSprite *spidderEyeCounter_;
    CCLabelTTF *spidderEyeLabel_;
    NSMutableArray* products;
    CCSprite *haikuCounter_;
    CCLabelTTF *haikuLabel_;
}

extern NSMutableDictionary* productIDs;
-(void) update:(ccTime)dt;
+(CCScene*) scene;
+(NSString*) productIDforName:(NSString*) name;

@end

