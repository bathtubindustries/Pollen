//
//  IAPManager.h
//  GoldMinerWorld
//
//  Created by Noel Overkamp on 8/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef GoldMinerWorld_IAPManager_h
#define GoldMinerWorld_IAPManager_h

#import <Storekit/StoreKit.h>
#import "IAPCallback.h"

// Enum defining the possible results of a purchase request
typedef enum IAPResult {
    IAPFail = 0,
    IAPBought = 1,
    IAPRestore = 2
} IAPResult;

// Delegate interface used to handle responses from Apple's servers, when we request localized product information
@interface IAPDelegate : NSObject<SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
}

// Transaction went through, update game with new content
- (void) completeTransaction: (SKPaymentTransaction *)transaction;
// Transaction went through, update game with restored content
- (void) restoreTransaction: (SKPaymentTransaction *)transaction;
// Transaction failed, do fail state
- (void) failedTransaction: (SKPaymentTransaction *)transaction;
// // Transaction went through, update game content
- (void) provideContent:(NSString*)productId tran:(SKPaymentTransaction*)p_tran firstTime:(BOOL)newBuy;
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error;
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue;

@end // @interface IAPDelegate


@interface CatalogDelegate : NSObject<SKProductsRequestDelegate>
{
}
@end

@interface IAPManager_objc : NSObject
{
}

// Initializes static variables
+(void) initManager;
// Starts an In-App Purchase (IAP) by getting the relevant localized product data from Apple's servers.
+(bool) startPurchase:(const char*)product;// callback:(IAPPurchaseCallback)callback;
//+(bool) restorePurchasesWithCallback:(IAPPurchaseCallback)callback; //no restores for now
// Call the purchase callback function, where the game handles updating player datas
+(void) completePurchase:(NSString*)product tran:(SKPaymentTransaction*)p_tran result:(IAPResult)result;


+(void) restorePurchases;

+(void) loadPurchaseData:(NSSet*) products;

@end // @interface IAPManager

#endif // #ifndef GoldMinerWorld_IAPManager_h
