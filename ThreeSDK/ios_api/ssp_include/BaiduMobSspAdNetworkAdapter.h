//
//  BaiduMobSspAdNetworkAdapter.h
//  BaiduMobSsp
//
//  Created by dengjinxiang on 14-5-8.
//  Copyright (c) 2014年 baidu. All rights reserved.
//


#import "BaiduMobSspBannerDelegateProtocol.h"
#import "BaiduMobSspInterstitialDelegateProtocol.h"
#import "BaiduMobSspSplashDelegateProtocol.h"

@class BaiduMobSspInterstitial;
@class BaiduMobSspBannerView;
@class BaiduMobSspSplash;
@class BaiduMobSspConfig;
@class BaiduMobSspAdNetworkConfig;
@class BaiduMobSspCoreController;

typedef enum {
    BaiduMobSspAdNetworkTypeBES             = 1,
    BaiduMobSspAdNetworkTypeQiuShi          = 2,
    BaiduMobSspAdNetworkTypeBaidu           = 3,
    BaiduMobSspAdNetworkTypeAdmob           = 4,
    BaiduMobSspAdNetworkTypeDomob           = 5,
    BaiduMobSspAdNetworkTypeMobiSage        = 6,
    BaiduMobSspAdNetworkTypeAdChina         = 7,
    BaiduMobSspAdNetworkTypeAdwo            = 8,
    BaiduMobSspAdNetworkTypeBalintimesO2O   = 9,
    BaiduMobSspAdNetworkTypeInmobi          = 10,
    BaiduMobSspAdNetworkTypeDirect          = 11,
    BaiduMobSspAdNetworkTypeSmartMad        = 12,
    BaiduMobSspAdNetworkTypeIAP             = 13
} BaiduMobSspAdNetworkType;

@interface BaiduMobSspAdNetworkAdapter : NSObject {
    //banner
    id<BaiduMobSspDelegate> baiduMobSspDelegate;
    BaiduMobSspBannerView *baiduMobSspView;
    BaiduMobSspCoreController *coreController;
    
    //插屏
    id<BaiduMobSspInterstitialDelegate>  baiduMobSspInterstitialDelegate;
    BaiduMobSspInterstitial *baiduMobSspInterstitial;
    
    //开屏
    id<BaiduMobSspSplashDelegate> baiduMobSspSplashDelegate;
    BaiduMobSspSplash *baiduMobSspSplash;
    
    UIView *adNetworkView;
    BaiduMobSspAdNetworkConfig *networkConfig;
}

@property (nonatomic,assign) id<BaiduMobSspDelegate> baiduMobSspDelegate;
@property (nonatomic,assign) BaiduMobSspBannerView *baiduMobSspView;
@property (nonatomic,assign) BaiduMobSspCoreController *coreController;

@property (nonatomic,assign) id<BaiduMobSspInterstitialDelegate> baiduMobSspInterstitialDelegate;
@property (nonatomic,assign) BaiduMobSspInterstitial *baiduMobSspInterstitial;

@property (nonatomic,assign) id<BaiduMobSspSplashDelegate> baiduMobSspSplashDelegate;
@property (nonatomic,assign) BaiduMobSspSplash *baiduMobSspSplash;

@property (nonatomic,retain) BaiduMobSspAdNetworkConfig *networkConfig;
@property (nonatomic,retain) UIView *adNetworkView;

/*
 Banner适配器
 */
- (id)initWithBaiduMobSspDelegate:(id<BaiduMobSspDelegate>)delegate
                             view:(BaiduMobSspBannerView *)view
                   coreController:(BaiduMobSspCoreController *)controller
                    networkConfig:(BaiduMobSspAdNetworkConfig *)netConf;

/*
 插屏适配器
 */
- (id)initWithBaiduMobSspInterstitialDelegate:(id<BaiduMobSspInterstitialDelegate>)delegate
                                 interstitial:(BaiduMobSspInterstitial *)interstitial
                                networkConfig:(BaiduMobSspAdNetworkConfig *)netConf;

/*
 开屏适配器
 */
- (id)initWithBaiduMobSspSplashDelegate:(id<BaiduMobSspSplashDelegate>)delegate
                                 splash:(BaiduMobSspSplash *)splash
                          networkConfig:(BaiduMobSspAdNetworkConfig *)netConf;


//请求广告，需子类化实现
- (void)getAd;


- (void)stopBeingDelegate;

/**
 * Subclasses return YES to ask BaiduMobSspView to send metric requests to the
 * BaiduMobSsp server for ad impressions. Default is YES.
 */
- (BOOL)shouldSendExMetric;

/**
 * 是否发送view的点击，如果有点击回调的话，设置为NO
 */
- (BOOL)shouldReportViewClick;

/**
 * Tell the adapter that the interface orientation changed or is about to change
 */
- (void)rotateToOrientation:(UIInterfaceOrientation)orientation;

/**
 * Some ad transition types may cause issues with particular ad networks. The
 * adapter should know whether the given animation type is OK. Defaults to
 * YES.
 */
//- (BOOL)isBannerAnimationOK:(BMSBannerAnimationType)animType;

/**
 * 展示插屏
 */
- (void)presentInterstitial;

/**
 * 是否可以展示插屏
 */
- (BOOL)isInterstitialReadyPresent;

@end
