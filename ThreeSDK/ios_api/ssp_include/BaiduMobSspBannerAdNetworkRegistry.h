//
//  BaiduMobSspAdNetworkRegistry.h
//  BaiduMobSsp
//
//  Created by dengjinxiang on 14-5-8.
//  Copyright (c) 2014年 baidu. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "BaiduMobSspAdNetworkRegistry.h"

@class BaiduMobSspAdNetworkAdapter;
@class BaiduMobSspClassWrapper;

@interface BaiduMobSspBannerAdNetworkRegistry : BaiduMobSspAdNetworkRegistry

+ (BaiduMobSspBannerAdNetworkRegistry *)sharedRegistry;
@end
