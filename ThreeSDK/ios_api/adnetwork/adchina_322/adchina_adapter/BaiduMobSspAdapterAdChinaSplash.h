//
//  BaiduMobSspAdapterAdChinaInterstitial.h
//  BaiduMobSspSample
//
//  Created by dengjinxiang on 14-7-10.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "BaiduMobSspAdNetworkAdapter.h"
#import "AdChinaFullScreenView.h"

@interface BaiduMobSspAdapterAdChinaSplash : BaiduMobSspAdNetworkAdapter<AdChinaFullScreenViewDelegate>{
    UIViewController *baseViewController;
}
@property(nonatomic,retain)AdChinaFullScreenView *fullScreenAd;
@end
