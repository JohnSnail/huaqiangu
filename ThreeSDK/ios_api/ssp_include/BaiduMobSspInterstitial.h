//
//  BaiduMobSspInterstitial.h
//  BaiduMobSsp
//
//  Created by dengjinxiang on 14-6-15.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "BaiduMobSspInterstitialDelegateProtocol.h"

@class BaiduMobSspAdNetworkAdapter;

@interface BaiduMobSspInterstitial : NSObject

/**
 * delegate委托提供应用id，并且监听广告生命周期中的重要信息
 */
@property (nonatomic, assign) IBOutlet id<BaiduMobSspInterstitialDelegate> delegate;
/**
 * 插屏是否请求完成可以展示：返回YES代表插屏准备好可展示，返回NO代表不能展示
 */
@property (nonatomic, readonly) BOOL isInterstitialReady;

/**
 * 创建实例
 */
- (BaiduMobSspInterstitial *)initWithDelegate:(id<BaiduMobSspInterstitialDelegate>)delegate;
/**
 * 加载插屏
 */
- (void)load;
/**
 * 展示插屏
 */
- (void)present;

#pragma mark For ad network adapters use only
- (void)adapter:(BaiduMobSspAdNetworkAdapter *)adapter didReceiveInterstitial:(id)interstitial;
- (void)adapter:(BaiduMobSspAdNetworkAdapter *)adapter didFailAd:(NSError *)error;
- (void)adapterDidFinishAdRequest:(BaiduMobSspAdNetworkAdapter *)adapter;

- (void)adapter:(BaiduMobSspAdNetworkAdapter *)adapter willPresentScreen:(id)interstitialAd;
- (void)adapter:(BaiduMobSspAdNetworkAdapter *)adapter successPresentScreen:(id)interstitialAd;
- (void)adapter:(BaiduMobSspAdNetworkAdapter *)adapter failPresentScreen:(id)interstitialAd;
- (void)adapter:(BaiduMobSspAdNetworkAdapter *)adapter didAdClick:(id)interstitialAd;
- (void)adapter:(BaiduMobSspAdNetworkAdapter *)adapter didDismissScreen:(id)interstitialAd;
- (void)adapter:(BaiduMobSspAdNetworkAdapter *)adapter didIAPClick:(id)interstitialAd productID:(NSString *)productId;

@end

