//
//  BaiduMobSspAdapterBaiduInterstitial.m
//  BaiduMobSsp
//
//  Created by dengjinxiang on 14-7-2.
//  Copyright (c) 2014年 baidu. All rights reserved.
//
#import "BaiduMobSspSplashAdNetworkRegistry.h"
#import "BaiduMobSspAdapterBaiduSplash.h"
#import "BaiduMobSspSplash.h"
#import "BaiduMobSspAdNetworkConfig.h"

@implementation BaiduMobSspAdapterBaiduSplash
@synthesize baiduMobAdSplash = _baiduMobAdSplash;

+ (BaiduMobSspAdNetworkType)networkType{
    return BaiduMobSspAdNetworkTypeBaidu;
}

+ (void)load{
    [[BaiduMobSspSplashAdNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    self.baiduMobAdSplash = [[[BaiduMobAdSplash alloc] init] autorelease];
    self.baiduMobAdSplash.delegate = self;
    self.baiduMobAdSplash.canSplashClick = YES;
    self.baiduMobAdSplash.useCache = NO;
    self.baiduMobAdSplash.AdUnitTag = [baiduMobSspSplashDelegate baiduMobSspSplashApplicationKey];
    [self.baiduMobAdSplash loadAndDisplayUsingKeyWindow:[baiduMobSspSplash splashWindow]];
    [[NSUserDefaults standardUserDefaults]setObject:networkConfig.pubId forKey:@"kBaiduMobSspAdAppsid"];

    self.baiduMobAdSplash.backgroundColor = [UIColor colorWithPatternImage:[self getBackgroundImageName]];
}

- (UIImage *)getBackgroundImageName
{
    NSString *imageName = [self.baiduMobSspSplash getBackgroundImageName];
    UIImage *backgroundImage = nil;
    if (imageName) {
        backgroundImage = [UIImage imageNamed:imageName];
    }
    
    return backgroundImage;
}

- (void)stopBeingDelegate {
    if (_baiduMobAdSplash != nil) {
        [_baiduMobAdSplash setDelegate:nil];
    }
}

- (void)dealloc{
    [_baiduMobAdSplash release], _baiduMobAdSplash = nil;
    [super dealloc];
}

#pragma mark - BaiduSplashDelegate
- (NSString *)publisherId{
    return networkConfig.pubId;
}

- (NSString*) channelId{
    return kBaiduMobSspChannelId;
}

/**
 *  广告展示成功
 */
- (void)splashSuccessPresentScreen:(BaiduMobAdSplash *)splash
{
    [baiduMobSspSplash adapter:self didSuccessAd:splash ];
    [baiduMobSspSplash adapter:self didPresentScreen:splash];
}

/**
 *  广告展示失败
 */
- (void)splashlFailPresentScreen:(BaiduMobAdSplash *)splash withError:(BaiduMobFailReason) reason
{
    [baiduMobSspSplash adapter:self didFailAd:nil];
}

/**
 *  广告展示结束
 */
- (void)splashDidDismissScreen:(BaiduMobAdSplash *)splash
{
    [baiduMobSspSplash adapter:self didDismissScreen :nil];
}

@end
