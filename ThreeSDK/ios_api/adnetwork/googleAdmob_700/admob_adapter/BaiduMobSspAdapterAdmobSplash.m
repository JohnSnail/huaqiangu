//
//  BaiduMobSspAdapterAdmobInterstitial.m
//  BaiduMobSspSample
//
//  Created by dengjinxiang on 14-7-10.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "BaiduMobSspAdapterAdmobSplash.h"
#import "BaiduMobSspSplashAdNetworkRegistry.h"
#import "BaiduMobSspSplash.h"
#import "BaiduMobSspAdNetworkConfig.h"

@implementation BaiduMobSspAdapterAdmobSplash
+ (BaiduMobSspAdNetworkType)networkType{
    return BaiduMobSspAdNetworkTypeAdmob;
}

+ (void)load{
    [[BaiduMobSspSplashAdNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    admobSplash = [[GADInterstitial alloc] init];
    admobSplash.delegate = self;
    admobSplash.adUnitID = networkConfig.pubId;;
    GADRequest *request = [GADRequest request];
    request.testDevices = [NSArray arrayWithObjects: nil];
//    [admobSplash loadAndDisplayRequest:request usingWindow:[baiduMobSspSplash splashWindow] initialImage:[self getBackgroundImage]];
    [admobSplash loadRequest:request];
    
}

- (UIImage *)getBackgroundImage{
    NSString *imageName = [baiduMobSspSplash getBackgroundImageName];
    UIImage *backgroundImage = nil;
    if (imageName) {
        backgroundImage = [UIImage imageNamed:imageName];
    }
    return backgroundImage;
}

- (void)stopBeingDelegate {
    if (admobSplash != nil) {
        [admobSplash setDelegate:nil];
    }
}

- (void)dealloc{
    if (admobSplash) {
        admobSplash.delegate = nil;
        [admobSplash release];
        admobSplash = nil;
    }
    [super dealloc];
}

#pragma mark Ad Request Lifecycle Notifications

/// Called when an interstitial ad request succeeded. Show it at the next transition point in your
/// application such as when transitioning between view controllers.
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad{
    [baiduMobSspSplash adapter:self didSuccessAd:nil];
}

/// Called when an interstitial ad request completed without an interstitial to
/// show. This is common since interstitials are shown sparingly to users.
- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error{
    [baiduMobSspSplash adapter:self didFailAd:nil];
}

#pragma mark Display-Time Lifecycle Notifications

/// Called just before presenting an interstitial. After this method finishes the interstitial will
/// animate onto the screen. Use this opportunity to stop animations and save the state of your
/// application in case the user leaves while the interstitial is on screen (e.g. to visit the App
/// Store from a link on the interstitial).
- (void)interstitialWillPresentScreen:(GADInterstitial *)ad{
    [baiduMobSspSplash adapter:self willPresentScreen :nil];
}

/// Called before the interstitial is to be animated off the screen.
- (void)interstitialWillDismissScreen:(GADInterstitial *)ad{
    [baiduMobSspSplash adapter:self willDismissScreen:nil];
}

/// Called just after dismissing an interstitial and it has animated off the screen.
- (void)interstitialDidDismissScreen:(GADInterstitial *)ad{
    [baiduMobSspSplash adapter:self didDismissScreen:nil];
}

/// Called just before the application will background or terminate because the user clicked on an
/// ad that will launch another application (such as the App Store). The normal
/// UIApplicationDelegate methods, like applicationDidEnterBackground:, will be called immediately
/// before this.
- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad{

}
@end
