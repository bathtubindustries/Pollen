//
//  StoreLayer.m
//  Pollen
//
//  Created by Garv Manocha on 5/7/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "StoreLayer.h"
#import "MainMenuLayer.h"
#import "GameUtility.h"

NSMutableDictionary* productIDs;

@implementation StoreLayer

-(id) init {
    if(self = [super init]) {
        CCSprite *img = [CCSprite spriteWithFile:@"pollenstorebg.png"];
        img.anchorPoint = ccp(0, 0);
        img.position = ccp(0, 0);
        [self addChild:img];
        
# warning GIVING FREE EYES TO TESTERS
        [GameUtility saveSpidderEyeCount:1500];
        
        
        products = [[NSMutableArray array] retain];
        productIDs = [[NSMutableDictionary dictionary] retain];
        
        [productIDs setObject:@"com.BathtubIndustries.PollenBug.SpidderosoPeepers250" forKey:@"250 Spidderoso Peepers"];
        [productIDs setObject:@"com.BathtubIndustries.PollenBug.SpidderosoPeepers100" forKey:@"100 Spidderoso Peepers"];
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        float scaleFactor = winSize.height/winSize.width;
        
        ProductMenuItem * sporeTwig = [[ProductMenuItem alloc]initWithProductNumber:0];
        sporeTwig.position = ccp(winSize.width/2 - sporeTwig.activeArea.size.width/1.38, winSize.height - sporeTwig.activeArea.size.height);

        ProductMenuItem * Dandelion = [[ProductMenuItem alloc]initWithProductNumber:1];
        Dandelion.position = ccp(winSize.width - Dandelion.activeArea.size.width/1.38, winSize.height - Dandelion.activeArea.size.height);
        
        ProductMenuItem * Eyes100 = [[ProductMenuItem alloc]initWithProductNumber:2];
        Eyes100.position = ccp(sporeTwig.position.x-10*scaleFactor,sporeTwig.position.y-sporeTwig.contentSize.height);
        
        ProductMenuItem * Eyes250 = [[ProductMenuItem alloc]initWithProductNumber:3];
        Eyes250.position = ccp(Eyes100.position.x+Eyes100.contentSize.width,Eyes100.position.y);

        ProductMenuItem * Haikus3 = [[ProductMenuItem alloc]initWithProductNumber:4];
        Haikus3.position = ccp(Eyes250.position.x+Eyes250.contentSize.width,Eyes250.position.y);
        [products addObject:sporeTwig];
        [products addObject:Dandelion];
        [products addObject:Eyes100];
        [products addObject:Eyes250];
        [products addObject:Haikus3];
        
        CCMenu *storeMenu = [CCMenu menuWithItems:sporeTwig,Dandelion,Eyes100,Eyes250,Haikus3, nil];
        storeMenu.position = CGPointZero;
        [self addChild:storeMenu];
        
        
        spidderEyeCounter_.anchorPoint = ccp(0, 1);
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"spidderEyeCounter.plist"];
        spidderEyeCounter_ = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"counter1.png"]]];
        spidderEyeCounter_.scale=1.10;
        spidderEyeCounter_.position = ccp(1 + [spidderEyeCounter_ boundingBox].size.width/2, winSize.height - [spidderEyeCounter_ boundingBox].size.height/2);
        [self addChild: spidderEyeCounter_ z:0];

        spidderEyeLabel_ = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",[GameUtility savedSpidderEyeCount]] fontName:@"Futura" fontSize:10*scaleFactor];
        spidderEyeLabel_.anchorPoint = ccp(0, 1);
        spidderEyeLabel_.position = ccp( [spidderEyeCounter_ boundingBox].size.width*.6 , winSize.height-[spidderEyeCounter_ boundingBox].size.height/4);
        [self addChild: spidderEyeLabel_ z:spidderEyeCounter_.zOrder+1];
        
        
        haikuCounter_ = [CCSprite spriteWithFile:@"haikuUI.png"];
        haikuCounter_.scale=.16;
        haikuCounter_.position = ccp(winSize.width - [haikuCounter_ boundingBox].size.width*1.4, spidderEyeCounter_.position.y);
        [self addChild: haikuCounter_ z:0];
        
        haikuLabel_ = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"X%i", [GameUtility savedHaikuCount]]
                                         fontName:@"Futura" fontSize:12*scaleFactor];
        haikuLabel_.anchorPoint = ccp(0, 1);
        haikuLabel_.position = ccp(haikuCounter_.position.x+[haikuCounter_ boundingBox].size.width/2,haikuCounter_.position.y);
        [self addChild:haikuLabel_ z:0];

        
        
    }
    return self;
}

+(NSString*) productIDforName:(NSString*) name{
    return [productIDs objectForKey:name];
}



-(void) update:(ccTime)dt
{
    [spidderEyeLabel_ setString:[NSString stringWithFormat:@"%d",[GameUtility savedSpidderEyeCount]]];
    [haikuLabel_ setString:[NSString stringWithFormat:@"X%i", [GameUtility savedHaikuCount]]];
    
    for (ProductMenuItem* item in products)
    {
        [item update:dt];
    }
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
    [[CCDirector sharedDirector] replaceScene:
     [CCTransitionSlideInT transitionWithDuration:0.5 scene:[MainMenuLayer scene]]];
    return YES;
}

//UTILITY
+(CCScene*) scene {
    CCScene *scene = [CCScene node];
    StoreLayer *layer = [StoreLayer node];
    [scene addChild:layer];
    return scene;
}

@end
