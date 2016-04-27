//
//  BaiduMobSspAdapterAdwo.m
//  BaiduMobSspSample
//
//  Created by dengjinxiang on 14-7-10.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "BaiduMobSspAdapterSmartMad.h"
#import "BaiduMobSspAdNetworkConfig.h"
#import "BaiduMobSspBannerView.h"
#import "BaiduMobSspBannerAdNetworkRegistry.h"
#import "BaiduMobSSpCoreController.h"
#import "AdChinaLocationManager.h"

@implementation BaiduMobSspAdapterSmartMad

+ (BaiduMobSspAdNetworkType)networkType{
    return BaiduMobSspAdNetworkTypeSmartMad;
}

+ (void)load{
    [[BaiduMobSspBannerAdNetworkRegistry sharedRegistry] registerClass:self];
}


- (void)getAd {
    BaiduMobSspAdViewType type =[coreController adViewType];
    SMAdBannerSizeType size = PHONE_AD_BANNER_MEASURE_AUTO;
    switch (type) {
        case BaiduMobSspAdViewTypeiPadNormalBanner:
        case BaiduMobSspAdViewTypeNormalBanner:
            size = PHONE_AD_BANNER_MEASURE_AUTO;
            break;
        case BaiduMobSspAdViewTypeLargeBanner:
            size = TABLET_AD_BANNER_MEASURE_728X90;
            break;
        case BaiduMobSspAdViewTypeMediumBanner:
            size = TABLET_AD_BANNER_MEASURE_468X60;
            break;
        case BaiduMobSspAdViewTypeRectangle:
            size = TABLET_AD_BANNER_MEASURE_300X250;
            break;
        default:
            [coreController adapter:self didFailAd:nil];
            return;
            break;
    }
    NSString *appId = nil;
    NSString *adPos = nil;
    id key = self.networkConfig.credentials;
    if ([key isKindOfClass:[NSDictionary class]]) {
        appId  = [key objectForKey:BMSAdNetworkConfigKeyParam1];
        adPos = [key objectForKey:BMSAdNetworkConfigKeyParam2];
    }
    
    BOOL isLocationOn = NO;
    if (baiduMobSspDelegate && [baiduMobSspDelegate respondsToSelector:@selector(enableLocation)]) {
        isLocationOn = [baiduMobSspDelegate enableLocation];
    }
    [SMAdManager setApplicationId:appId];
//    [SMAdManager setDebugMode:YES];
    [SMAdManager setAdRefreshInterval:1];
    SMAdBannerView *bannerAd = [[SMAdBannerView alloc] initWithAdSpaceId:adPos smAdSize:size];
    bannerAd.delegate = self;
    bannerAd.rootViewController = [baiduMobSspDelegate viewController];
    
//    UIView *containView = [[UIView alloc] init];
//    containView.frame = bannerAd.frame;
//    [containView addSubview:bannerAd];
//    [bannerAd release];
    
    self.adNetworkView = bannerAd;
    [bannerAd release];
}


-(void)stopBeingDelegate{
    UIView *containView = self.adNetworkView;
    if(containView != nil)
    {
//        SMAdBannerView *adView = (SMAdBannerView *)[[containView subviews] lastObject];
        SMAdBannerView *adView = (SMAdBannerView *) containView;
        if (adView != nil) {
            adView.delegate = nil;
            [adView removeFromSuperview];
            adView = nil;
        }
    }
}

#pragma mark - SMAdBannerViewDelegate
/*!
 @method
 @abstract adBannerViewDidReceiveAd取到广告
 @discussion
 @param adView
 @result nil
 */
- (void)adBannerViewDidReceiveAd:(SMAdBannerView*)adView{
    [coreController adapter:self didReceiveAdView: self.adNetworkView];
}

/*!
 @method
 @abstract adBannerView取广告失败
 @discussion
 @param adView
 @param errorCode
 @result nil
 */
- (void)adBannerView:(SMAdBannerView*)adView didFailToReceiveAdWithError:(SMAdEventCode*)errorCode{
    [coreController adapter:self didFailAd:nil];
}

/*!
 @method
 @abstract 即将展示banner广告
 @discussion
 @param adView
 @result nil
 */
- (void)adBannerViewWillPresentScreen:(SMAdBannerView*)adView impressionEventCode:(SMAdEventCode *)eventCode{
    
}

/*!
 @method
 @abstract 即将移出banner广告
 @discussion
 @param adView
 @result nil
 */
- (void)adBannerViewWillDismissScreen:(SMAdBannerView*)adView{
    
}

/*!
 @method
 @abstract 已经移出banner广告
 @discussion
 @param adView
 @result nil
 */
- (void)adBannerViewDidDismissScreen:(SMAdBannerView*)adView{
    
}

/*!
 @method
 @abstract 应用程序被切换到后台
 @discussion
 @param adView
 @result nil
 */
- (void)adBannerViewWillLeaveApplication:(SMAdBannerView*)adView{
    
}

/*!
 @method
 @abstract 广告被点击
 @discussion
 @result nil
 */
- (void)adDidClick{
    [coreController adapter:self didClick: self.adNetworkView];
}

/*!
 @method
 @abstract banner将被expand
 @discussion
 @param adView
 @result nil
 */
- (void)adWillExpandAd:(SMAdBannerView *)adView{
    
}

/*!
 @method
 @abstract expand已经被关闭
 @discussion
 @param adView
 @result nil
 */
- (void)adDidCloseExpand:(SMAdBannerView*)adView{
    
}

/*!
 @method
 @abstract 应用程序即将被挂起
 @discussion
 @param adView
 @result nil
 */
- (void)appWillSuspendForAd:(SMAdBannerView*)adView{
    
}

/*!
 @method
 @abstract 应用程序即将被唤醒
 @discussion
 @param adView
 @result nil
 */
- (void)appWillResumeFromAd:(SMAdBannerView*)adView{
    
}


-(void)dealloc{
    [super dealloc];
}

@end
