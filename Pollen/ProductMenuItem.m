//
//  ProductMenuItem.m
//  Pollen
//
//  Created by Eric Nelson on 5/10/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "ProductMenuItem.h"
#import "GameUtility.h"
#import "IAPManager_objc.h"
#import "StoreLayer.h"
#import "UIBAlertView.h"
#import "SimpleAudioEngine.h"


@implementation ProductMenuItem


@synthesize productNumber;
@synthesize productName;

-(id) init{
    
    
    self= [ProductMenuItem itemWithNormalImage:@"storeTemplate.png" selectedImage:@"storeTemplate.png" target:self selector:@selector(productClicked:)];
    return self;
    
    
}

-(id) initWithProductNumber: (NSInteger) num{
    CGSize size = [[CCDirector sharedDirector] winSize];
    float scaleFactor = size.height/size.width;
    ccColor3B labelColor = ccc3(224,192,26);
    
    if (num==0){
        
    self = [ProductMenuItem itemWithNormalImage:@"storeTemplate.png" selectedImage:@"storeTemplate.png" target:self selector:@selector(productClicked:)];
        [self setIsEnabled:YES];
        self.itemSprite = [CCSprite spriteWithFile:@"sporeTwigStaff.png"];
        self.itemSprite.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
        
        [self setProductName:@"Sporetwig Staff"];
        
        self.isIAP= false;
        self.consumable=false;
        self.eyeCost=0;
        
        CCLabelTTF * label = [CCLabelTTF labelWithString:self.productName fontName:@"Futura" fontSize:8*scaleFactor];
        label.color = labelColor;
        label.position = CGPointMake(self.itemSprite.position.x, self.itemSprite.position.y-40*scaleFactor);
        [self addChild:label];
        [self addChild:self.itemSprite];
        
        CCLabelTTF * labelPrice = [CCLabelTTF labelWithString:@"house" fontName:@"Futura" fontSize:10*scaleFactor];
        labelPrice.color = labelColor;
        labelPrice.position = CGPointMake(6*scaleFactor +self.contentSize.width/2, label.position.y-14*scaleFactor);
        [self addChild:labelPrice];
        
        CCSprite *imagePrice = [CCSprite spriteWithFile:@"costEyes.png"];
        imagePrice.position = CGPointMake(labelPrice.position.x - labelPrice.contentSize.width +2*scaleFactor, labelPrice.position.y);
        [self addChild:imagePrice];

        self.lockSprite = [[CCSprite spriteWithFile:@"lockedOverlay.png"] retain];
        self.equipSprite = [[CCSprite spriteWithFile:@"equippedOverlay.png"] retain];
        self.lockSprite.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
        self.lockSprite.visible=NO;
        [self addChild:self.lockSprite];

        
        self.equipSprite = [CCSprite spriteWithFile:@"equippedOverlay.png"];
        self.equipSprite.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2 +1);
        [self addChild:self.equipSprite];
        if ([GameUtility equippedItem] == self.productNumber)
        {
            self.equipSprite.visible=YES;
           
        }
        
        
    }
    
    
    else if (num==1){
        self = [ProductMenuItem itemWithNormalImage:@"storeTemplate.png" selectedImage:@"storeTemplate.png" target:self selector:@selector(productClicked:)];
        [self setIsEnabled:YES];
        [self setProductName:@"Dandelion Hammer"];
        
        self.isIAP= false;
        self.consumable=false;
        self.eyeCost=1000;
        
        self.itemSprite = [CCSprite spriteWithFile:@"DandelionHammer.png"];
        self.itemSprite.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
        
        CCLabelTTF * label = [CCLabelTTF labelWithString:self.productName fontName:@"Futura" fontSize:8*scaleFactor];
        label.color = labelColor;
        label.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2-40*scaleFactor);
        [self addChild:label];
        [self addChild:self.itemSprite];
        
        CCLabelTTF * labelPrice = [CCLabelTTF labelWithString:@"1000" fontName:@"Futura" fontSize:10*scaleFactor];
        labelPrice.color = labelColor;
        labelPrice.position = CGPointMake(6*scaleFactor +self.contentSize.width/2,  label.position.y-14*scaleFactor);
        [self addChild:labelPrice];
        
        CCSprite *imagePrice = [CCSprite spriteWithFile:@"costEyes.png"];
        imagePrice.position = CGPointMake(labelPrice.position.x - labelPrice.contentSize.width+2*scaleFactor, labelPrice.position.y);
        [self addChild:imagePrice];
        
        self.lockSprite = [[CCSprite spriteWithFile:@"lockedOverlay.png"] retain];
        self.equipSprite = [[CCSprite spriteWithFile:@"equippedOverlay.png"] retain];
        self.lockSprite.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
        [self addChild:self.lockSprite];
        self.equipSprite.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2 +1);
        [self addChild:self.equipSprite];
        self.lockSprite.visible=NO;
        self.equipSprite.visible=NO;
        if (![GameUtility isItemPurchased:self.productName])
        {
            self.lockSprite.visible=YES;
            
        }
        
        else if ([GameUtility equippedItem] == self.productNumber)
        {
            
            self.equipSprite.visible=YES;
        }
    }
    
    
    else if (num==2){
        self = [ProductMenuItem itemWithNormalImage:@"storeTemplateConsumable.png" selectedImage:@"storeTemplateConsumable.png" target:self selector:@selector(productClicked:)];
        [self setIsEnabled:YES];
        [self setProductName:@"100 Spidderoso Peepers"];
        
        self.isIAP= true;
        self.consumable=true;
        
        CCLabelTTF * label = [CCLabelTTF labelWithString:self.productName fontName:@"Futura" fontSize:5*scaleFactor];
        label.color = labelColor;
        label.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2-20*scaleFactor);
        //[self addChild:label];
        
        CCLabelTTF * labelPrice = [CCLabelTTF labelWithString:@"$ 0.99" fontName:@"Futura" fontSize:10*scaleFactor];
        labelPrice.color = labelColor;
        labelPrice.position = CGPointMake(self.contentSize.width/2,  label.position.y-10*scaleFactor);
        [self addChild:labelPrice];
        
        self.itemSprite = [CCSprite spriteWithFile:@"eyesStore100.png"];
        self.itemSprite.position = CGPointMake(self.contentSize.width/2, -10 *scaleFactor +self.contentSize.height/2);
        self.itemSprite.scale=1.3;
        [self addChild:self.itemSprite];
    
    }
    
    else if (num==3){
        self = [ProductMenuItem itemWithNormalImage:@"storeTemplateConsumable.png" selectedImage:@"storeTemplateConsumable.png" target:self selector:@selector(productClicked:)];
        [self setIsEnabled:YES];
        [self setProductName:@"250 Spidderoso Peepers"];
        
        self.isIAP= true;
        self.consumable=true;
        
        CCLabelTTF * label = [CCLabelTTF labelWithString:self.productName fontName:@"Futura" fontSize:5*scaleFactor];
        label.color = labelColor;
        label.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2-20*scaleFactor);
        //[self addChild:label];
        
        
        CCLabelTTF * labelPrice = [CCLabelTTF labelWithString:@"$ 1.99" fontName:@"Futura" fontSize:10*scaleFactor];
        labelPrice.color = labelColor;
        labelPrice.position = CGPointMake(self.contentSize.width/2,  label.position.y-10*scaleFactor);
        [self addChild:labelPrice];
        
        self.itemSprite = [CCSprite spriteWithFile:@"eyesStore250.png"];
        self.itemSprite.position = CGPointMake(self.contentSize.width/2, -10 *scaleFactor +self.contentSize.height/2);
        self.itemSprite.scale=1.3;
        [self addChild:self.itemSprite];
        
    }
    
    else if (num==4){
        self = [ProductMenuItem itemWithNormalImage:@"storeTemplateConsumable.png" selectedImage:@"storeTemplateConsumable.png" target:self selector:@selector(productClicked:)];
        [self setIsEnabled:YES];
        [self setProductName:@"3 Haikus"];
        
        self.isIAP= false;
        self.consumable=true;
        self.eyeCost=150;
        
        CCLabelTTF * label = [CCLabelTTF labelWithString:self.productName fontName:@"Futura" fontSize:7*scaleFactor];
        label.color = labelColor;
        label.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2-20*scaleFactor);
        //[self addChild:label];
        
        CCLabelTTF * labelPrice = [CCLabelTTF labelWithString:@"150" fontName:@"Futura" fontSize:10*scaleFactor];
        labelPrice.color = labelColor;
        labelPrice.position = CGPointMake(4*scaleFactor+self.contentSize.width/2,  label.position.y-10*scaleFactor);
        [self addChild:labelPrice];
        
        CCSprite *imagePrice = [CCSprite spriteWithFile:@"costEyes.png"];
        imagePrice.position = CGPointMake(labelPrice.position.x - labelPrice.contentSize.width, labelPrice.position.y);
        [self addChild:imagePrice];
        
        self.itemSprite = [CCSprite spriteWithFile:@"haikuStore3.png"];
        self.itemSprite.position = CGPointMake(self.contentSize.width/2, -10 *scaleFactor + self.contentSize.height/2);
        self.itemSprite.scale=1.3;
        [self addChild:self.itemSprite];
        
    }

    
    
    self.productNumber=num;
    return self;
    
}


-(void) update:(ccTime)delta
{
    if (!self.consumable)
    {
        if ([GameUtility equippedItem] != self.productNumber && self.equipSprite)
        {
            self.equipSprite.visible=NO;
        }
        else if ([GameUtility equippedItem] == self.productNumber && !self.equipSprite.visible)
        {
            self.equipSprite.visible=YES;
        }
        
        if ([GameUtility isItemPurchased:self.productName] && self.lockSprite)
        {
            self.lockSprite.visible=NO;
        }
    }
}


-(void) productClicked:(id) sender{
    ProductMenuItem * item = (ProductMenuItem*)sender;
    NSString* name = [(ProductMenuItem*)sender productName];
    
    
    
    if ([GameUtility isItemPurchased:name]) { //Already Purchased
        
        
        [GameUtility equipItem:item.productNumber];
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"wandSelect.aiff"];
        
    }
    else
    {
        
        if (item.isIAP)  //if realmoney involved
        {
           /* UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Confirmation" message:@"Purchase in progress" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] autorelease];
            [alert show];
            [IAPManager_objc initManager];
            [IAPManager_objc loadPurchaseData:[NSSet setWithObject:[StoreLayer productIDforName:name] ]];*/
            
            
            UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:@"Confirmation" message:@"Purchase?" cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes",nil];
            [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
                if (didCancel) {
                    return;
                }
                switch (selectedIndex) {
                    case 1:
                    {
                        
                        UIAlertView *alert2 = [[[UIAlertView alloc] initWithTitle:@"Confirmed!" message:@"Hang out for a few moments while your purchase is completed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] autorelease];
                        [alert2 show];
                        
                        [IAPManager_objc initManager];
                        [IAPManager_objc loadPurchaseData:[NSSet setWithObject:[StoreLayer productIDforName:name] ]];
                        break;
                    }
                }
            }];
 
            
        }
        
        else
        {
            if (item.eyeCost <= [GameUtility savedSpidderEyeCount])
            {
                if (![item consumable])
                {
                    [GameUtility itemPurchased:name purchased:YES];
                }
                [GameUtility saveSpidderEyeCount:([GameUtility savedSpidderEyeCount]-item.eyeCost)];
                
                if ([name isEqualToString:@"3 Haikus"])
                {
                    [GameUtility saveHaikuCount:[GameUtility savedHaikuCount]+3];
                }
                UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Confirmation" message:@"Purchase completed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] autorelease];
                
                [alert show];
            }
            else
            {
                UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Not enough peepers" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Aw man", nil] autorelease];
                
                [alert show];
            }
            
        }

        
        
    }
        
         
}


@end
