//
//  ProductMenuItem.m
//  Pollen
//
//  Created by Eric Nelson on 5/10/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "ProductMenuItem.h"


@implementation ProductMenuItem


@synthesize productNumber;
@synthesize productName;

-(id) init{
    
    
    self= [ProductMenuItem itemFromNormalImage:@"sporeTwigStaff.png" selectedImage:@"sporeTwigStaff.png" target:self selector:@selector(productClicked:)];
    purchased=NO;
    return self;
    
}

-(id) initWithProductNumber: (NSInteger) num{
    
    
    if (num==0){
    self = [ProductMenuItem itemFromNormalImage:@"sporeTwigStaff.png" selectedImage:@"sporeTwigStaff.png" target:self selector:@selector(productClicked:)];
        [self setIsEnabled:YES];
        
        
        [self setProductName:@"Sporetwig Staff"];
        
        
        purchased=YES;
    }
    
    
    else if (num==1){
        self = [ProductMenuItem itemFromNormalImage:@"DandelionHammer.png" selectedImage:@"DandelionHammer.png" disabledImage: @"DandelionHammerLocked.png" target:self selector:@selector(productClicked:)];
       // [self setIsEnabled:false];
        [self setProductName:@"Dandelion Hammer"];
        purchased=NO;
    }
    
    
    self.productNumber=num;
    return self;
    
}




-(void) productClicked:(id) sender{
    
    
    
    if ([self IAPItemPurchased] || purchased==YES) {
        
        
        
        NSLog(@"Already Purchased, so equip");
        
    } else {
       
        
        // not purchased so show a view to prompt for purchase
        
        UIAlertView *askToPurchase = [[UIAlertView alloc]
                         
                         initWithTitle:[NSString stringWithFormat: @"%@ is locked up", [sender productName]]
                         
                         message:@"Purchase?"
                         
                         delegate:self
                         
                         cancelButtonTitle:nil
                         
                         otherButtonTitles:@"Yes", @"No", nil];
        
        askToPurchase.delegate = self;  
        
        [askToPurchase show];  
        
        [askToPurchase release];  
        
    }
         
}

-(BOOL)IAPItemPurchased {
    
    
    
    NSError *error = nil;
    
    NSString *password = [SFHFKeychainUtils getPasswordForUsername:@"dev" andServiceName:productNumber error:&error];
    
    
    
    if ([password isEqualToString:@"whatever"]) return YES; else return NO;
    
    
    
}

-(void) loadImages{
   
    
}

@end
