//
//  BaiduMobSspAdapterMobiSage.m
//  BaiduMobSspSample
//
//  Created by dengjinxiang on 14-7-9.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "BaiduMobSspAdapterMobiSage.h"
#import "BaiduMobSspBannerAdNetworkRegistry.h"
#import "BaiduMobSspAdNetworkConfig.h"
#import "BaiduMobSspBannerView.h"
#import "BaiduMobSSpCoreController.h"

@implementation BaiduMobSspAdapterMobiSage

+ (BaiduMobSspAdNetworkType)networkType{
    return BaiduMobSspAdNetworkTypeMobiSage;
}

+ (void)load{
    [[BaiduMobSspBannerAdNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    BaiduMobSspAdViewType type =[coreController adViewType];
    
    NSString *publishID = nil;
    NSString *slotTokenBanner = nil;
    id key = self.networkConfig.credentials;
    if ([key isKindOfClass:[NSDictionary class]]) {
        publishID  = [key objectForKey:BMSAdNetworkConfigKeyParam1];
        slotTokenBanner = [key objectForKey:BMSAdNetworkConfigKeyParam2];
    }
    [[MobiSageManager getInstance] setPublisherID:publishID deployChannel:@"" auditFlag:@""];
    
    UIView *view = nil;
    MobiSageBanner *adView = nil;
    switch (type) {
        case BaiduMobSspAdViewTypeNormalBanner:
        case BaiduMobSspAdViewTypeiPadNormalBanner:
            //创建MobiSage横幅广告
            adView = [[MobiSageBanner alloc] initWithDelegate:self
                                                       adType:MSAdBannerType_iPhone
                                                    slotToken:slotTokenBanner
                                                 intervalTime:Ad_NO_Refresh
                                              switchAnimeType:noAnime];
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,320.0, 50.0)];
            break;
        case BaiduMobSspAdViewTypeLargeBanner:
            adView = [[MobiSageBanner alloc] initWithDelegate:self
                                                       adType:MSAdBannerType_iPhone
                                                    slotToken:slotTokenBanner
                                                 intervalTime:Ad_NO_Refresh
                                              switchAnimeType:noAnime];
            break;
        default:
            [coreController adapter:self didFailAd:nil];
            return;
            break;
    }
    
    [view addSubview:adView];
    self.adNetworkView = view;
    [adView release];
    [view release];
}

- (void)stopBeingDelegate {
    MobiSageBanner *_adView = (MobiSageBanner *)[[self.adNetworkView subviews] lastObject];
	if (_adView != nil) {
        _adView.delegate = nil;
    }
}

#pragma Mobisage delegate
/**
 * 描述：当SDK需要弹出自带的Browser以显示mini site, in app purchase时需要使用当前广告所在的控制器。
 * 返回：一个视图控制器对象
 * 说明：如果没有实现此回调，将使用keyWindow.rootViewController
 */
- (UIViewController*)viewControllerToPresent{
    UIViewController *rootCon = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (rootCon == nil) {
        rootCon = [baiduMobSspDelegate viewController];
    }
    return rootCon;
}

/**
 *  adBanner被点击
 *  @param adBanner
 */
- (void)mobiSageBannerClick:(MobiSageBanner*)adBanner{
    [coreController adapter:self didClick: self.adNetworkView];
}
/**
 *  adBanner请求成功并展示广告
 *  @param adBanner
 */
- (void)mobiSageBannerSuccessToShowAd:(MobiSageBanner*)adBanner{
    [coreController adapter:self didReceiveAdView: self.adNetworkView];
}

/**
 *  adBanner请求失败
 *  @param adBanner
 */
- (void)mobiSageBannerFaildToShowAd:(MobiSageBanner*)adBanner withError:(NSError*) error{
    [coreController adapter:self didFailAd:nil];
}

/**
 *  adBanner被点击后弹出LandingPage
 *  @param adBanner
 */
- (void)mobiSageBannerPopADWindow:(MobiSageBanner*)adBanner{
}

/**
 *  adBanner弹出的LandingPage被关闭
 *  @param adBanner
 */
- (void)mobiSageBannerHideADWindow:(MobiSageBanner*)adBanner{
}

@end
