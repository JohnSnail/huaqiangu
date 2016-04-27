//
//  BaiduMobSspAdapterDomob.m
//  BaiduMobSspSample
//
//  Created by dengjinxiang on 14-7-9.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "BaiduMobSspAdapterDomob.h"
#import "BaiduMobSspAdNetworkConfig.h"
#import "BaiduMobSspBannerView.h"
#import "BaiduMobSspBannerAdNetworkRegistry.h"
#import "BaiduMobSSpCoreController.h"

@implementation BaiduMobSspAdapterDomob
+ (BaiduMobSspAdNetworkType)networkType{
    return BaiduMobSspAdNetworkTypeDomob;
}

+ (void)load{
    [[BaiduMobSspBannerAdNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    BaiduMobSspAdViewType type =[coreController adViewType];
    CGSize size = CGSizeZero;
    switch (type) {
        case BaiduMobSspAdViewTypeNormalBanner:
        case BaiduMobSspAdViewTypeiPadNormalBanner:
            size = DOMOB_AD_SIZE_320x50;
            break;
        case BaiduMobSspAdViewTypeiPhoneRectangle:
            size = DOMOB_AD_SIZE_300x250;
            break;
        case BaiduMobSspAdViewTypeMediumBanner:
            size = DOMOB_AD_SIZE_488x80;
            break;
        case BaiduMobSspAdViewTypeRectangle:
            size = DOMOB_AD_SIZE_600x500;
            break;
        case BaiduMobSspAdViewTypeLargeBanner:
            size = DOMOB_AD_SIZE_728x90;
            break;
        default:
            [coreController adapter:self didFailAd:nil];
            return;
            break;
    }
    NSString *publishId = nil;
    NSString *placementId = nil;
    id key = self.networkConfig.credentials;
    if ([key isKindOfClass:[NSDictionary class]]) {
        publishId  = [key objectForKey:BMSAdNetworkConfigKeyParam1];
        placementId = [key objectForKey:BMSAdNetworkConfigKeyParam2];
    }
    else{
        [coreController adapter:self didFailAd:nil];
    }

    DMAdView* dmAdView = [[DMAdView alloc] initWithPublisherId:publishId
                                         placementId:placementId
                                         autorefresh:NO];
    [dmAdView setAdSize:size];
    [dmAdView setFrame:CGRectMake(0.0, 0.0, size.width, size.height)];
    
    dmAdView.rootViewController = [baiduMobSspDelegate viewController];
    dmAdView.delegate = self;
    self.adNetworkView = dmAdView;
    [dmAdView release];
    [dmAdView loadAd];
}

- (void)stopBeingDelegate {
    DMAdView *domobAdView = (DMAdView *)self.adNetworkView;
    if (domobAdView != nil) {
        [domobAdView setDelegate:nil];
        domobAdView.rootViewController = nil;
    }
}
#pragma mark domob delegate method
// Sent when an ad request success to loaded an ad
- (void)dmAdViewSuccessToLoadAd:(DMAdView *)adView{
    [coreController adapter:self didReceiveAdView: self.adNetworkView];
}
// Sent when an ad request fail to loaded an ad
- (void)dmAdViewFailToLoadAd:(DMAdView *)adView withError:(NSError *)error{
    [coreController adapter:self didFailAd:nil];
}
// Sent when the ad view is clicked
- (void)dmAdViewDidClicked:(DMAdView *)adView{
    [coreController adapter:self didClick: self.adNetworkView];
}
// Sent just before presenting the user a modal view
- (void)dmWillPresentModalViewFromAd:(DMAdView *)adView{
    
}
// Sent just after dismissing the modal view
- (void)dmDidDismissModalViewFromAd:(DMAdView *)adView{
    
}
// Sent just before the application will background or terminate because the user's action
// (Such as the user clicked on an ad that will launch App Store).
- (void)dmApplicationWillEnterBackgroundFromAd:(DMAdView *)adView{
    
}

@end
