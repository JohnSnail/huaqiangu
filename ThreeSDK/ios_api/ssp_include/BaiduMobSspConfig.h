//
//  BaiduMobSspConfig.h
//  BaiduMobSsp
//
//  Created by dengjinxiang on 14-5-13.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class BaiduMobSspConfig;
@protocol BaiduMobSspConfigDelegate<NSObject>

@optional
- (void)baiduMobSspConfigDidReceiveConfig:(BaiduMobSspConfig *)config;
- (void)baiduMobSspConfigDidFail:(BaiduMobSspConfig *)config error:(NSError *)error;
- (NSURL *)baiduMobSspConfigURL;

@end

typedef enum {
    BMSBannerAnimationTypeNone           = 0,
    BMSBannerAnimationTypeFlipFromLeft   = 1,
    BMSBannerAnimationTypeFlipFromRight  = 2,
    BMSBannerAnimationTypeCurlUp         = 3,
    BMSBannerAnimationTypeCurlDown       = 4,
    BMSBannerAnimationTypeSlideFromLeft  = 5,
    BMSBannerAnimationTypeSlideFromRight = 6,
    BMSBannerAnimationTypeFadeIn         = 7,
    BMSBannerAnimationTypeRandom         = 8,
} BMSBannerAnimationType;

@class BaiduMobSspAdNetworkConfig;
@class BaiduMobSspAdNetworkRegistry;

@interface BaiduMobSspConfig : NSObject {
    NSString *appKey;
    NSURL *configURL;
    
    BOOL adsAreOff;
    
    NSMutableArray *adNetworkConfigs;
    NSMutableArray *otherAdNetworkConfigs;
    
    UIColor *backgroundColor;
    UIColor *textColor;
    NSTimeInterval refreshInterval;
    BOOL locationOn;
    BMSBannerAnimationType bannerAnimationType;
    NSInteger fullscreenWaitInterval;
    NSInteger fullscreenMaxAds;
    
    NSMutableArray *delegates;
    BOOL hasConfig;
    
    BaiduMobSspAdNetworkRegistry *adNetworkRegistry;
    
    NSInteger adType;
    NSInteger configFileMaxAge;
    NSString* sid;
}

- (id)initWithAppKey:(NSString *)ak delegate:(id<BaiduMobSspConfigDelegate>)delegate;
- (BOOL)parseConfig:(NSData *)data error:(NSError **)error;
- (BOOL)addDelegate:(id<BaiduMobSspConfigDelegate>)delegate;
- (BOOL)removeDelegate:(id<BaiduMobSspConfigDelegate>)delegate;
- (void)notifyDelegatesOfFailure:(NSError *)error;

@property (nonatomic,readonly) NSString* sid;
@property (nonatomic,readonly) NSString *appKey;
@property (nonatomic,readonly) NSURL *configURL;

@property (nonatomic,readonly) BOOL hasConfig;
@property (nonatomic,readonly) BOOL parseFail;
@property (nonatomic,readonly) BOOL adsAreOff;
//当前采用的流量策略，由于iap广告对于付费用户会替换策略，每次更新策略都会修改adNetworkConfigs和otherAdNetworkConfigs
@property (nonatomic,retain) NSMutableArray *adNetworkConfigs;
@property (nonatomic,retain) NSMutableArray *otherAdNetworkConfigs;
//服务器返回的原始流量策略，iap广告对于付费用户会替换策略，所以需要保存服务器端第一次返回的adNetworkConfigs和otherAdNetworkConfigs的原始配置数据
@property (nonatomic,retain) NSMutableArray *originAdNetworkConfigs;
@property (nonatomic,retain) NSMutableArray *originOtherAdNetworkConfigs;
@property (nonatomic,readonly) UIColor *backgroundColor;
@property (nonatomic,readonly) UIColor *textColor;
@property (nonatomic,readonly) NSTimeInterval refreshInterval;
@property (nonatomic,readonly) BOOL locationOn;
@property (nonatomic,readonly) BMSBannerAnimationType bannerAnimationType;
@property (nonatomic,readonly) NSInteger fullscreenWaitInterval;
@property (nonatomic,readonly) NSInteger fullscreenMaxAds;

@property (nonatomic,assign) BaiduMobSspAdNetworkRegistry *adNetworkRegistry;
@property (nonatomic,readonly) NSInteger adType;
@property (nonatomic,readonly) NSInteger configFileMaxAge;

@end



