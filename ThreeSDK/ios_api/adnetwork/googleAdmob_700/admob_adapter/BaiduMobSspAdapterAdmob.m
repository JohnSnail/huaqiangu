//
//  BaiduMobSspAdapterAdmob.m
//  BaiduMobSspSample
//
//  Created by dengjinxiang on 14-7-10.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "BaiduMobSspAdapterAdmob.h"
#import "BaiduMobSspAdNetworkConfig.h"
#import "BaiduMobSspBannerView.h"
#import "BaiduMobSspBannerAdNetworkRegistry.h"
#import "BaiduMobSSpCoreController.h"
#import <GoogleMobileAds/GADBannerView.h>

@implementation BaiduMobSspAdapterAdmob

+ (BaiduMobSspAdNetworkType)networkType{
    return BaiduMobSspAdNetworkTypeAdmob;
}

+ (void)load{
    [[BaiduMobSspBannerAdNetworkRegistry sharedRegistry] registerClass:self];
}


- (void)getAd {
    GADRequest *request = [GADRequest request];
    
    BaiduMobSspAdViewType type =[coreController adViewType];
    GADAdSize size = kGADAdSizeBanner;
    switch (type) {
        case BaiduMobSspAdViewTypeNormalBanner:
        case BaiduMobSspAdViewTypeiPadNormalBanner:
            size = kGADAdSizeBanner;
            break;
        case BaiduMobSspAdViewTypeRectangle:
        case BaiduMobSspAdViewTypeiPhoneRectangle:
            size = kGADAdSizeMediumRectangle;
            break;
        case BaiduMobSspAdViewTypeMediumBanner:
            size = kGADAdSizeFullBanner;
            break;
        case BaiduMobSspAdViewTypeLargeBanner:
            size = kGADAdSizeLeaderboard;
            break;
        default:
            [coreController adapter:self didFailAd:nil];
            return;
            break;
    }
    
	GADBannerView *view = [[GADBannerView alloc] initWithAdSize:size];
	
	view.adUnitID = networkConfig.pubId;
	view.delegate = self;
	view.rootViewController =
	[baiduMobSspDelegate viewController];
    
    self.adNetworkView = view;
    [view release];
	[view loadRequest:request];

}

- (void)stopBeingDelegate {
    GADBannerView *admobAdView = (GADBannerView *)self.adNetworkView;
    if (admobAdView != nil) {
        [admobAdView setDelegate:nil];
    }
}

#pragma mark Ad Request Lifecycle Notifications
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    [coreController adapter:self didReceiveAdView: self.adNetworkView];
}

- (void)adView:(GADBannerView *)adView didFailToReceiveAdWithError:(GADRequestError *)error {
    [coreController adapter:self didFailAd:nil];
}

#pragma mark Click-Time Lifecycle Notifications
- (void)adViewWillPresentScreen:(GADBannerView *)adView {
    
}

- (void)adViewDidDismissScreen:(GADBannerView *)adView {

}

-(BOOL)shouldReportViewClick
{
    return YES;
}

@end
