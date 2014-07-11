//
//  IAP.h
//  carambola
//
//  Created by Joseph Zhou on 12/12/12.
//
//

#ifndef __carambola__IAPManager__
#define __carambola__IAPManager__

#include "HgString.h"
#include <map>

using namespace std;

class IAPManager
{
private:
	static map<String, String> s_productData;
public:
	static void init();
	static void startPurchase(const char* product);
	static void completePurchase(const char* product, const char* data, int result, bool isRestore);
	static void restorePurchases();
	//null-terminated array of char* product names to look up.  responses are dispatched on iapDispatcher.
	static void loadPurchaseData(vector<String> products);
	static void setProductInfo(const char* productId, const char* price);
	
	//only call this if you know that we have already cached the file info
	static String getProductInfo(const char* productId);
};

#endif /* defined(__carambola__IAPManager__) */