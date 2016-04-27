//
//  BaiduMobSspAdapterMobiSageInterstitial.m
//  BaiduMobSspSample
//
//  Created by dengjinxiang on 14-7-9.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "BaiduMobSspAdapterMobiSageInterstitial.h"
#import "BaiduMobSspInterstitialAdNetworkRegistry.h"
#import "BaiduMobSspInterstitial.h"
#import "BaiduMobSspAdNetworkConfig.h"

@implementation BaiduMobSspAdapterMobiSageInterstitial
+ (BaiduMobSspAdNetworkType)networkType{
    return BaiduMobSspAdNetworkTypeMobiSage;
}

+ (void)load{
    [[BaiduMobSspInterstitialAdNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    isReady = NO;
    NSString *publishID = nil;
    NSString *slotTokenBanner = nil;
    id key = self.networkConfig.credentials;
    if ([key isKindOfClass:[NSDictionary class]]) {
        publishID  = [key objectForKey:BMSAdNetworkConfigKeyParam1];
        slotTokenBanner = [key objectForKey:BMSAdNetworkConfigKeyParam2];
    }
    [[MobiSageManager getInstance] setPublisherID:publishID deployChannel:@"" auditFlag:@""];
    floatWindow=[[MobiSageFloatWindow alloc] initWithAdSize:Float_size_3 delegate:self slotToken: slotTokenBanner];
}

- (void)presentInterstitial{
    [floatWindow showAdvView];
}

- (BOOL)isInterstitialReadyPresent{
    return isReady;
}

- (void)stopBeingDelegate {
    floatWindow.delegate = nil;
}

- (void)dealloc{
    if (floatWindow) {
        [floatWindow release];
        floatWindow = nil;
    }
    [super dealloc];
}
#pragma mobiSage delegate method  implement
- (void)mobiSageFloatClick:(MobiSageFloatWindow*)adFloat{
    [baiduMobSspInterstitial  adapter:self didAdClick :nil];
}

- (void)mobiSageFloatClose:(MobiSageFloatWindow*)adFloat{
}

- (void)mobiSageFloatSuccessToRequest:(MobiSageFloatWindow*)adFloat{
    isReady = YES;
    [baiduMobSspInterstitial  adapter:self didReceiveInterstitial: nil];
}

- (void)mobiSageFloatFaildToRequest:(MobiSageFloatWindow*)adFloat withError:(NSError*) error{
    [baiduMobSspInterstitial  adapter:self didFailAd:nil];
}
@end
