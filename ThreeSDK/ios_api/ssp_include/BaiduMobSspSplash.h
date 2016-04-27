//
//  BaiduMobSspInterstitial.h
//  BaiduMobSsp
//
//  Created by dengjinxiang on 14-6-15.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "BaiduMobSspSplashDelegateProtocol.h"

@class BaiduMobSspAdNetworkAdapter;

@interface BaiduMobSspSplash : NSObject

/**
 * delegate委托提供应用id，并且监听广告生命周期中的重要信息
 */
@property (nonatomic, assign) id<BaiduMobSspSplashDelegate> delegate;

/**
 * 创建实例
 */
- (BaiduMobSspSplash *)initWithDelegate:(id<BaiduMobSspSplashDelegate>)delegate window:(UIWindow *)window;
/**
 * 请求开屏广告
 */
- (void)requestSplashAd;

/*
 * 开屏使用的window对象
 */
- (UIWindow *)splashWindow;

/*
 返回开屏背景图片
 */
- (NSString *)getBackgroundImageName;

#pragma mark For ad network adapters use only
- (void)adapter:(BaiduMobSspAdNetworkAdapter *)adapter didSuccessAd:(NSObject *)splashAd;
- (void)adapter:(BaiduMobSspAdNetworkAdapter *)adapter didFailAd:(NSError *)error;

- (void)adapter:(BaiduMobSspAdNetworkAdapter *)adapter willPresentScreen:(id)splashAd;
- (void)adapter:(BaiduMobSspAdNetworkAdapter *)adapter didPresentScreen:(id)splashAd;
- (void)adapter:(BaiduMobSspAdNetworkAdapter *)adapter willDismissScreen:(id)splashAd;
- (void)adapter:(BaiduMobSspAdNetworkAdapter *)adapter didDismissScreen:(id)splashAd;

@end

