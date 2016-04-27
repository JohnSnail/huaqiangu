//
//  BaiduMobSspAdapterAdwoInterstitial.m
//  BaiduMobSspSample
//
//  Created by dengjinxiang on 14-7-10.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "BaiduMobSspAdapterAdwoSplash.h"
#import "BaiduMobSspSplashAdNetworkRegistry.h"
#import "BaiduMobSspSplash.h"
#import "BaiduMobSspAdNetworkConfig.h"

@implementation BaiduMobSspAdapterAdwoSplash

+ (BaiduMobSspAdNetworkType)networkType{
    return BaiduMobSspAdNetworkTypeAdwo;
}

+ (void)load{
    [[BaiduMobSspSplashAdNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    NSString *pid = networkConfig.pubId;
    BOOL testMode = NO;
    adWoSplash = AdwoAdGetFullScreenAdHandle(pid, testMode, self, ADWOSDK_FSAD_SHOW_FORM_LAUNCHING);
    
    // 这里设置动画形式为无动画模式。如果不设置则由系统自动给出
    AdwoAdSetAdAttributes(adWoSplash, &(const struct AdwoAdPreferenceSettings){
        .animationType = ADWO_SDK_FULLSCREEN_ANIMATION_TYPE_NONE
    });
    
    //开始加载全屏广告
    mCanShowAd = AdwoAdLoadFullScreenAd(adWoSplash, YES, 20) == YES;
    if (!mCanShowAd) {
        int errCode = AdwoAdGetLatestErrorCode();
        NSLog(@"Adwo request splash failed, because: %d", errCode);
    }
}

/**
 * 描述：捕获当前加载广告失败通知。当你所创建的广告视图对象请求广告失败后，SDK将会调用此接口来通知。参数adView指向当前请求广告的AWAdview对象。开发者可以通过errorCode属性来查询失败原因。
 */
- (void)adwoAdViewDidFailToLoadAd:(UIView*)adView{
    adWoSplash = nil;
    [baiduMobSspSplash adapter:self didFailAd:nil];
}


/**
 * 描述：捕获广告加载成功通知。当你广告加载成功时，SDK将会调用此接口。参数adView指向当前请求广告的AWAdView对象。这个接口对于全屏广告展示而言，一般必须实现以捕获可以展示全屏广告的时机。
 */
- (void)adwoAdViewDidLoadAd:(UIView*)adView{
    if (adWoSplash != adView) {
        [baiduMobSspSplash adapter:self didFailAd:nil];
    }
    if (!mCanShowAd) {
        adWoSplash = nil;
        [baiduMobSspSplash adapter:self didFailAd:nil];
    } else {
        // 广告加载成功，可以把全屏广告展示上去
        BOOL status=AdwoAdShowFullScreenAd(adWoSplash);
        if (status) {
            mCanShowAd = NO;
            [baiduMobSspSplash adapter:self didSuccessAd:nil];
            // 成功
        }else{
            adWoSplash = nil;
            // 失败
            [baiduMobSspSplash adapter:self didFailAd:nil];
        }

    }
}

/**
 * 描述：当SDK需要弹出自带的Browser以显示mini site时需要使用当前广告所在的控制器。
 * AWAdView的delegate必须被设置，并且此接口必须被实现。
 * 返回：一个视图控制器对象
 */

- (UIViewController*)adwoGetBaseViewController{
    
    //这里建议返回根控制器，由于有的广告没有请求完就会销毁了FullAdViewController对象，导致获取该控制器失败。
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (viewController == NULL) {
        viewController = [self.baiduMobSspSplashDelegate viewControllerForPresentingInterstitialModalView];
    }
    return viewController;
    
}

/**
 * 描述：当全屏广告被关闭时，SDK将调用此接口。一般而言，当全屏广告被用户关闭后，开发者应当释放当前的AWAdView对象，因为它的展示区域很可能发生改变。如果再用此对象来请求广告的话，展示可能会成问题。参数adView指向当前请求广告的AWAdView对象。
 */
- (void)adwoFullScreenAdDismissed:(UIView*)adView{
    [baiduMobSspSplash adapter:self didDismissScreen:adView];
    
}

- (void)stopBeingDelegate {

}

- (void)dealloc{
    [super dealloc];
}

@end
