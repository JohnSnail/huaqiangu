//
//  BaiduMobSspAdapterInmobiInterstitial.m
//  BaiduMobSspSample
//
//  Created by dengjinxiang on 14-7-8.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "BaiduMobSspAdapterInmobiInterstitial.h"
#import "BaiduMobSspInterstitialAdNetworkRegistry.h"
#import "BaiduMobSspInterstitial.h"
#import "BaiduMobSspAdNetworkConfig.h"

@implementation BaiduMobSspAdapterInmobiInterstitial
+ (BaiduMobSspAdNetworkType)networkType{
    return BaiduMobSspAdNetworkTypeInmobi;
}

+ (void)load{
    [[BaiduMobSspInterstitialAdNetworkRegistry sharedRegistry] registerClass:self];
}

- (BOOL)isInterstitialReadyPresent
{
    return isReady;
}

- (void)getAd {
    isReady = NO;
    [InMobi setLogLevel:IMLogLevelDebug];
    [InMobi initialize:networkConfig.pubId];
    
    inmobiInterstitial = [[IMInterstitial alloc] initWithAppId:networkConfig.pubId];
    inmobiInterstitial.delegate = self;
    [inmobiInterstitial loadInterstitial];
}

- (void)presentInterstitial{
    // 呈现插屏广告
    if (inmobiInterstitial.state == kIMInterstitialStateReady) {
        [inmobiInterstitial presentInterstitialAnimated:YES];
    }else{
        NSLog(@"inmobi interstitial present fail");
    }
}

- (void)stopBeingDelegate {
    if (inmobiInterstitial != nil) {
        [inmobiInterstitial setDelegate:nil];
    }
}

- (void)dealloc{
    [inmobiInterstitial release], inmobiInterstitial = nil;
    [super dealloc];
}


#pragma mark Inmobi delegate

/**
 * Sent when an interstitial ad request succeeded.
 * @param ad The IMInterstitial instance which finished loading.
 */
- (void)interstitialDidReceiveAd:(IMInterstitial *)ad{
    isReady = YES;
    [baiduMobSspInterstitial  adapter:self didReceiveInterstitial: nil];
}

/**
 * Sent when an interstitial ad request failed
 * @param ad The IMInterstitial instance which failed to load.
 * @param error The IMError associated with the failure.
 */
- (void)interstitial:(IMInterstitial *)ad
didFailToReceiveAdWithError:(IMError *)error{
    [baiduMobSspInterstitial  adapter:self didFailAd:nil];
}

/**
 * Sent just before presenting an interstitial.  After this method finishes the
 * interstitial will animate onto the screen.  Use this opportunity to stop
 * animations and save the state of your application in case the user leaves
 * while the interstitial is on screen (e.g. to visit the App Store from a link
 * on the interstitial).
 * @param ad The IMInterstitial instance which will present the screen.
 */
- (void)interstitialWillPresentScreen:(IMInterstitial *)ad{
    [baiduMobSspInterstitial  adapter:self willPresentScreen :nil];
}

/**
 * Sent before the interstitial is to be animated off the screen.
 * @param ad The IMInterstitial instance which will dismiss the screen.
 */
- (void)interstitialWillDismissScreen:(IMInterstitial *)ad{
    
}

/**
 * Sent just after dismissing an interstitial and it has animated off the screen.
 * @param ad The IMInterstitial instance which was responsible for dismissing the screen.
 */
- (void)interstitialDidDismissScreen:(IMInterstitial *)ad{
    [baiduMobSspInterstitial adapter:self didDismissScreen:nil];
}
/**
 * Callback sent just before the application goes into the background because
 * the user clicked on a link in the ad that will launch another application
 * (such as the App Store). The normal UIApplicationDelegate methods like
 * applicationDidEnterBackground: will immediately be called after this.
 * @param ad The IMInterstitial instance that is launching another application.
 */
- (void)interstitialWillLeaveApplication:(IMInterstitial *)ad{
}
/**
 * Called when the interstitial is tapped or interacted with by the user
 * Optional data is available to publishers to act on when using
 * monetization platform to render promotional ads.
 * @param ad The IMInterstitial instance which was responsible for this action.
 * @param dictionary The NSDictionary object which was passed from the ad.
 */
-(void)interstitialDidInteract:(IMInterstitial *)ad withParams:(NSDictionary *)dictionary{
    [baiduMobSspInterstitial  adapter:self didAdClick :nil];
}
/**
 * Called when the interstitial failed to display.
 * This should normally occur if the state != kIMInterstitialStateReady.
 * @param ad The IMInterstitial instance responsible for this error.
 * @param error The IMError associated with this failure.
 */
- (void)interstitial:(IMInterstitial *)ad didFailToPresentScreenWithError:(IMError *)error{
    
}
@end
