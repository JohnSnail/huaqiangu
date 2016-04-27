//
//  BaiduMobSspAdapterAdwo.m
//  BaiduMobSspSample
//
//  Created by dengjinxiang on 14-7-10.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "BaiduMobSspAdapterAdwo.h"
#import "BaiduMobSspAdNetworkConfig.h"
#import "BaiduMobSspBannerView.h"
#import "BaiduMobSspBannerAdNetworkRegistry.h"
#import "BaiduMobSSpCoreController.h"
#import "AdwoAdSDK.h"

@implementation BaiduMobSspAdapterAdwo

+ (BaiduMobSspAdNetworkType)networkType{
    return BaiduMobSspAdNetworkTypeAdwo;
}

+ (void)load{
    [[BaiduMobSspBannerAdNetworkRegistry sharedRegistry] registerClass:self];
}


- (void)getAd {
    self.adNetworkView = [[[UIView alloc] init] autorelease];
    adwoAdStopBannerAutoRefresh();
    BaiduMobSspAdViewType type =[coreController adViewType];
    enum ADWO_ADSDK_BANNER_SIZE  adwo_ad_type;
    frame = CGRectZero;
    switch (type) {
        case BaiduMobSspAdViewTypeNormalBanner:
            adwo_ad_type = ADWO_ADSDK_BANNER_SIZE_NORMAL_BANNER;
            frame = CGRectMake(0.0, 0.0, 320.0, 50.0);
            break;
        case BaiduMobSspAdViewTypeiPadNormalBanner:
            adwo_ad_type = ADWO_ADSDK_BANNER_SIZE_FOR_IPAD_320x50;
            frame = CGRectMake(0.0, 0.0, 320.0, 50.0);
            break;
        case BaiduMobSspAdViewTypeLargeBanner:
            adwo_ad_type = ADWO_ADSDK_BANNER_SIZE_FOR_IPAD_720x110;
            frame = CGRectMake(0.0, 0.0, 720.0, 110.0);
            break;
        default:
            [coreController adapter:self didFailAd:nil];
            return;
            break;
    }
    NSString *pid = networkConfig.pubId;
    BOOL testMode = NO;
    adView = AdwoAdCreateBanner(pid, !testMode, self);
    if(adView){
        BOOL isLocationOn = NO;
        if (baiduMobSspDelegate && [baiduMobSspDelegate respondsToSelector:@selector(enableLocation)]) {
            isLocationOn = [baiduMobSspDelegate enableLocation];
        }
        if (isLocationOn) {
            AdwoAdSetAdAttributes(adView, &(struct AdwoAdPreferenceSettings){
                .disableGPS = NO                                       // 禁用GPS导航功能
            });
        }else{
            AdwoAdSetAdAttributes(adView, &(struct AdwoAdPreferenceSettings){
                .disableGPS = YES                                       // 禁用GPS导航功能
            });
        }
        
        adView.frame = frame;
        self.adNetworkView.frame = frame;
        
        BOOL isSuccessful = AdwoAdLoadBannerAd(adView, adwo_ad_type, NULL);
        if(!isSuccessful)
        {
            
            if(AdwoAdGetLatestErrorCode() == ADWO_ADSDK_ERROR_CODE_AD_REQUEST_TOO_OFTEN)
                NSLog(@"Adwo banner request too often");
            
            [self stopBeingDelegate];
            
            return;
        }
        
        
    }else {
        [coreController adapter:self didFailAd:nil];
        return;
    }
    
    
}


-(void)stopBeingDelegate{
    if(adView){
        AdwoAdRemoveAndDestroyBanner(adView);
    }
}

#pragma mark AWAdView delegate

/**
 * 描述：当SDK需要弹出自带的Browser以显示mini site时需要使用当前广告所在的控制器。
 * AWAdView的delegate必须被设置，并且此接口必须被实现。
 * 返回：一个视图控制器对象
 */
- (UIViewController*)adwoGetBaseViewController{
    return [baiduMobSspDelegate viewController];
}



/**
 * 描述：捕获当前加载广告失败通知。当你所创建的广告视图对象请求广告失败后，SDK将会调用此接口来通知。参数adView指向当前请求广告的AWAdview对象。开发者可以通过errorCode属性来查询失败原因。
 */
- (void)adwoAdViewDidFailToLoadAd:(UIView*)_adView{
    NSLog(@"%d",AdwoAdGetLatestErrorCode());
   [coreController adapter:self didFailAd:nil];
}

/**
 * 描述：捕获广告加载成功通知。当你广告加载成功时，SDK将会调用此接口。参数adView指向当前请求广告的AWAdView对象。这个接口对于全屏广告展示而言，一般必须实现以捕获可以展示全屏广告的时机。
 */
- (void)adwoAdViewDidLoadAd:(UIView*)_adView{
    _adView.frame = frame;
    AdwoAdAddBannerToSuperView(adView, self.adNetworkView);
    [coreController adapter:self didReceiveAdView: _adView];
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

-(BOOL)shouldReportViewClick
{
    return YES;
}


-(void)dealloc{
    [super dealloc];
}

@end
