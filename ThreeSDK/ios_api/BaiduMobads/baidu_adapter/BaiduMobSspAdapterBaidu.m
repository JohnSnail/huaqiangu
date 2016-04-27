//
//  BaiduMobSspAdapterBaidu.m
//  BaiduMobSsp
//
//  Created by dengjinxiang on 14-6-9.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "BaiduMobSspAdapterBaidu.h"
#import "BaiduMobSspAdNetworkConfig.h"
#import "BaiduMobSspBannerView.h"
#import "BaiduMobSspBannerAdNetworkRegistry.h"
#import "BaiduMobSSpCoreController.h"
#import "BaiduMobSspCommonConfig.h"

@implementation BaiduMobSspAdapterBaidu

+ (BaiduMobSspAdNetworkType)networkType{
    return BaiduMobSspAdNetworkTypeBaidu;
}

+ (void)load{
    [[BaiduMobSspBannerAdNetworkRegistry sharedRegistry] registerClass:self];
}

- (NSString *)publisherId{
    return networkConfig.pubId;
}

- (NSString*) appSpec{
    return networkConfig.pubId;
}

- (NSString*) channelId{
    return kBaiduMobSspChannelId;
}

- (void)getAd {
//    CGRect frame = CGRectMake(0,0,self.baiduMobSspView.frame.size.width, self.baiduMobSspView.frame.size.height);
//    BaiduMobAdView * baiduAdView = [[BaiduMobAdView alloc]initWithFrame:frame];
//    [baiduAdView autorelease];
//    baiduAdView.autoplayEnabled = NO;
//    baiduAdView.delegate = self;
//    self.adNetworkView = baiduAdView;
//    [baiduAdView start];
    BaiduMobSspAdViewType type =[coreController adViewType];
    CGSize size = CGSizeZero;
    
    switch (type) {
        case BaiduMobSspAdViewTypeNormalBanner:
            size = kBaiduAdViewBanner320x48;
            break;
        case BaiduMobSspAdViewTypeiPhoneRectangle:
            size = kBaiduAdViewSquareBanner300x250;
            break;
        case BaiduMobSspAdViewTypeMediumBanner:
            size = kBaiduAdViewBanner468x60;
            break;
        case BaiduMobSspAdViewTypeLargeBanner:
            size = kBaiduAdViewBanner728x90;
            break;
        case BaiduMobSspAdViewTypeiPadNormalBanner:
            size = kBaiduAdViewBanner768x110;
            break;
        case BaiduMobSspAdViewTypeRectangle:
            size = kBaiduAdViewSquareBanner600x500;
            break;
        default:
            [coreController adapter:self didFailAd:nil];
            return;
            break;
    }
    
    BaiduMobAdView* sBaiduAdview = [[[BaiduMobAdView alloc] init] autorelease];
    sBaiduAdview.hidden = YES;
    sBaiduAdview.autoplayEnabled = NO;
    sBaiduAdview.frame = CGRectMake(0.0,0.0,size.width,size.height);
    
    sBaiduAdview.AdUnitTag = [baiduMobSspDelegate baiduMobSspApplicationKey];
    [[NSUserDefaults standardUserDefaults]setObject:networkConfig.pubId forKey:@"kBaiduMobSspAdAppsid"];
    
    sBaiduAdview.delegate = self;
    [sBaiduAdview start];
    
    self.adNetworkView = sBaiduAdview;
}

- (void)stopBeingDelegate {
    BaiduMobAdView *baiduAdView = (BaiduMobAdView *)self.adNetworkView;
    if (baiduAdView != nil) {
        [baiduAdView setDelegate:nil];
    }
}

#pragma mark Ad Request Lifecycle Notifications
-(void) willDisplayAd:(BaiduMobAdView*) adview{
    
}

-(void) failedDisplayAd:(BaiduMobFailReason) reason{
    [coreController adapter:self didFailAd:nil];
}

-(void) didAdImpressed{
    [coreController adapter:self didReceiveAdView: self.adNetworkView];
}

-(void) didAdClicked{
    [coreController adapter:self didClick: self.adNetworkView];
}

-(void) didDismissLandingPage{
//    [self helperNotifyDelegateOfFullScreenModalDismissal];
}

#pragma mark parameter gathering methods
-(BOOL) enableLocation{
    if ([baiduMobSspDelegate respondsToSelector:@selector(enableLocation)]) {
        return [baiduMobSspDelegate enableLocation];
    }
    return NO;
}

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
    //7代表未知
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
