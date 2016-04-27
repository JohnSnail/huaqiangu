//
//  BaiduMobSspAdapterAdwo.h
//  BaiduMobSspSample
//
//  Created by dengjinxiang on 14-7-10.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "BaiduMobSspAdNetworkAdapter.h"
#import "AdwoAdSDK.h"

@interface BaiduMobSspAdapterAdwo : BaiduMobSspAdNetworkAdapter<AWAdViewDelegate>{
    CGRect frame;
    UIView *adView;
}
@end
