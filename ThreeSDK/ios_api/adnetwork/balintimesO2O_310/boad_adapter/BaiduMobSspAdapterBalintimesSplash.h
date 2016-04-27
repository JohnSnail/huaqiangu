//
//  BaiduMobSspAdapterBalintimesInterstitial.h
//  BaiduMobSsp
//
//  Created by dengjinxiang on 14-7-2.
//  Copyright (c) 2014年 baidu. All rights reserved.
//
#import "BOADInterstitial.h"
#import "BaiduMobSspAdNetworkAdapter.h"

@interface BaiduMobSspAdapterBalintimesSplash : BaiduMobSspAdNetworkAdapter<BOADInterstitialDelegate>{
    BOADInterstitial * boadInterstitial;
    UIViewController *baseViewController;
}
@end
