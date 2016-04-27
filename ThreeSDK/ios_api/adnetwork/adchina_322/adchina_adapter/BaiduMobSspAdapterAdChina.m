//
//  BaiduMobSspAdapterAdwo.m
//  BaiduMobSspSample
//
//  Created by dengjinxiang on 14-7-10.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "BaiduMobSspAdapterAdChina.h"
#import "BaiduMobSspAdNetworkConfig.h"
#import "BaiduMobSspBannerView.h"
#import "BaiduMobSspBannerAdNetworkRegistry.h"
#import "BaiduMobSSpCoreController.h"
#import "AdChinaLocationManager.h"

@implementation BaiduMobSspAdapterAdChina

+ (BaiduMobSspAdNetworkType)networkType{
    return BaiduMobSspAdNetworkTypeAdChina;
}

+ (void)load{
    [[BaiduMobSspBannerAdNetworkRegistry sharedRegistry] registerClass:self];
}


- (void)getAd {
    BaiduMobSspAdViewType type =[coreController adViewType];
    CGSize size = CGSizeZero;
    switch (type) {
        case BaiduMobSspAdViewTypeNormalBanner:
            size = BannerSizeDefault;
            break;
        case BaiduMobSspAdViewTypeLargeBanner:
            size = BannerSizeDefault;
            break;
        case BaiduMobSspAdViewTypeRectangle:
            size = BannerSizeSquare;
            break;
        default:
            [coreController adapter:self didFailAd:nil];
            return;
            break;
    }
    NSString *pid = networkConfig.pubId;
    BOOL isLocationOn = NO;
    if (baiduMobSspDelegate && [baiduMobSspDelegate respondsToSelector:@selector(enableLocation)]) {
        isLocationOn = [baiduMobSspDelegate enableLocation];
    }
    [AdChinaLocationManager setLocationServiceEnabled:isLocationOn];
    AdChinaBannerView *bannerAd = [AdChinaBannerView requestAdWithAdSpaceId:pid delegate:self adSize:size];
    [bannerAd setViewControllerForBrowser:[baiduMobSspDelegate viewController]];
    bannerAd.frame = CGRectMake(0, 0, size.width, size.height);
    [bannerAd setRefreshInterval:DisableRefresh];
    self.adNetworkView = bannerAd;
}


-(void)stopBeingDelegate{
    AdChinaBannerView *adView = (AdChinaBannerView *)self.adNetworkView;
    if(adView != nil)
    {
        [adView setViewControllerForBrowser:nil];
        [self.adNetworkView removeFromSuperview];
    }
}

#pragma mark AdChinaDelegate required methods
#pragma mark Banner
- (void)didReceiveAd:(AdChinaBannerView *)adView {
    [coreController adapter:self didReceiveAdView:self.adNetworkView];
}
- (void)didFailedToReceiveAd:(AdChinaBannerView *)adView{
    [coreController adapter:self didFailAd:nil];
}

-(void)didClickBanner:(AdChinaBannerView *)adView
{
    [coreController adapter:self didClick:self.adNetworkView];
}

- (void)didEnterFullScreenMode {
    
}

- (void)didExitFullScreenMode {
    
}


-(void)dealloc{
    [super dealloc];
}

@end
