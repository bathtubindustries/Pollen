//
//  ProductMenuItem.h
//  Pollen
//
//  Created by Eric Nelson on 5/10/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "CCMenuItem.h"


@interface ProductMenuItem : CCMenuItemImage

-(void) productClicked: (id) sender;
-(id) initWithProductNumber: (NSInteger) num;
-(void) update:(ccTime)delta;

@property NSInteger productNumber;
@property (retain) NSString* productName;
@property (nonatomic, retain) CCSprite* itemSprite;
@property (nonatomic, assign)    BOOL consumable;
@property (nonatomic, assign)    BOOL isIAP;
@property (nonatomic, assign)    int eyeCost;
@property (nonatomic,assign) CCSprite* equipSprite;
@property (nonatomic,assign) CCSprite* lockSprite;



@end