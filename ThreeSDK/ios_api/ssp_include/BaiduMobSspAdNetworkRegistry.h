//
//  BaiduMobSspAdNetworkRegistry.h
//  BaiduMobSsp
//
//  Created by dengjinxiang on 14-5-8.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BaiduMobSspAdNetworkAdapter;
@class BaiduMobSspClassWrapper;

typedef enum {
    BaiduMobSspAdNetworkRegistryBanner = 32,
    BaiduMobSspAdNetworkRegistryInterstitial = 34,
    BaiduMobSspAdNetworkRegistrySplash = 33,
} BaiduMobSspAdNetworkRegistryType;

@interface BaiduMobSspAdNetworkRegistry : NSObject {
  NSMutableDictionary *adapterDict;
}

@property (nonatomic) BaiduMobSspAdNetworkRegistryType adType;
- (void)registerClass:(Class)adapterClass;
- (BaiduMobSspClassWrapper *)adapterClassFor:(NSInteger)adNetworkType;

@end
