//
//  BaiduMobSspAdapterBaiduInterstitial.m
//  BaiduMobSsp
//
//  Created by dengjinxiang on 14-6-12.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "BaiduMobSspAdapterBaiduInterstitial.h"
#import "BaiduMobSspInterstitialAdNetworkRegistry.h"
#import "BaiduMobSspInterstitial.h"
#import "BaiduMobSspAdNetworkConfig.h"
#import "BaiduMobSspCommonConfig.h"

@implementation BaiduMobSspAdapterBaiduInterstitial

+ (BaiduMobSspAdNetworkType)networkType{
    return BaiduMobSspAdNetworkTypeBaidu;
}

+ (void)load{
    [[BaiduMobSspInterstitialAdNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    baiduInterstitial = [[BaiduMobAdInterstitial alloc] init];
    baiduInterstitial.delegate = self;
    
    baiduInterstitial.AdUnitTag = [baiduMobSspInterstitialDelegate baiduMobSspInterstitialApplicationKey];
    [[NSUserDefaults standardUserDefaults]setObject:networkConfig.pubId forKey:@"kBaiduMobSspAdAppsid"];

    [baiduInterstitial load];
}

- (BOOL)isInterstitialReadyPresent
{
    return  baiduInterstitial.isReady;
}

- (void)presentInterstitial{
    // 呈现插屏广告
    [baiduInterstitial presentFromRootViewController:[self.baiduMobSspInterstitialDelegate viewControllerForPresentingInterstitialModalView]];
}

- (void)stopBeingDelegate {
    if (baiduInterstitial != nil) {
        [baiduInterstitial setDelegate:nil];
    }
}

- (void)dealloc{
    [baiduInterstitial release], baiduInterstitial = nil;
    [super dealloc];
}

- (NSString *)publisherId{
    return networkConfig.pubId;
}

- (NSString*) appSpec{
    return networkConfig.pubId;
}

- (NSString*) channelId
{
    return kBaiduMobSspChannelId;
}

#pragma mark Ad Request Lifecycle Notifications
- (void)interstitialSuccessToLoadAd:(BaiduMobAdInterstitial *)interstitial{
    [baiduMobSspInterstitial  adapter:self didReceiveInterstitial: nil];
}

- (void)interstitialFailToLoadAd:(BaiduMobAdInterstitial *)interstitial{
    [baiduMobSspInterstitial  adapter:self didFailAd:nil];
}

- (void)interstitialWillPresentScreen:(BaiduMobAdInterstitial *)interstitial{
    [baiduMobSspInterstitial  adapter:self willPresentScreen :nil];
}

- (void)interstitialSuccessPresentScreen:(BaiduMobAdInterstitial *)interstitial{
    [baiduMobSspInterstitial  adapter:self successPresentScreen :nil];

}

- (void)interstitialFailPresentScreen:(BaiduMobAdInterstitial *)interstitial withError:(BaiduMobFailReason) reason{
//  百度插屏
    [baiduMobSspInterstitial  adapter:self didFailAd:nil];
}

- (void)interstitialDidAdClicked:(BaiduMobAdInterstitial *)interstitial{
    [baiduMobSspInterstitial  adapter:self didAdClick :nil];
}

- (void)interstitialDidDismissScreen:(BaiduMobAdInterstitial *)interstitial{
    [baiduMobSspInterstitial  adapter:self didDismissScreen :nil];

}

#pragma mark parameter gathering methods
-(BOOL) enableLocation{
    if ([baiduMobSspDelegate respondsToSelector:@selector(enableLocation)]) {
        return [baiduMobSspDelegate enableLocation];
    }
    return NO;
}

//人群属性
-(NSArray*) keywords{
    if ([baiduMobSspDelegate respondsToSelector:@selector(keywords)]) {
        return [baiduMobSspDelegate keywords];
    }
    return nil;
}

-(BaiduMobAdUserGender) userGender{
    BaiduMobAdUserGender gender = BaiduMobAdSexUnknown;
    if ([baiduMobSspDelegate respondsToSelector:@selector(userGender)]) {
       BaiduMobSspUserGender tempGender = [baiduMobSspDelegate userGender];
        switch (tempGender) {
            case BaiduMobSspMale:
                gender = BaiduMobAdMale;
                break;
            case BaiduMobSspFeMale:
                gender = BaiduMobAdFeMale;
                break;
            default:
                break;
        }
    }
    return gender;
}

-(NSDate*) userBirthday{
    if ([baiduMobSspDelegate respondsToSelector:@selector(userBirthday)]) {
        return [baiduMobSspDelegate userBirthday];
    }
    return nil;
}

-(NSString*) userCity{
    if ([baiduMobSspDelegate respondsToSelector:@selector(userCity)]) {
        return [baiduMobSspDelegate userCity];
    }
    return nil;
}

-(NSString*) userPostalCode{
    if ([baiduMobSspDelegate respondsToSelector:@selector(userPostalCode)]) {
        return [baiduMobSspDelegate userPostalCode];
    }
    return nil;
}

-(NSString*) userWork{
    if ([baiduMobSspDelegate respondsToSelector:@selector(userWork)]) {
        return [baiduMobSspDelegate userWork];
    }
    return nil;
}

-(NSInteger) userEducation{
    if ([baiduMobSspDelegate respondsToSelector:@selector(userEducation)]) {
        return [baiduMobSspDelegate userEducation];
    }
    return 7;
}

-(NSInteger) userSalary{
    if ([baiduMobSspDelegate respondsToSelector:@selector(userSalary)]) {
        return [baiduMobSspDelegate userSalary];
    }
    return 0;
}

-(NSArray*) userHobbies{
    if ([baiduMobSspDelegate respondsToSelector:@selector(userHobbies)]) {
        return [baiduMobSspDelegate userHobbies];
    }
    return nil;
}

-(NSDictionary*) userOtherAttributes{
    if ([baiduMobSspDelegate respondsToSelector:@selector(userOtherAttributes)]) {
        return [baiduMobSspDelegate userOtherAttributes];
    }
    return nil;
}

@end
