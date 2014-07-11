//
//  IAPCallback.cpp
//  carambola
//
//  Created by Joseph Zhou on 12/12/12.
//
//

#include "IAPCallback.h"
#include "IAPManager.h"

void IAPCallback(const char* product, const char* data, int result, bool isRestore)
{
	IAPManager::completePurchase(product, data, result, isRestore);
}

void productInfoCallback(const char* productId, const char* price)
{
    IAPManager::setProductInfo(productId, price);
}
