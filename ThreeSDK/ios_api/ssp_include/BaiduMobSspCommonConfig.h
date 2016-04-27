//
//  BaiduMobSspCommonConfig.h
//  BaiduMobSsp
//
//  Created by dengjinxiang on 14-6-12.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  性别类型
 */
typedef enum
{
	BaiduMobSspMale=0,          //男性
	BaiduMobSspFeMale=1,        //女性
    BaiduMobSspSexUnknown=2,    //未知
} BaiduMobSspUserGender;

//banner广告在iphone上的推荐宽高及大小
#define kBaiduMobSspViewWidth 320
#define kBaiduMobSspViewHeight 50
#define kBaiduMobSspViewDefaultSizeViewDefaultSize \
(CGSizeMake(kBaiduMobSspViewWidth, kBaiduMobSspViewHeight))
#define kBaiduMobSspViewDefaultFrame \
(CGRectMake(0,0,kBaiduMobSspViewWidth, kBaiduMobSspViewHeight))

#define kBaiduMobSspChannelId @"29719927";