//
//  BaiduMobSspAdapterAdmobInterstitial.h
//  BaiduMobSspSample
//
//  Created by dengjinxiang on 14-7-10.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "BaiduMobSspAdNetworkAdapter.h"
#import <GoogleMobileAds/GADInterstitial.h>
#import <GoogleMobileAds/GADInterstitialDelegate.h>

@interface BaiduMobSspAdapterAdmobInterstitial : BaiduMobSspAdNetworkAdapter<GADInterstitialDelegate>{
    GADInterstitial *admobInterstitial;
}


@end
