//
// example for handling responses from IAPManager_objc
//
//

#include "IAPManager.h"
#include "IAPManager_objc.h"
#include "GameUtility.h"

map<String, String> IAPManager::s_productData;

void IAPManager::init()
{
	[IAPManager_objc initManager];
}

void IAPManager::startPurchase(const char *product)
{
	[IAPManager_objc startPurchase:product];
}

void IAPManager::completePurchase(const char *product, const char *data, int result, bool isRestore)
{
	NSLog(@"IAPManager::completePurchase %s | %i", product, result);
	if(result == 1)
	{
		
        NSLog(@"purchsucc on %s",product);
        
        if ([[NSString stringWithUTF8String:product] rangeOfString:@"SpidderosoPeepers250"].location != NSNotFound)//product is named 250 peepers on developer center
        {
            [GameUtility saveSpidderEyeCount:[GameUtility savedSpidderEyeCount]+3500];
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Successful purchase" message:@"3500 peepers added" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] autorelease];
            
            [alert show];
        }
        else if ([[NSString stringWithUTF8String:product] rangeOfString:@"SpiderrosoPeepers100"].location != NSNotFound)//product is 100 peepers on developer center
        {
            [GameUtility saveSpidderEyeCount:[GameUtility savedSpidderEyeCount]+1500];
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Successful purchase" message:@"1500 peepers added" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] autorelease];
            
            [alert show];
        }
        
	} else {
		//todo: purchase failed, tell user to stop waiting and/or try again.
       /* NSLog(@"purchfail");
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Purchase failed" message:@"Check your connection and try again" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] autorelease];
        
        [alert show];*/
        
	}
}

void IAPManager::restorePurchases()
{
	[IAPManager_objc restorePurchases];
}

//load price data for a number of product ids.
void IAPManager::loadPurchaseData(vector<String> products)
{
	NSMutableSet *productsToRequest = [NSMutableSet set];
	for(int i = 0; i < products.size(); i++)
	{
		String s = products[i];
		if(s_productData.count(s))
		{
			//already loaded that.
			//todo: notify caller that data is already available for [s]
            //[productsToRequest addObject:[NSString stringWithUTF8String:s.c_str()]];
		}
		else
		{
			[productsToRequest addObject:[NSString stringWithUTF8String:s.c_str()]];
		}
	}
	if([productsToRequest count] > 0)
	{
		//we still need to request some things, send the request.
		[IAPManager_objc loadPurchaseData:productsToRequest];
	}
}

void IAPManager::setProductInfo(const char *productId, const char *price)
{
	s_productData[productId] = price;
	//todo: notify caller of loadPurchaseData that data is now available for [productId]
}

String IAPManager::getProductInfo(const char *productId)
{
	return s_productData[productId];
}