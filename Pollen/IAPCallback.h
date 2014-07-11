//
//  IAPCallback.h
//  carambola
//
//  Created by Joseph Zhou on 12/12/12.
//
//

#ifdef __cplusplus
extern "C" {
#endif
	
	void IAPCallback(const char* product, const char* data, int result, bool isRestore);
	void ratingCallback(int type, const char* version);
	void productInfoCallback(const char* productId, const char* price);
	
#ifdef __cplusplus
}
#endif
