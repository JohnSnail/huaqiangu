//
//  BaiduMobSspAdapterInmobi.m
//  BaiduMobSsp
//
//  Created by dengjinxiang on 14-7-3.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "BaiduMobSspAdapterInmobi.h"
#import "BaiduMobSspAdNetworkConfig.h"
#import "BaiduMobSspBannerView.h"
#import "BaiduMobSspBannerAdNetworkRegistry.h"
#import "BaiduMobSSpCoreController.h"
#import "IMBanner.h"

@implementation BaiduMobSspAdapterInmobi

+ (BaiduMobSspAdNetworkType)networkType{
    return BaiduMobSspAdNetworkTypeInmobi;
}

+ (void)load{
    [[BaiduMobSspBannerAdNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    BaiduMobSspAdViewType type =[coreController adViewType];
    CGRect rect = CGRectZero;
    int sizetype;
    switch (type) {
        case BaiduMobSspAdViewTypeiPadNormalBanner:
        case BaiduMobSspAdViewTypeNormalBanner:
            
            sizetype = IM_UNIT_320x48;
            rect = CGRectMake(0, 0, 320, 48);
            break;
        case BaiduMobSspAdViewTypeRectangle:
        case BaiduMobSspAdViewTypeiPhoneRectangle:
            sizetype = IM_UNIT_300x250;
            rect = CGRectMake(0, 0, 300, 250);
            break;
        case BaiduMobSspAdViewTypeMediumBanner:
            sizetype = IM_UNIT_468x60;
            rect = CGRectMake(0, 0, 468, 60);
            break;
        case BaiduMobSspAdViewTypeLargeBanner:
            
            sizetype = IM_UNIT_728x90;
            rect = CGRectMake(0, 0, 728, 90);
            break;
        default:
            [coreController adapter:self didFailAd:nil];
            return;
            break;
    }
    
    
    [InMobi setLogLevel:IMLogLevelNone];
//    [InMobi setLogLevel:IMLogLevelDebug];
    [InMobi initialize: networkConfig.pubId];
    IMBanner *inmobiAdView = [[IMBanner alloc] initWithFrame:rect appId:networkConfig.pubId adSize:sizetype];
    inmobiAdView.refreshInterval = REFRESH_INTERVAL_OFF;
    inmobiAdView.delegate = self;
    [inmobiAdView loadBanner];
    
    self.adNetworkView = inmobiAdView;
    [inmobiAdView release];
    
}

- (void)stopBeingDelegate {
    IMBanner *inmobiAdView = (IMBanner *)self.adNetworkView;
    if (inmobiAdView != nil) {
        [inmobiAdView setDelegate:nil];
    }
}

#pragma mark - Banner Request Notifications

// Sent when an ad request was successful
- (void)bannerDidReceiveAd:(IMBanner *)banner {
    [coreController adapter:self didReceiveAdView: self.adNetworkView];
}

// Sent when the ad request failed. Please check the error code and
// localizedDescription for more information on wy this occured
- (void)banner:(IMBanner *)banner didFailToReceiveAdWithError:(IMError *)error {
    [coreController adapter:self didFailAd:nil];
}

#pragma mark Banner Interaction Notifications

// Called when the banner is tapped or interacted with by the user
// Optional data is available to publishers to act on when using
// monetization platform to render promotional ads.
-(void)bannerDidInteract:(IMBanner *)banner withParams:(NSDictionary *)dictionary {
    [coreController adapter:self didClick: self.adNetworkView];
}

// Sent just before presenting the user a full screen view, in response to
// tapping on an ad.  Use this opportunity to stop animations, time sensitive
// interactions, etc.
- (void)bannerWillPresentScreen:(IMBanner *)banner {

}

// Sent just before dismissing a full screen view.
- (void)bannerWillDismissScreen:(IMBanner *)banner {

}

// Sent just after dismissing a full screen view.  Use this opportunity to
// restart anything you may have stopped as part of adViewWillPresentScreen:
- (void)bannerDidDismissScreen:(IMBanner *)banner {

}

// Sent just before the application will background or terminate because the
// user clicked on an ad that will launch another application (such as the App
// Store).
- (void)bannerWillLeaveApplication:(IMBanner *)banner {

}

@end
