//
//  BaiduMobSspAdapterBalintimesInterstitial.h
//  BaiduMobSsp
//
//  Created by dengjinxiang on 14-7-2.
//  Copyright (c) 2014年 baidu. All rights reserved.
//
#import "BaiduMobAdSplash.h"
#import "BaiduMobSspAdNetworkAdapter.h"

@interface BaiduMobSspAdapterBaiduSplash : BaiduMobSspAdNetworkAdapter<BaiduMobAdSplashDelegate>{
    UIViewController *baseViewController;
}

@property (nonatomic,retain) BaiduMobAdSplash *baiduMobAdSplash;
@end
