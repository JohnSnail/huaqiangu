//
//  BaiduMobSspAdIAPLogManager.h
//  BaiduMobSsp
//
//  Created by lishan04 on 15/12/17.
//  Copyright © 2015年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaiduMobSspAdIAPLogManager : NSObject

+ (BaiduMobSspAdIAPLogManager *)sharedLogManager;

// 开发者调用的接口，回调购买完成 productId为商品id，transId为交易id，apId为代码位id
- (void)didAdPurchaseSuccessedWithProductId:(NSString *)productId transId:(NSString *)transId apId:(NSString *)apId;


// 开发者调用的接口，回调购买失败 productId为商品id，transId为交易id，apId为代码位id
- (void)didAdPurchaseFailedWithProductId:(NSString *)productId transId:(NSString *)transId apId:(NSString *)apId;

@end
