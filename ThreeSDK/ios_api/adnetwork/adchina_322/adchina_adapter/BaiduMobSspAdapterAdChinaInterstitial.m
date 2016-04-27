//
//  BaiduMobSspAdapterAdChinaInterstitial.m
//  BaiduMobSspSample
//
//  Created by dengjinxiang on 14-7-10.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "BaiduMobSspAdapterAdChinaInterstitial.h"
#import "BaiduMobSspInterstitialAdNetworkRegistry.h"
#import "BaiduMobSspInterstitial.h"
#import "BaiduMobSspAdNetworkConfig.h"

@implementation BaiduMobSspAdapterAdChinaInterstitial
@synthesize interstitialView = _interstitialView;

+ (BaiduMobSspAdNetworkType)networkType{
    return BaiduMobSspAdNetworkTypeAdChina;
}

+ (void)load{
    [[BaiduMobSspInterstitialAdNetworkRegistry sharedRegistry] registerClass:self];
}

- (BOOL)isInterstitialReadyPresent{
    return isReady;
}

//需要调用到getad，表示已经获取过config
- (void)getAd {
    isReady = YES;
}

- (void)presentInterstitial{
    NSString *pid = networkConfig.pubId;
    self.interstitialView = [AdChinaInterstitialView requestAdWithAdSpaceId:pid delegate:self];
    [self.interstitialView setViewControllerForBrowser:[baiduMobSspDelegate viewController]];
}

- (void)didGetInterstitialAd:(AdChinaInterstitialView *)adView
{
    [baiduMobSspInterstitial adapter:self didReceiveInterstitial:nil];
    UIViewController *baseviewController = nil;
    if ([UIApplication sharedApplication].keyWindow.rootViewController) {
        baseviewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    }else{
        baseviewController= [baiduMobSspDelegate viewController];
    }
    
    if ([[UIDevice currentDevice].systemVersion intValue]<7 &&
        baseviewController.navigationController &&
        [UIScreen mainScreen].bounds.size.height-(44+20)!=baseviewController.view.bounds.size.height) {
        self.interstitialView.frame = CGRectMake(0.0, 20.0, self.interstitialView.frame.size.width, self.interstitialView.frame.size.height);
    }else if([[UIDevice currentDevice].systemVersion intValue]<7){
        self.interstitialView.frame = CGRectMake(0.0, 20.0, self.interstitialView.frame.size.width, self.interstitialView.frame.size.height);
    }
    initAdChinaFrame = baseviewController.view.bounds;
    [baseviewController.view addSubview:self.interstitialView];
    [baiduMobSspInterstitial adapter:self successPresentScreen:nil];
}

- (void)didFailToGetInterstitialAd:(AdChinaInterstitialView *)adView
{
    [baiduMobSspInterstitial adapter:self didFailAd:nil];
}

- (void)didCloseInterstitialAd:(AdChinaInterstitialView *)adView
{
    UIViewController *baseviewController = nil;
    if ([UIApplication sharedApplication].keyWindow.rootViewController) {
        baseviewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    }else{
        baseviewController= [baiduMobSspDelegate viewController];
    }
    CGRect rect = baseviewController.view.frame;
    [_interstitialView removeFromSuperview];
    baseviewController.view.frame = rect;
    
    _interstitialView = nil;
    [baiduMobSspInterstitial adapter:self didDismissScreen:nil];
}

// Called when user opens an in-app web browser
// You may use this method to pause game animation, music, etc.
- (void)didEnterFullScreenMode
{
    
}
-(void)didExitFullScreenMode
{
    if ([[UIDevice currentDevice].systemVersion intValue]<7) {
        UIViewController *baseviewController = nil;
        if ([UIApplication sharedApplication].keyWindow.rootViewController) {
            baseviewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        }else{
            baseviewController= [baiduMobSspDelegate viewController];
        }
        if (baseviewController.navigationController) {
            self.interstitialView.frame = CGRectMake(0.0, 20.0, self.interstitialView.frame.size.width, self.interstitialView.frame.size.height);
        }
        
    }
}

// You may use these methods to count click number by yourself
- (void)didClickInterstitialView:(AdChinaInterstitialView *)adView
{
    [baiduMobSspInterstitial adapter:self didAdClick:nil];
}

- (void)stopBeingDelegate
{
    if (self.interstitialView) {
        [_interstitialView removeFromSuperview];
        _interstitialView = nil;
    }
}

- (void)dealloc{
    
    [super dealloc];
}

@end
