//
//  IAPManager.m
//  GoldMinerWorld
//
//  Created by Noel Overkamp on 8/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IAPManager_objc.h"
#import "Grab/NSData+Base64.h"
#import "IAPCallback.h"

static IAPDelegate* iapDelegate = NULL;
static CatalogDelegate* catalogDelegate = NULL;
static NSMutableDictionary* g_iapProducts = nil;

@implementation CatalogDelegate

-(id) init
{
	self = [super init];
	return self;
}

-(void) dealloc
{
#if !__has_feature(objc_arc)
	[super dealloc];
#endif
}

// This is defined in SKProductsRequest.h
// This is called by Apple's servers responding to our request for localized product information
//triggered from request started by SKProductsRequest:initWithProductIdentifiers from IAPManager_objc:startPurchase: -joe
-(void) productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray* validProducts = [response products];
    if([validProducts count] > 0)
    {
		NSLog(@"productsRequest got a response");
        // Do payment transactions for each product where we received valid product info
        for(int i=0; i<validProducts.count; i++)
        {
            SKProduct* product = (SKProduct*)[validProducts objectAtIndex:i];
			//first format the price to a localized currency value
			NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
#if !__has_feature(objc_arc)
			[numberFormatter autorelease];
#endif
			[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
			[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
			[numberFormatter setLocale:product.priceLocale];
			NSString* priceString = [numberFormatter stringFromNumber:product.price];
			productInfoCallback([product.productIdentifier UTF8String], [priceString UTF8String]);
			
			[g_iapProducts setObject:product forKey:product.productIdentifier];
            [IAPManager_objc startPurchase:[product.productIdentifier cStringUsingEncoding:NSStringEncodingConversionAllowLossy]];
        }
	}
    // No valid products found
	else if(response.invalidProductIdentifiers.count > 0)
    {
		NSLog(@"productsRequest found invalid ids: %@", [response.invalidProductIdentifiers objectAtIndex:0]);
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Purchase failed" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] autorelease];
        [alert show];
	}
    // Unable to connect to iTunes App Store
	else
    {
		NSLog(@"productsRequest failure");
	}
	
#if !__has_feature(objc_arc)
	[request autorelease];
#endif
}

// This is defined in SKRequest.h
-(void) request:(SKRequest *)request didFailWithError:(NSError *)error
{
	NSLog(@"CatalogDelegate request failed.");
#if !__has_feature(objc_arc)
	[request autorelease];
#endif
}

@end


//--- IAPDelegate
@implementation IAPDelegate

-(id) init
{
	self = [super init];
	[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
	return self;
}

-(void) dealloc
{
#if !__has_feature(objc_arc)
	[super dealloc];
#endif
}

// This is defined in SKProductsRequest.h
// This is called by Apple's servers responding to our request for localized product information
//triggered from request started by SKProductsRequest:initWithProductIdentifiers from IAPManager_objc:startPurchase: -joe
-(void) productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray* validProducts = [response products];
    
    if([validProducts count] > 0)
    {
        // Do payment transactions for each product where we received valid product info
        for(int i=0; i<validProducts.count; i++)
        {
            SKProduct* product = (SKProduct*)[validProducts objectAtIndex:i];
            SKPayment* payment = [SKPayment paymentWithProduct:product];
            [[SKPaymentQueue defaultQueue] addPayment:payment];
			[g_iapProducts setObject:product forKey:product.productIdentifier];
        }
	}
    // No valid products found
	else if(response.invalidProductIdentifiers.count > 0)
    {
        
#if TARGET_OS_IPHONE == 1
		NSString* str = [NSString stringWithFormat:@"Oops, the product is currently unavailable"];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:str
														message:nil
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
        NSArray * skProducts = response.products;


#if !__has_feature(objc_arc)
		[alert autorelease];
#endif
		[alert show];
#endif
        [IAPManager_objc completePurchase:NULL tran:NULL result:IAPFail];
	}
    // Unable to connect to iTunes App Store
	else
    {
#if TARGET_OS_IPHONE == 1
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to connect to the iTunes App Store"
														message:nil
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
#if !__has_feature(objc_arc)
		[alert autorelease];
#endif
		[alert show];
#endif
		[IAPManager_objc completePurchase:NULL tran:NULL result:IAPFail];
	}
	
#if !__has_feature(objc_arc)
	[request autorelease];
#endif
}

// This is defined in SKRequest.h
-(void) request:(SKRequest *)request didFailWithError:(NSError *)error
{
#if TARGET_OS_IPHONE == 1
    NSString* title = [error localizedDescription];
	if(error.code == 0)
    {
		title = @"You need an internet connection to use In App Purchases";
	}
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
													message:nil
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
#if !__has_feature(objc_arc)
	[alert autorelease];
#endif
	[alert show];
#endif
    [IAPManager_objc completePurchase:NULL tran:NULL result:IAPFail];
}

// This is defined in SKPaymentQueue.h
-(void) paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
				//can fail if http://sandbox.itunes.apple.com/ returns Http/1.1 Service Unavailable
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}

// Transaction went through, update game with new content
-(void) completeTransaction: (SKPaymentTransaction *)transaction
{
    [self provideContent: transaction.payment.productIdentifier tran:transaction firstTime:TRUE];
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

// Transaction went through, update game with restored content
- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
    [self provideContent: transaction.originalTransaction.payment.productIdentifier tran:transaction firstTime:FALSE];
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

// Transaction failed, do fail state
- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
#if TARGET_OS_IPHONE == 1
    if (transaction.error.code != SKErrorPaymentCancelled)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
														message:@"Could not connect to the iTunes Store. Please try again later."
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
#if !__has_feature(objc_arc)
		[alert autorelease];
#endif
		[alert show];
	}
#endif
    [IAPManager_objc completePurchase:transaction.originalTransaction.payment.productIdentifier tran:transaction result:IAPFail];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

// // Transaction went through, update game content
- (void) provideContent:(NSString*)productId tran:(SKPaymentTransaction*)p_tran firstTime:(BOOL)newBuy
{
    [IAPManager_objc completePurchase:productId tran:p_tran result:IAPBought];
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
	NSLog(@"restore failed");
    [IAPManager_objc completePurchase:NULL tran:NULL result:IAPFail];
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
	NSLog(@"restore done");
    [IAPManager_objc completePurchase:NULL tran:NULL result:IAPRestore];
}


@end


//--- IAPManager
@implementation IAPManager_objc

+(void) initManager
{
    if(iapDelegate == NULL)
    {
        iapDelegate = [[IAPDelegate alloc] init];
		catalogDelegate = [[CatalogDelegate alloc] init];
		g_iapProducts = [[NSMutableDictionary alloc] init];
    }
}

// Starts an In-App Purchase (IAP) by getting the relevant localized product data from Apple's servers.
+(bool) startPurchase:(const char*)product// callback:(IAPPurchaseCallback)callback
{
	NSString* productName = [NSString stringWithCString:product encoding:NSStringEncodingConversionAllowLossy];
    // Set the static callback function
//    iapPurchaseCallback = callback;
    
    if(![SKPaymentQueue canMakePayments])
    {
#if TARGET_OS_IPHONE == 1
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"In App Purchases are currently disabled"
                                                        message:nil
                                                        delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
#if !__has_feature(objc_arc)
		[alert autorelease];
#endif
        [alert show];
#endif
//		IAP::completePurchase(productName, @"", IAPFail);
        return false;
    }
    
	if([g_iapProducts valueForKey:productName] != nil)
	{
		//we already looked it up, go buy it.
		SKProduct* product = (SKProduct*)[g_iapProducts valueForKey:productName];
		SKPayment* payment = [SKPayment paymentWithProduct:product];
		[[SKPaymentQueue defaultQueue] addPayment:payment];
		return true;
	}
	
    // productIds is a set of product ids which are sent to iTunes servers.
    // The servers will tell us if there are valid products with these ids.
    // If yes, they will give us the localized product infos (localized text, prices, etc).
    NSSet* productIds = [NSSet setWithObject:productName];
    SKProductsRequest* productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIds];
    productsRequest.delegate = iapDelegate; // Listen in to server response
    [productsRequest start]; // Send the request
    
    return true;
}

//+(bool) restorePurchasesWithCallback:(IAPPurchaseCallback)callback;
//{
//    iapPurchaseCallback = callback;
//    
//    SKPaymentQueue* queue = [SKPaymentQueue defaultQueue];
//    [queue restoreCompletedTransactions];
//    
//    return TRUE;
//}

// When we receive a response from Apple servers we call this function to handle results.
+(void) completePurchase:(NSString*)product tran:(SKPaymentTransaction*)p_tran result:(IAPResult)result
{
#if TARGET_OS_IPHONE == 1
	NSString* base64data = [p_tran.transactionReceipt base64EncodedString]; //[[NSString alloc] initWithData:p_receipt encoding:NSUTF8StringEncoding]; //[p_receipt base64EncodedString];
	base64data = [base64data stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
	
//    iapPurchaseCallback(product, base64data, result);
	IAPCallback([product cStringUsingEncoding:NSASCIIStringEncoding], [base64data cStringUsingEncoding:NSASCIIStringEncoding], result, p_tran.transactionState == SKPaymentTransactionStateRestored);
#endif
}

+(void) restorePurchases
{
	[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

+(void) loadPurchaseData:(NSSet *)products
{
    
    SKProductsRequest* prodReq = [[SKProductsRequest alloc] initWithProductIdentifiers:products];
        NSLog(@"purch?");
    
    prodReq.delegate = catalogDelegate;
    [prodReq start];
}

@end
