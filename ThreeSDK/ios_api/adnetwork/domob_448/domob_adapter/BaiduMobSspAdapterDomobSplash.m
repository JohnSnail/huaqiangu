//
//  BaiduMobSspAdapterDomobInterstitial.m
//  BaiduMobSspSample
//
//  Created by dengjinxiang on 14-7-9.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "BaiduMobSspAdapterDomobSplash.h"
#import "BaiduMobSspSplashAdNetworkRegistry.h"
#import "BaiduMobSspSplash.h"
#import "BaiduMobSspAdNetworkConfig.h"

@implementation BaiduMobSspAdapterDomobSplash

+ (BaiduMobSspAdNetworkType)networkType{
    return BaiduMobSspAdNetworkTypeDomob;
}

+ (void)load{
    [[BaiduMobSspSplashAdNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    NSString *publishId = nil;
    NSString *placementId = nil;
    id key = self.networkConfig.credentials;
    if ([key isKindOfClass:[NSDictionary class]]) {
        publishId  = [key objectForKey:BMSAdNetworkConfigKeyParam1];
        placementId = [key objectForKey:BMSAdNetworkConfigKeyParam2];
    }
    else{
        [baiduMobSspSplash adapter:self didFailAd:nil];
        return;
    }
    domobSplashAd = [[DMSplashAdController alloc] initWithPublisherId:publishId placementId:placementId window:[self.baiduMobSspSplash splashWindow] background:[self getBackgroundImageName]];
    domobSplashAd.rootViewController = [self.baiduMobSspSplashDelegate viewControllerForPresentingInterstitialModalView];
    domobSplashAd.delegate = self;
    [domobSplashAd present];
}

- (UIColor *)getBackgroundImageName
{
    NSString *imageName = [self.baiduMobSspSplash getBackgroundImageName];
    UIImage *backgroundImage = nil;
    if (imageName) {
        backgroundImage = [UIImage imageNamed:imageName];
    }
    
    return [UIColor colorWithPatternImage:backgroundImage];
}


- (void)stopBeingDelegate {
    if (domobSplashAd != nil) {
        [domobSplashAd setDelegate:nil];
    }
}

- (void)dealloc{
    if (domobSplashAd) {
        domobSplashAd.delegate = nil;
        [domobSplashAd release],
        domobSplashAd = nil;
    }
    [super dealloc];
}

#pragma mark DoMob Delegate
// Sent when an splash ad request success to loaded an ad
- (void)dmSplashAdSuccessToLoadAd:(DMSplashAdController *)dmSplashAd
{
    [baiduMobSspSplash adapter:self didSuccessAd:dmSplashAd];
}
// Sent when an ad request fail to loaded an ad
- (void)dmSplashAdFailToLoadAd:(DMSplashAdController *)dmSplashAd withError:(NSError *)err
{
    [baiduMobSspSplash adapter:self didFailAd:err];
}

// Sent just before presenting an splash ad view
- (void)dmSplashAdWillPresentScreen:(DMSplashAdController *)dmSplashAd
{
    [baiduMobSspSplash adapter:self willPresentScreen:dmSplashAd];
}
// Sent just after dismissing an splash ad view
- (void)dmSplashAdDidDismissScreen:(DMSplashAdController *)dmSplashAd
{
    [baiduMobSspSplash adapter:self didDismissScreen:dmSplashAd];
}

@end
