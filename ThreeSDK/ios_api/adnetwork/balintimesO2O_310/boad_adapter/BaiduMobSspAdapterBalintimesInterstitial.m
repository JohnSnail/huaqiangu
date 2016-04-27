//
//  BaiduMobSspAdapterBalintimesInterstitial.m
//  BaiduMobSsp
//
//  Created by dengjinxiang on 14-7-2.
//  Copyright (c) 2014年 baidu. All rights reserved.
//
#import "BaiduMobSspInterstitialAdNetworkRegistry.H"
#import "BaiduMobSspAdapterBalintimesInterstitial.h"
#import "BaiduMobSspInterstitial.h"
#import "BaiduMobSspAdNetworkConfig.h"
#import "BOAD.h"

@implementation BaiduMobSspAdapterBalintimesInterstitial

+ (BaiduMobSspAdNetworkType)networkType{
    return BaiduMobSspAdNetworkTypeBalintimesO2O;
}

+ (void)load{
    [[BaiduMobSspInterstitialAdNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    //百灵欧拓请求成功直接展示
    isReady = YES;
}

- (BOOL)isInterstitialReadyPresent{
    return isReady;
}

- (void)presentInterstitial{
    UIViewController *uiViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if(!uiViewController){
        uiViewController = [self.baiduMobSspInterstitialDelegate viewControllerForPresentingInterstitialModalView];
    }
    if (uiViewController) {
        NSString *apikey = nil;
        NSString *apiSecret = nil;
        id key = self.networkConfig.credentials;
        if ([key isKindOfClass:[NSDictionary class]]) {
            apikey  = [key objectForKey:BMSAdNetworkConfigKeyParam1];
            apiSecret = [key objectForKey:BMSAdNetworkConfigKeyParam2];
        }
        else{
            [baiduMobSspInterstitial adapter:self didFailAd:nil];
        }
        [BOAD setAppId:apikey appScrect:apiSecret];
        [BOAD setLogEnabled:NO];
        boadInterstitial = [[BOADInterstitial alloc] init];
        boadInterstitial.delegate = self;
        [boadInterstitial loadFloatAd];
    }
}

- (void)stopBeingDelegate {
    if (boadInterstitial != nil) {
        [boadInterstitial setDelegate:nil];
    }
}

- (void)dealloc{
    [boadInterstitial release], boadInterstitial = nil;
    [super dealloc];
}

#pragma mark - BOADInterstitialDelegate
- (void)boadInterstitialWillLoadAd:(BOADInterstitial *)interstitial {

}

- (void)boadInterstitialDidLoadAd:(BOADInterstitial *)interstitial {
    [baiduMobSspInterstitial adapter:self didReceiveInterstitial:nil];
}

- (void)boadInterstitial:(BOADInterstitial *)interstitial didFailToReceiveAdWithError:(NSError *)error {
    [baiduMobSspInterstitial  adapter:self didFailAd:nil];
}

- (void)boadInterstitialWillPresentScreen:(BOADInterstitial *)interstitial {
    [baiduMobSspInterstitial  adapter:self willPresentScreen :nil];
}

- (void)boadInterstitialDidPresentScreen:(BOADInterstitial *)interstitial {
    [baiduMobSspInterstitial  adapter:self successPresentScreen :nil];
}

- (void)boadInterstitialWillDismissScreen:(BOADInterstitial *)interstitial {

}

- (void)boadInterstitialDidDismissScreen:(BOADInterstitial *)interstitial {
    [baiduMobSspInterstitial  adapter:self didDismissScreen :nil];
}

@end
