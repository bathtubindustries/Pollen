//
//  ProductMenuItem.h
//  Pollen
//
//  Created by Eric Nelson on 5/10/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "CCMenuItem.h"
#import "SFHFKeychainUtils.h"


@interface ProductMenuItem : CCMenuItemImage{
    
    BOOL purchased;
}
    
-(void) productClicked: (id) sender;
-(id) initWithProductNumber: (NSInteger) num;
-(void) loadImages;


@property NSInteger productNumber;
@property (retain) NSString* productName;



@end
