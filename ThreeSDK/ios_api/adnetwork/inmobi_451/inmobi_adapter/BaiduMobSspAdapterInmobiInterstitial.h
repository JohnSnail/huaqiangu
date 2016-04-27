//
//  BaiduMobSspAdapterInmobiInterstitial.h
//  BaiduMobSspSample
//
//  Created by dengjinxiang on 14-7-8.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "BaiduMobSspAdNetworkAdapter.h"
#import "IMInterstitialDelegate.h"
#import "IMInterstitial.h"
@interface BaiduMobSspAdapterInmobiInterstitial : BaiduMobSspAdNetworkAdapter<IMInterstitialDelegate>{
    IMInterstitial * inmobiInterstitial;
    BOOL isReady;
}

@end
