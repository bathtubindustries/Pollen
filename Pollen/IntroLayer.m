//
//  IntroLayer.m
//  jesusgetshigh
//
//  Created by garv on 4/3/14.
//  Copyright bathtubindustries 2014. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"
#import "MainMenuLayer.h"
#import "GameUtility.h"

#pragma mark - IntroLayer

// HelloWorldLayer implementation
@implementation IntroLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene {
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init {
	if((self = [super init])) {
        
        [[GameKitHelper sharedGameKitHelper] authenticateLocalPlayer];
        
		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];

		CCSprite *background;
		if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
            //NSLog(@"size height bruh BRUH %f", [[CCDirector sharedDirector] winSize].height);
            
            if([[CCDirector sharedDirector] winSize].height > 480.f) {
                background = [CCSprite spriteWithFile:@"Default-568h@2x.png"];
                
                if([[CCDirector sharedDirector] winSize].height == 568.f) {
                    //NSLog(@"loading the big file");
                } else {
                    CGPoint scaleFactor = ccp(size.width/320.f, size.height/568.f);
                    background.scaleX = scaleFactor.x;
                    background.scaleY = scaleFactor.y;
                    
                    //NSLog(@"loading the big file & scaling");
                }
            } else {
                background = [CCSprite spriteWithFile:@"Default@2x.png"];
                
                //NSLog(@"loading the small file");
            }
            //background.rotation = 90;
		} else {
			background = [CCSprite spriteWithFile:@"Default-Landscape~ipad.png"];
		}
		background.position = ccp(size.width/2, size.height/2);
        
        [GameUtility  countFirebaseHaikus];

		// add the label as a child to this Layer
		[self addChild: background];
	}
	return self;
}

-(void) onEnter {
	[super onEnter];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionProgressHorizontal transitionWithDuration:0.5 scene:[MainMenuLayer scene]]];
}
@end
