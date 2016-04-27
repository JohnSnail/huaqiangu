//
//  BaiduMobSspAdapterAdwoInterstitial.m
//  BaiduMobSspSample
//
//  Created by dengjinxiang on 14-7-10.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "BaiduMobSspAdapterAdwoInterstitial.h"
#import "BaiduMobSspInterstitialAdNetworkRegistry.h"
#import "BaiduMobSspInterstitial.h"
#import "BaiduMobSspAdNetworkConfig.h"

//隐藏接口是为了处理delegate被释放了导致的crash 。这里可以重新对delegate赋值
extern BOOL AdwoAdSetDelegate(UIView *adView, NSObject<AWAdViewDelegate> *delegate);

@implementation BaiduMobSspAdapterAdwoInterstitial
static UIView *adFullScreenView = nil;
static NSObject<AWAdViewDelegate> *sDelegate = nil;
static BOOL isReady = NO;
+ (BaiduMobSspAdNetworkType)networkType{
    return BaiduMobSspAdNetworkTypeAdwo;
}

+ (void)load{
    [[BaiduMobSspInterstitialAdNetworkRegistry sharedRegistry] registerClass:self];
}

- (BOOL)isInterstitialReadyPresent
{
    return isReady;
}

- (void)getAd {
    enum ADWOSDK_FSAD_SHOW_FORM  adwo_ad_type;
    NSString *pid = networkConfig.pubId;
    BOOL testMode = NO;
    adwo_ad_type = ADWOSDK_FSAD_SHOW_FORM_APPFUN_WITH_BRAND;
    if (adFullScreenView) {
        AdwoAdSetDelegate(adFullScreenView, self);
        [self adwoAdViewDidLoadAd:adFullScreenView];
        return;
    } else {
        if (sDelegate) {
            [sDelegate release];
            sDelegate = nil;
        }
        
        sDelegate = [self retain];
        adFullScreenView = AdwoAdGetFullScreenAdHandle(pid, testMode, self, adwo_ad_type);
        if (!adFullScreenView){
            if (sDelegate) {
                [sDelegate release];
                sDelegate = nil;
            }
            [baiduMobSspInterstitial adapter:self didFailAd:nil];
            return;
        }
        
        if (!AdwoAdLoadFullScreenAd(adFullScreenView, NO, NULL)) {
            adFullScreenView = nil;
            [baiduMobSspInterstitial adapter:self didFailAd:nil];
        }
    }
}

- (void)presentInterstitial{
    if(!AdwoAdShowFullScreenAd(adFullScreenView)) {
        [baiduMobSspInterstitial adapter:self didFailAd:nil];
    }
}

/**
 * 描述：捕获当前加载广告失败通知。当你所创建的广告视图对象请求广告失败后，SDK将会调用此接口来通知。参数adView指向当前请求广告的AWAdview对象。开发者可以通过errorCode属性来查询失败原因。
 */
- (void)adwoAdViewDidFailToLoadAd:(UIView*)adView{
    
    
    isReady = NO;
    adFullScreenView = nil;
    
    if (sDelegate) {
        [sDelegate release];
        sDelegate = nil;
    }
    
    int errCode = AdwoAdGetLatestErrorCode();
    NSLog(@"adwo interstitial %d",errCode);
    [baiduMobSspInterstitial adapter:self didFailAd:nil];
}

/**
 * 描述：捕获广告加载成功通知。当你广告加载成功时，SDK将会调用此接口。参数adView指向当前请求广告的AWAdView对象。这个接口对于全屏广告展示而言，一般必须实现以捕获可以展示全屏广告的时机。
 */
- (void)adwoAdViewDidLoadAd:(UIView*)adView{
    isReady = YES;
    [baiduMobSspInterstitial adapter:self didReceiveInterstitial:adView];
    
}

/**
 * 描述：当全屏广告被关闭时，SDK将调用此接口。一般而言，当全屏广告被用户关闭后，开发者应当释放当前的AWAdView对象，因为它的展示区域很可能发生改变。如果再用此对象来请求广告的话，展示可能会成问题。参数adView指向当前请求广告的AWAdView对象。
 */

- (void)adwoFullScreenAdDismissed:(UIView*)adView{
    
    
    //modify by xiaohua ============
    
    adFullScreenView = nil;
    isReady = NO;
    
    if (sDelegate) {
        
        [sDelegate release];
        sDelegate = nil;
        
    }
    
    [baiduMobSspInterstitial adapter:self didDismissScreen:nil];
    
}

/**
 * 描述：当SDK弹出自带的全屏展示浏览器时，将会调用此接口。参数adView指向当前请求广告的AWAdView对象。这里需要注意的是，当adView弹出全屏展示浏览器时，此adView不允许被释放，否则会导致SDK崩溃。
 */

- (void)adwoDidPresentModalViewForAd:(UIView*)adView{
    
}

/**
 * 描述：当SDK自带的全屏展示浏览器被用户关闭后，将会调用此接口。参数adView指向当前请求广告的AWAdView对象。这里允许释放adView对象。
 */
- (void)adwoDidDismissModalViewForAd:(UIView*)adView{
    
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
        viewController = [baiduMobSspInterstitialDelegate viewControllerForPresentingInterstitialModalView];
    }
    return viewController;
    
}

- (void)stopBeingDelegate {

}

- (void)dealloc{
    [super dealloc];
}

@end
