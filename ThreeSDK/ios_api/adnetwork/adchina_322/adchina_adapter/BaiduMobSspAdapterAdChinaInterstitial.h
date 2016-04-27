//
//  BaiduMobSspAdapterAdChinaInterstitial.h
//  BaiduMobSspSample
//
//  Created by dengjinxiang on 14-7-10.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "BaiduMobSspAdNetworkAdapter.h"
#import "AdChinaInterstitialView.h"
#import "AdChinaInterstitialViewDelegateProtocol.h"

@interface BaiduMobSspAdapterAdChinaInterstitial : BaiduMobSspAdNetworkAdapter<AdChinaInterstitialViewDelegate>{
    AdChinaInterstitialView *_interstitialView;
    CGRect initAdChinaFrame;
    BOOL isReady;
}

@property(nonatomic,retain)AdChinaInterstitialView *interstitialView;
@end
