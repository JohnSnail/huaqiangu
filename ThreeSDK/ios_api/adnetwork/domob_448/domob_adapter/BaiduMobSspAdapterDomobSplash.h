//
//  BaiduMobSspAdapterDomobInterstitial.h
//  BaiduMobSspSample
//
//  Created by dengjinxiang on 14-7-9.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "BaiduMobSspAdNetworkAdapter.h"
#import "DMSplashAdController.h"

@interface BaiduMobSspAdapterDomobSplash : BaiduMobSspAdNetworkAdapter<DMSplashAdControllerDelegate>{
    DMSplashAdController *domobSplashAd;
}
+ (BaiduMobSspAdNetworkType)networkType;

@end
