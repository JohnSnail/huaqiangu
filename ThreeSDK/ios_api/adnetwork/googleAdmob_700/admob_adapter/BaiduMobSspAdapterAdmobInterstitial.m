//
//  BaiduMobSspAdapterAdmobInterstitial.m
//  BaiduMobSspSample
//
//  Created by dengjinxiang on 14-7-10.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "BaiduMobSspAdapterAdmobInterstitial.h"
#import "BaiduMobSspInterstitialAdNetworkRegistry.h"
#import "BaiduMobSspInterstitial.h"
#import "BaiduMobSspAdNetworkConfig.h"

@implementation BaiduMobSspAdapterAdmobInterstitial
+ (BaiduMobSspAdNetworkType)networkType{
    return BaiduMobSspAdNetworkTypeAdmob;
}

+ (void)load{
    [[BaiduMobSspInterstitialAdNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    admobInterstitial = [[GADInterstitial alloc] init];
    admobInterstitial.delegate = self;
    admobInterstitial.adUnitID = networkConfig.pubId;;
    GADRequest *request = [GADRequest request];
    request.testDevices = [NSArray arrayWithObjects: nil];
    [admobInterstitial loadRequest:request];
    
}

- (BOOL)isInterstitialReadyPresent
{
    return  admobInterstitial.isReady;
}

- (void)presentInterstitial{
  [admobInterstitial presentFromRootViewController:[self.baiduMobSspInterstitialDelegate viewControllerForPresentingInterstitialModalView]];
}

- (void)stopBeingDelegate {
    if (admobInterstitial != nil) {
        [admobInterstitial setDelegate:nil];
    }
}

- (void)dealloc{
    if (admobInterstitial){
        admobInterstitial.delegate = nil;
        [admobInterstitial release];
        admobInterstitial = nil;
    }
    [super dealloc];
}

#pragma mark Ad Request Lifecycle Notifications

/// Called when an interstitial ad request succeeded. Show it at the next transition point in your
/// application such as when transitioning between view controllers.
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad{
    [baiduMobSspInterstitial  adapter:self didReceiveInterstitial: nil];
}

/// Called when an interstitial ad request completed without an interstitial to
/// show. This is common since interstitials are shown sparingly to users.
- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error{
    [baiduMobSspInterstitial  adapter:self didFailAd:nil];
}

#pragma mark Display-Time Lifecycle Notifications

/// Called just before presenting an interstitial. After this method finishes the interstitial will
/// animate onto the screen. Use this opportunity to stop animations and save the state of your
/// application in case the user leaves while the interstitial is on screen (e.g. to visit the App
/// Store from a link on the interstitial).
- (void)interstitialWillPresentScreen:(GADInterstitial *)ad{
    [baiduMobSspInterstitial  adapter:self willPresentScreen :nil];
}

/// Called before the interstitial is to be animated off the screen.
- (void)interstitialWillDismissScreen:(GADInterstitial *)ad{
    
}

/// Called just after dismissing an interstitial and it has animated off the screen.
- (void)interstitialDidDismissScreen:(GADInterstitial *)ad{
    [baiduMobSspInterstitial  adapter:self didDismissScreen :nil];
}

/// Called just before the application will background or terminate because the user clicked on an
/// ad that will launch another application (such as the App Store). The normal
/// UIApplicationDelegate methods, like applicationDidEnterBackground:, will be called immediately
/// before this.
- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad{

}
@end
