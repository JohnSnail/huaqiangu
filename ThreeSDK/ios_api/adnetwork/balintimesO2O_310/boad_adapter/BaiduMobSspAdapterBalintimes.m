//
//  BaiduMobSspAdapterBalintimes.m
//  BaiduMobSsp
//
//  Created by dengjinxiang on 14-7-2.
//  Copyright (c) 2014年 baidu. All rights reserved.
//
#import "BOAD.h"
#import "BaiduMobSspAdNetworkConfig.h"
#import "BaiduMobSspBannerView.h"
#import "BaiduMobSspBannerAdNetworkRegistry.h"
#import "BaiduMobSSpCoreController.h"
#import "BaiduMobSspAdapterBalintimes.h"

@implementation BaiduMobSspAdapterBalintimes

+ (BaiduMobSspAdNetworkType)networkType{
    return BaiduMobSspAdNetworkTypeBalintimesO2O;
}

+ (void)load{
    [[BaiduMobSspBannerAdNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    BaiduMobSspAdViewType type =[coreController adViewType];
    BOADAdSize adSize ;
    switch (type) {
        case BaiduMobSspAdViewTypeNormalBanner:
            adSize =BOADAdSizeBanner;
            break;
        case BaiduMobSspAdViewTypeLargeBanner:
            adSize =BOADAdSizeLeaderboard;
            break;
        default:
            [self stopBeingDelegate];
            [coreController adapter:self didFailAd:nil];
            return;
            break;
    }
    
    NSString *apikey = nil;
    NSString *apiSecret = nil;
    id key = self.networkConfig.credentials;
    if ([key isKindOfClass:[NSDictionary class]]) {
        apikey  = [key objectForKey:BMSAdNetworkConfigKeyParam1];
        apiSecret = [key objectForKey:BMSAdNetworkConfigKeyParam2];
    }
    else{
        [coreController adapter:self didFailAd:nil];
    }
    [BOAD setAppId:apikey appScrect:apiSecret];
    [BOAD setLogEnabled:NO]; //Open DEBUG
    BOADBannerView* bannerView = [[[BOADBannerView alloc] initWithAdSize:adSize]autorelease];
    bannerView.delegate = self;// 可以设置委托对象，监听广告状态
    bannerView.manualRefresh=YES;
    [bannerView loadAd];
    self.adNetworkView=bannerView;
}

- (void)stopBeingDelegate {
    BOADBannerView *boadAdView = (BOADBannerView *)self.adNetworkView;
    if (boadAdView != nil) {
        [boadAdView setDelegate:nil];
    }
}


#pragma mark - BOADBannerViewDelegate
- (void)boadBannerViewWillLoadAd:(BOADBannerView *)bannerView {
    
}

- (void)boadBannerViewDidLoadAd:(BOADBannerView *)bannerView {
    [coreController adapter:self didReceiveAdView: self.adNetworkView];
}

- (void)boadBannerViewDidTapAd:(BOADBannerView *)bannerView {
    [coreController adapter:self didClick: self.adNetworkView];
}

- (void)boadBannerView:(BOADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    [coreController adapter:self didFailAd:nil];
}

@end
