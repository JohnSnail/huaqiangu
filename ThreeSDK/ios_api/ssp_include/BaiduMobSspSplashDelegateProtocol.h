//
//  BaiduMobSspInterstitialDelegateProtocol.h
//  BaiduMobSsp
//
//  Created by dengjinxiang on 14-6-11.
//  Copyright (c) 2014年 baidu. All rights reserved.
//
#import "BaiduMobSspCommonConfig.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class BaiduMobSspSplash;

@protocol BaiduMobSspSplashDelegate<NSObject>
/**
 * 应用广告位id
 */
- (NSString *)baiduMobSspSplashApplicationKey;
/**
 * 返回UIViewController用来展示开屏
 */
- (UIViewController*)viewControllerForPresentingInterstitialModalView;

@optional

#pragma mark Ad Request Lifecycle Notifications

/**
 * 开屏广告成功
 */
- (void)splashAdsSuccess:(BaiduMobSspSplash *)ad;

/**
 * 开屏广告失败
 */
- (void)splashAdsFail:(BaiduMobSspSplash *)ad withError:(NSError *)err;

#pragma mark Display-Time Lifecycle Notifications
/**
 * 开屏即将展示
 */
- (void)splashWillPresentScreen:(BaiduMobSspSplash *)ad;
/**
 * 开屏已经展示
 */
- (void)splashDidPresentScreen:(BaiduMobSspSplash *)ad;

/**
 * 开屏即将结束
 */
- (void)splashWillDismissScreen:(BaiduMobSspSplash *)ad;
/**
 * 开屏展示结束
 */
- (void)splashDidDismissScreen:(BaiduMobSspSplash *)ad;

#pragma mark information optional delegate methods for baiduAdnetwork
/**
 *  启动位置信息
 */
-(BOOL) enableLocation;

/**
 *  关键词数组
 */
-(NSArray*) keywords;

/**
 *  用户性别
 */
-(BaiduMobSspUserGender) userGender;
/**
 *  用户生日
 */
-(NSDate*) userBirthday;

/**
 *  用户城市
 */
-(NSString*) userCity;

/**
 *  用户邮编
 */
-(NSString*) userPostalCode;

/**
 *  用户职业
 */
-(NSString*) userWork;

/**
 *  - 用户最高教育学历
 *  - 学历输入数字，范围为0-6
 *  - 0代表小学，1代表初中，2代表中专/高中，3代表专科
 *  - 4代表本科，5代表硕士，6代表博士，7代表未知
 */
-(NSInteger) userEducation;

/**
 *  - 用户收入
 *  - 收入输入数字,以元为单位
 */
-(NSInteger) userSalary;

/**
 *  用户爱好
 */
-(NSArray*) userHobbies;

/**
 *  其他自定义字段,key以及value都为NSString
 */
-(NSDictionary*) userOtherAttributes;

@end
