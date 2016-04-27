//
//  BaiduMobSspAdapterAdChinaInterstitial.m
//  BaiduMobSspSample
//
//  Created by dengjinxiang on 14-7-10.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "BaiduMobSspAdapterAdChinaSplash.h"
#import "BaiduMobSspSplashAdNetworkRegistry.h"
#import "BaidumobsspSplash.h"
#import "BaiduMobSspAdNetworkConfig.h"

@implementation BaiduMobSspAdapterAdChinaSplash
@synthesize fullScreenAd = _fullScreenAd;

+ (BaiduMobSspAdNetworkType)networkType{
    return BaiduMobSspAdNetworkTypeAdChina;
}

+ (void)load{
    [[BaiduMobSspSplashAdNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    NSString *pid = networkConfig.pubId;
    self.fullScreenAd = [AdChinaFullScreenView requestAdWithAdSpaceId:pid delegate:self];
}

- (void)stopBeingDelegate {
    if (_fullScreenAd) {
        [_fullScreenAd removeFromSuperview];
        _fullScreenAd = nil;
    }
    
}

#pragma mark adChina delegate
- (void)didGetFullScreenAd:(AdChinaFullScreenView *)adView{
    UIViewController *baseviewController =  [baiduMobSspSplashDelegate viewControllerForPresentingInterstitialModalView];
    if (baseviewController.navigationController != nil ) {
        baseviewController = baseviewController.navigationController;
        if ([[[UIDevice currentDevice] systemVersion] intValue]<7) {
            _fullScreenAd.frame = CGRectMake(0.0, 20.0, _fullScreenAd.frame.size.width, _fullScreenAd.frame.size.height);
        }
    }
    [_fullScreenAd setViewControllerForBrowser:baseviewController];
    [baseviewController.view addSubview:_fullScreenAd];
    [baiduMobSspSplash adapter:self didSuccessAd:nil];
}

- (void)didFailToGetFullScreenAd:(AdChinaFullScreenView *)adView{
    [baiduMobSspSplash adapter:self didFailAd:nil];
}


- (void)didClickFullScreenAd:(AdChinaFullScreenView *)adView{
    
}

- (void)didFinishWatchingFullScreenAd:(AdChinaFullScreenView *)adView{
    UIViewController *baseviewController =  [baiduMobSspSplashDelegate viewControllerForPresentingInterstitialModalView];
    if (baseviewController.navigationController != nil) {
        baseviewController = baseviewController.navigationController;
    }
    CGRect rect = baseviewController.view.frame;
    [_fullScreenAd removeFromSuperview];
    baseviewController.view.frame = rect;
    _fullScreenAd = nil;
    [baiduMobSspSplash adapter:self didDismissScreen:nil];
}


- (void)didBeginBrowsingAdWeb:(AdChinaFullScreenView *)fsView {
    
}

- (void)didFinishBrowsingAdWeb:(AdChinaFullScreenView *)fsView {
	
}

- (void)dealloc{
    
    [super dealloc];
}

@end
