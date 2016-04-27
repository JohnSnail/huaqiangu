//
//  BaiduMobSspAdapterMobiSageInterstitial.m
//  BaiduMobSspSample
//
//  Created by dengjinxiang on 14-7-9.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "BaiduMobSspAdapterMobiSageSplash.h"
#import "BaiduMobSspSplashAdNetworkRegistry.h"
#import "BaiduMobSspSplash.h"
#import "BaiduMobSspAdNetworkConfig.h"

@implementation BaiduMobSspAdapterMobiSageSplash
+ (BaiduMobSspAdNetworkType)networkType{
    return BaiduMobSspAdNetworkTypeMobiSage;
}

+ (void)load{
    [[BaiduMobSspSplashAdNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    NSString *publishID = nil;
    NSString *slotTokenBanner = nil;
    id key = self.networkConfig.credentials;
    if ([key isKindOfClass:[NSDictionary class]]) {
        publishID  = [key objectForKey:BMSAdNetworkConfigKeyParam1];
        slotTokenBanner = [key objectForKey:BMSAdNetworkConfigKeyParam2];
    }
    [[MobiSageManager getInstance] setPublisherID:publishID deployChannel:@"" auditFlag:@""];
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            mobiSageSplash = [[MobiSageRTSplash alloc] initWithOrientation:MS_Orientation_Landscape
                                                                  background:[self getBackgroundColor] withDelegate:self
                                                                   slotToken:slotTokenBanner];
        
    }else{
        mobiSageSplash = [[MobiSageRTSplash alloc] initWithOrientation:MS_Orientation_Portrait
                                                              background:[self getBackgroundColor] withDelegate:self
                                                               slotToken:slotTokenBanner];
    }
    
    [mobiSageSplash startSplash];
}

- (UIColor *)getBackgroundColor{
    NSString *imageName = [self.baiduMobSspSplash getBackgroundImageName];
    UIImage *backgroundImage = nil;
    if (imageName) {
        backgroundImage = [UIImage imageNamed:imageName];
    }
    UIColor* bgColor = [UIColor colorWithPatternImage:backgroundImage];
    return bgColor;
}

- (void)stopBeingDelegate {
    
}

- (void)dealloc{
    if (mobiSageSplash) {
        mobiSageSplash.delegate = nil;
        [mobiSageSplash release];
        mobiSageSplash = nil;
    }
    [super dealloc];
}

#pragma mark - MobiSageSplashDelegate

//开屏广告展示成功时,回调此方法
- (void)mobiSageSplashSuccessToShow:(MobiSageSplash *)adSplash{
    [baiduMobSspSplash adapter:self didSuccessAd:adSplash];
}

//开屏广告展示失败时,回调此方法,在此回调方法中,需释放广告,且在此时弹出应用的界面
- (void)mobiSageSplashFaildToRequest:(MobiSageSplash *)adSplash withError:(NSError *)error{
    [baiduMobSspSplash adapter:self didFailAd:error];
}

//开屏广告关闭时,回调此方法,需释放广告,且在此时弹出应用的界面
- (void)mobiSageSplashClose:(MobiSageSplash*)adSplash{
    [baiduMobSspSplash adapter:self didDismissScreen:adSplash];
}

@end
