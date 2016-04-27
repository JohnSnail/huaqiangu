//
//  BaiduMobSspAdapterMobiSageInterstitial.h
//  BaiduMobSspSample
//
//  Created by dengjinxiang on 14-7-9.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "BaiduMobSspAdNetworkAdapter.h"
#import "MobiSageSDK.h"

@interface BaiduMobSspAdapterMobiSageSplash : BaiduMobSspAdNetworkAdapter<MobiSageSplashDelegate>
{
   MobiSageRTSplash *mobiSageSplash;
}


@end
