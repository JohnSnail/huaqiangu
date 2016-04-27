//
//  BaiduMobSspAdapterBalintimesInterstitial.m
//  BaiduMobSsp
//
//  Created by dengjinxiang on 14-7-2.
//  Copyright (c) 2014年 baidu. All rights reserved.
//
#import "BaiduMobSspSplashAdNetworkRegistry.h"
#import "BaiduMobSspAdapterBalintimesSplash.h"
#import "BaiduMobSspSplash.h"
#import "BaiduMobSspAdNetworkConfig.h"
#import "BOAD.h"

@implementation BaiduMobSspAdapterBalintimesSplash

+ (BaiduMobSspAdNetworkType)networkType{
    return BaiduMobSspAdNetworkTypeBalintimesO2O;
}

+ (void)load{
    [[BaiduMobSspSplashAdNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    NSString *apikey = nil;
    NSString *apiSecret = nil;
    id key = self.networkConfig.credentials;
    if ([key isKindOfClass:[NSDictionary class]]) {
        apikey  = [key objectForKey:BMSAdNetworkConfigKeyParam1];
        apiSecret = [key objectForKey:BMSAdNetworkConfigKeyParam2];
    } else {
        [baiduMobSspSplash adapter:self didFailAd:nil];
        return;
    }
    
    [BOAD setAppId:apikey appScrect:apiSecret];
    boadInterstitial = [[BOADInterstitial alloc] init];
    boadInterstitial.delegate = self;
    [boadInterstitial loadStartAdUsingWindow:[baiduMobSspSplash splashWindow] defaultImage:[self getBackgroundImageName]];
}

- (UIImage *)getBackgroundImageName
{
    NSString *imageName = [self.baiduMobSspSplash getBackgroundImageName];
    UIImage *backgroundImage = nil;
    if (imageName) {
        backgroundImage = [UIImage imageNamed:imageName];
    }
    
    return backgroundImage;
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
    //加载完成
    [baiduMobSspSplash adapter:self didSuccessAd:interstitial];
    [interstitial presentFromViewController:[baiduMobSspSplashDelegate viewControllerForPresentingInterstitialModalView]];
}

- (void)boadInterstitial:(BOADInterstitial *)interstitial didFailToReceiveAdWithError:(NSError *)error
{
    [baiduMobSspSplash adapter:self didFailAd:error];
}

- (void)boadInterstitialWillPresentScreen:(BOADInterstitial *)interstitial
{
    [baiduMobSspSplash adapter:self willPresentScreen:interstitial];
}

- (void)boadInterstitialDidPresentScreen:(BOADInterstitial *)interstitial
{
    [baiduMobSspSplash adapter:self didPresentScreen:interstitial];
}

- (void)boadInterstitialWillDismissScreen:(BOADInterstitial *)interstitial
{
    [baiduMobSspSplash adapter:self willDismissScreen:interstitial];
}

- (void)boadInterstitialDidDismissScreen:(BOADInterstitial *)interstitial
{
    [baiduMobSspSplash adapter:self didDismissScreen :nil];
}

@end
