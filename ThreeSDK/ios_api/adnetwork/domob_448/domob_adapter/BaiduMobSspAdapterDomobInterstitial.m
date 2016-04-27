//
//  BaiduMobSspAdapterDomobInterstitial.m
//  BaiduMobSspSample
//
//  Created by dengjinxiang on 14-7-9.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "BaiduMobSspAdapterDomobInterstitial.h"
#import "BaiduMobSspInterstitialAdNetworkRegistry.h"
#import "BaiduMobSspInterstitial.h"
#import "BaiduMobSspAdNetworkConfig.h"

@implementation BaiduMobSspAdapterDomobInterstitial

+ (BaiduMobSspAdNetworkType)networkType{
    return BaiduMobSspAdNetworkTypeDomob;
}

+ (void)load{
    [[BaiduMobSspInterstitialAdNetworkRegistry sharedRegistry] registerClass:self];
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
        [baiduMobSspInterstitial  adapter:self didFailAd:nil];
        return;
    }
    UIViewController *uiViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if(!uiViewController){
        uiViewController = [self.baiduMobSspInterstitialDelegate viewControllerForPresentingInterstitialModalView];
    }
    if(uiViewController){
        if (domobInterstitial == nil) {
//            switch (type) {
//                case AdViewTypeFullScreen:
//                    domobInterstitial = [[DMInterstitialAdController alloc]
//                                       initWithPublisherId:publishId
//                                       placementId:placementId
//                                       rootViewController:uiViewController
//                                       size:DOMOB_AD_SIZE_300x250];
//                    break;
//                case AdViewTypeiPadFullScreen:
//                    domobInterstitial = [[DMInterstitialAdController alloc]
//                                       initWithPublisherId:publishId
//                                       placementId:placementId
//                                       rootViewController:uiViewController
//                                       size:DOMOB_AD_SIZE_600x500];
//                    break;
//                default:
//                    [baiduMobSspInterstitial  adapter:self didFailAd:nil];
//            }
//            domobInterstitial.delegate = self;
//        }
            domobInterstitial = [[DMInterstitialAdController alloc]
                                 initWithPublisherId:publishId
                                 placementId:placementId
                                 rootViewController:uiViewController
                                 ];
            domobInterstitial.delegate = self;
            [domobInterstitial loadAd];
        }
    }else{
        [baiduMobSspInterstitial  adapter:self didFailAd:nil];
    }
}

- (BOOL)isInterstitialReadyPresent{
    return domobInterstitial.isReady;
}

- (void)presentInterstitial{
    [domobInterstitial present];
}

- (void)stopBeingDelegate {
    if (domobInterstitial != nil) {
        [domobInterstitial setDelegate:nil];
    }
}

- (void)dealloc{
    [domobInterstitial release], domobInterstitial = nil;
    [super dealloc];
}

#pragma mark DoMob Delegate
// 当插屏广告被成功加载后，回调该方法
- (void)dmInterstitialSuccessToLoadAd:(DMInterstitialAdController *)dmInterstitial{
    [baiduMobSspInterstitial  adapter:self didReceiveInterstitial: nil];
}
// 当插屏广告加载失败后，回调该方法
- (void)dmInterstitialFailToLoadAd:(DMInterstitialAdController *)dmInterstitial withError:(NSError *)err{
    [baiduMobSspInterstitial  adapter:self didFailAd:nil];
}

// 当插屏广告要被呈现出来前，回调该方法
- (void)dmInterstitialWillPresentScreen:(DMInterstitialAdController *)dmInterstitial{
  [baiduMobSspInterstitial  adapter:self willPresentScreen :nil];
}
// 当插屏广告被关闭后，回调该方法
- (void)dmInterstitialDidDismissScreen:(DMInterstitialAdController *)dmInterstitial{
  [baiduMobSspInterstitial  adapter:self didDismissScreen :nil];
}

// 当将要呈现出 Modal View 时，回调该方法。如打开内置浏览器。
- (void)dmInterstitialWillPresentModalView:(DMInterstitialAdController *)dmInterstitial{
    
}

// 当呈现的 Modal View 被关闭后，回调该方法。如内置浏览器被关闭。
- (void)dmInterstitialDidDismissModalView:(DMInterstitialAdController *)dmInterstitial{
    
}


// 当因用户的操作（如点击下载类广告，需要跳转到Store），需要离开当前应用时，回调该方法
- (void)dmInterstitialApplicationWillEnterBackground:(DMInterstitialAdController *)dmInterstitial{
    
}

- (void)dmInterstitialDidClicked:(id)dmInterstitial{
   [baiduMobSspInterstitial  adapter:self didAdClick :nil];  
}

@end
