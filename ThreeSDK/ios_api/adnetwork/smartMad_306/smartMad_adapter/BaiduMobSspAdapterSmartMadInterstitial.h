//
//  BaiduMobSspAdapterAdChinaInterstitial.h
//  BaiduMobSspSample
//
//  Created by dengjinxiang on 14-7-10.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "BaiduMobSspAdNetworkAdapter.h"
#import "SMAdInterstitial.h"

@interface BaiduMobSspAdapterSmartMadInterstitial : BaiduMobSspAdNetworkAdapter<SMAdInterstitialDelegate>{
    SMAdInterstitial *_interstitialView;
    CGRect initAdChinaFrame;
    BOOL isReady;
}

@property(nonatomic,retain)SMAdInterstitial *interstitialView;
@end
