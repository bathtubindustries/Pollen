//
//  HomeLayer.m
//  ScrollDemo
//
//  Created by Levi on 7/12/13.
//  Copyright (c) 2013 zephLabs. All rights reserved.
//

#import "HaikuGalleryLayer.h"
#import "Haiku.h"
#import <Firebase/Firebase.h>
#import "WritingViewController.h"
#import "MainMenuLayer.h"
#import "GameUtility.h"

@implementation HaikuGalleryLayer


+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	HaikuGalleryLayer *layer = [HaikuGalleryLayer layerWithColor:(ccColor4B){237,227,187,255}];
    [layer load];
	[scene addChild: layer];
	return scene;
}


-(void) load {
    CGSize size = [[CCDirector sharedDirector] winSize];
    float scaleFactor = size.height/size.width;
    scrollNode = [ScrollNode nodeWithSize:CGSizeMake(size.width, size.height)];

    // is full screen so we don't need clipping
    scrollNode.clipping = NO;
    [self addChild:scrollNode];
    
    //add Haikus subdirectory to dictionary and enumerate thru each entry in loop initializing each poem in gallery
    Firebase* myRootRef = [[Firebase alloc] initWithUrl:@"https://ytl3fdvvuk7.firebaseio-demo.com/Haikus"];
    
    

    
    CCLabelTTF* GalleryLabel = [CCLabelTTF labelWithString:@"player submitted haikus " fontName:@"Chalkduster" fontSize:14*scaleFactor];
    
    [GalleryLabel setColor:ccBLACK];
    CCMenuItemLabel *label1= [CCMenuItemLabel itemWithLabel:GalleryLabel];
    label1.anchorPoint = ccp(0, 1);
    label1.position = ccp( 3*scaleFactor, size.height-5*scaleFactor);
    [scrollNode.menu addChild:label1];
    
    
    CCLabelTTF* GalleryLabel0 = [CCLabelTTF labelWithString:@"The haikus that spawn for players  " fontName:@"Chalkduster" fontSize:10*scaleFactor];
    
    [GalleryLabel0 setColor:ccc3(57,23,37)];
    CCMenuItemLabel *label0= [CCMenuItemLabel itemWithLabel:GalleryLabel0];
    label0.anchorPoint = ccp(0, 1);
    label0.position = ccp( 5*scaleFactor, size.height-30*scaleFactor);
    [scrollNode.menu addChild:label0];
    
    
    CCLabelTTF* GalleryLabel2 = [CCLabelTTF labelWithString:@"in the game come from you." fontName:@"Chalkduster" fontSize:10*scaleFactor];
    
    [GalleryLabel2 setColor:ccc3(57,23,37)];
    CCMenuItemLabel *label3= [CCMenuItemLabel itemWithLabel:GalleryLabel2];
    label3.anchorPoint = ccp(0, 1);
    label3.position = ccp( 14*scaleFactor, size.height-50*scaleFactor);
    [scrollNode.menu addChild:label3];
    
    CCMenuItemImage *itemWrite = [CCMenuItemImage itemWithNormalImage:@"UIBox.png" selectedImage:@"UIBox.png" disabledImage:nil block:^(id sender){
        
        WritingViewController *WritingController = [[WritingViewController alloc] initWithNibName:@"WritingViewController" bundle:nil];
        if (WritingController != NULL)
        {
            [[CCDirector sharedDirector] presentViewController:WritingController animated:YES completion:^(void){}];
        }

        
    }];
    itemWrite.scaleY=.4;
    itemWrite.scaleX=.6;
    
    CCLabelTTF *writeText = [CCLabelTTF labelWithString:@"write one" fontName:@"Chalkduster" fontSize:11*scaleFactor];
    [writeText setColor:ccc3(255, 224, 51)];
    [itemWrite addChild:writeText];
    writeText.scaleY = 1/(itemWrite.scaleY);
    writeText.scaleX = 1/(itemWrite.scaleX);
    writeText.position= ccp(itemWrite.position.x +itemWrite.contentSize.width/2, itemWrite.position.y+itemWrite.contentSize.height/2);
    [scrollNode.menu addChild:itemWrite];
    itemWrite.position=ccp( 100*scaleFactor, size.height-90*scaleFactor);
    
    [CCMenuItemFont setFontSize:14*scaleFactor];
    CCMenuItem *back = [CCMenuItemFont itemWithString:@"back" block:^(id sender) {
        [[CCDirector sharedDirector] replaceScene:
         [CCTransitionFadeDown transitionWithDuration:0.5 scene:[MainMenuLayer scene]]];
    }];
    [back setColor:ccc3(38,95,120)];
     CCMenu *backMenu = [CCMenu menuWithItems:back, nil];
    backMenu.position= ccp(size.width-20*scaleFactor, size.height-78*scaleFactor);
    
    [self addChild:backMenu];
    
    __block int index=0;
    //block is called once for each haiku obj on firebase site
    [myRootRef observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        
        

            NSDictionary*dict = [snapshot value];
            
            if ([[dict objectForKey:@"approved"] isEqualToString:@"yes"])
            {
            
                Haiku * poem = [[Haiku alloc] initWithDictionary:dict];
                poem.scale=1.25;
                
                int invertIndexForAscendingOrder = [GameUtility approvedFirebaseHaikuCount]-1 - index;
                
                CCMenuItemSprite * item = [CCMenuItemSprite itemWithNormalSprite:poem selectedSprite:nil];
                [scrollNode.menu addChild:item];
                 item.position = ccp(poem.contentSize.width/1.9, (size.height-110*scaleFactor-poem.contentSize.height/1.7)-invertIndexForAscendingOrder * poem.contentSize.height*1.1);
                item.anchorPoint = ccp(0.5, 0.5);
                index++;
            }
        
        
    }];
    if ([GameUtility firebaseHaikuCount] ==0)
    {
        Haiku * poem = [[Haiku alloc] initHardCoded];
        poem.scale=1.25;
        
        CCMenuItemSprite * item = [CCMenuItemSprite itemWithNormalSprite:poem selectedSprite:nil];
        [scrollNode.menu addChild:item];
        item.position = ccp(poem.contentSize.width/1.9, (size.height-110*scaleFactor-poem.contentSize.height/1.7)-index * poem.contentSize.height*1.1);
        item.anchorPoint = ccp(0.5, 0.5);
    }
    
    
    // use the Bounding Box of all the content as the scroll area
    // this will offset the content so you don't have to make your content starts at the top left
    //CGRect contentRect = [scrollNode calculateScrollViewContentRect];
    //[scrollNode setScrollViewContentRect:contentRect];
    
    // alternatively you could just set the content size
    // but now you are responsible for making sure your content starts at the right position
    [scrollNode setScrollViewContentSize:CGSizeMake(300, (size.height*scaleFactor*.5)+([GameUtility approvedFirebaseHaikuCount]==0 ? 1: [GameUtility approvedFirebaseHaikuCount]) *   250   *1.1)];
    
    scrollNode.showScrollBars = YES;
}

ccColor3B createColor(int index) {
    ccColor3B color;
    UIColor* uiColor = [UIColor colorWithHue:(index%6)/7.0f+0.03f saturation:0.6f brightness:0.8f alpha:1];
    float r,g,b,a;
    [uiColor getRed:&r green:&g blue:&b alpha:&a];
    color.r = r*255;
    color.g = g*255;
    color.b = b*255;
    return color;
}


@end
