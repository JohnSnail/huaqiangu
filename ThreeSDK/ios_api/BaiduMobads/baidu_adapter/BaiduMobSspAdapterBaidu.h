//
//  BaiduMobSspAdapterBaidu.h
//  BaiduMobSsp
//
//  Created by dengjinxiang on 14-6-9.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "BaiduMobSspAdNetworkAdapter.h"
#import "BaiduMobAdDelegateProtocol.h"
#import "BaiduMobAdView.h"

@interface BaiduMobSspAdapterBaidu : BaiduMobSspAdNetworkAdapter<BaiduMobAdViewDelegate>

+ (BaiduMobSspAdNetworkType)networkType;

- (NSString *)publisherId;
- (NSString*) appSpec;
- (NSString*) channelId;

@end
