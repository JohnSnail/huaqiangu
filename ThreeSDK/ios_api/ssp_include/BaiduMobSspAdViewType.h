//
//  BaiduMobSspAdViewType.h
//  BaiduMobSsp
//
//  Created by dengjinxiang on 14-7-9.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    BaiduMobSspAdViewTypeUnknown          = 0,  //error
	BaiduMobSspAdViewTypeNormalBanner     = 1,  //e.g. 320 * 50 ; 320 * 48...           iphone banner
    BaiduMobSspAdViewTypeLargeBanner      = 2,  //e.g. 728 * 90 ; 768 * 110             ipad only
    BaiduMobSspAdViewTypeMediumBanner     = 3,  //e.g. 468 * 60 ; 508 * 80              ipad only
    BaiduMobSspAdViewTypeRectangle        = 4,  //e.g. 300 * 250; 320 * 270             ipad only
    BaiduMobSspAdViewTypeSky              = 5,  //Don't support
    BaiduMobSspAdViewTypeFullScreen       = 6,  //iphone full screen ad
    BaiduMobSspAdViewTypeVideo            = 11, //iPad and iPhone use video ad
    BaiduMobSspAdViewTypeiPadNormalBanner = 8,  //ipad full width banner
    BaiduMobSspAdViewTypeiPadFullScreen   = 9,  //ipad full screen ad e.g. 1024*768     ipad only
    BaiduMobSspAdViewTypeCustomSize       = 10, //iPad and iPhone use custom size
    BaiduMobSspAdViewTypeSplash           = 12, // IOS Splash Ad
    BaiduMobSspAdViewTypeiPhoneRectangle  = 14,// iPhone 300*250
} BaiduMobSspAdViewType;