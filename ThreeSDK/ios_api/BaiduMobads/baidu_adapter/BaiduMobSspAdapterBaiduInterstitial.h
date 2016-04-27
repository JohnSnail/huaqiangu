//
//  BaiduMobSspAdapterBaiduInterstitial.h
//  BaiduMobSsp
//
//  Created by dengjinxiang on 14-6-12.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "BaiduMobSspAdNetworkAdapter.h"
#import "BaiduMobAdInterstitialDelegate.h"
#import "BaiduMobAdInterstitial.h"

@interface BaiduMobSspAdapterBaiduInterstitial : BaiduMobSspAdNetworkAdapter<BaiduMobAdInterstitialDelegate>{
    BaiduMobAdInterstitial * baiduInterstitial;
}
+ (BaiduMobSspAdNetworkType)networkType;

- (NSString *)publisherId;
- (NSString*) appSpec;
- (NSString*) channelId;

- (void)presentInterstitial;

@end
