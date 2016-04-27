//
//  BaiduMobSspAdapterAdChinaInterstitial.m
//  BaiduMobSspSample
//
//  Created by dengjinxiang on 14-7-10.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "BaiduMobSspAdapterSmartMadInterstitial.h"
#import "BaiduMobSspInterstitialAdNetworkRegistry.h"
#import "BaiduMobSspInterstitial.h"
#import "BaiduMobSspAdNetworkConfig.h"

@implementation BaiduMobSspAdapterSmartMadInterstitial
@synthesize interstitialView = _interstitialView;

+ (BaiduMobSspAdNetworkType)networkType{
    return BaiduMobSspAdNetworkTypeSmartMad;
}

+ (void)load{
    [[BaiduMobSspInterstitialAdNetworkRegistry sharedRegistry] registerClass:self];
}

- (BOOL)isInterstitialReadyPresent{
    return isReady;
}

- (void)getAd {
    isReady = NO;
    
    NSString *appId = nil;
    NSString *adPos = nil;
    id key = self.networkConfig.credentials;
    if ([key isKindOfClass:[NSDictionary class]]) {
        appId  = [key objectForKey:BMSAdNetworkConfigKeyParam1];
        adPos = [key objectForKey:BMSAdNetworkConfigKeyParam2];
    }
    [SMAdManager setApplicationId:appId];
//    [SMAdManager setDebugMode:YES];
    self.interstitialView = [[[SMAdInterstitial alloc] initWithAdSpaceId:adPos] autorelease];
    self.interstitialView.delegate = self;
    [self.interstitialView requestAd];
}

- (void)presentInterstitial{
    UIViewController *rootViewController = [baiduMobSspInterstitialDelegate viewControllerForPresentingInterstitialModalView];
    [self.interstitialView presentFromRootViewController:rootViewController];
}

- (void)stopBeingDelegate {
    if (self.interstitialView) {
        self.interstitialView.delegate = nil;
        self.interstitialView = nil;
    }
}

#pragma mark - SMAdInterstitialDelegate

/*!
 @method
 @abstract 收到插页广告
 @discussion
 @param ad
 @result nil
 */
- (void)adInterstitialDidReceiveAd:(SMAdInterstitial*)ad{
    if ([baiduMobSspInterstitialDelegate viewControllerForPresentingInterstitialModalView]) {
        isReady = YES;
        [baiduMobSspInterstitial adapter:self didReceiveInterstitial:ad];
    }
    else{
        [baiduMobSspInterstitial adapter:self didFailAd:nil];
    }
}

/*!
 @method
 @abstract 插页广告获取失败
 @discussion
 @param adview
 @param errorCode
 @result nil
 */
- (void)adInterstitial:(SMAdInterstitial*)adview didFailToReceiveAdWithError:(SMAdEventCode*)errorCode{
    [baiduMobSspInterstitial adapter:self didFailAd:nil];
}

/*!
 @method
 @abstract 插页广告被点击
 @discussion
 @result nil
 */
- (void)adInterstitialDidClick{
    [baiduMobSspInterstitial adapter:self didAdClick:nil];
}


/*!
 @method
 @abstract 插页广告将被展示
 @discussion
 @param ad
 @result nil
 */
- (void)adInterstitialWillPresentScreen:(SMAdInterstitial*)ad{
    [baiduMobSspInterstitial adapter:self successPresentScreen:ad];
}

/*!
 @method
 @abstract 插页广告将被移出
 @discussion
 @param ad
 @result nil
 */
- (void)adInterstitialWillDismissScreen:(SMAdInterstitial*)ad{
    
}

/*!
 @method
 @abstract 插页广告已经被移出
 @discussion
 @param ad
 @result nil
 */
- (void)adInterstitialDidDismissScreen:(SMAdInterstitial*)ad{
    [baiduMobSspInterstitial adapter:self didDismissScreen:ad];
}

/*!
 @method
 @abstract 应用程序切换到后台
 @discussion
 @param ad
 @result nil
 */
- (void)adInterstitialWillLeaveApplication:(SMAdInterstitial*)ad{
}


- (void)dealloc{
    
    [super dealloc];
}

@end
