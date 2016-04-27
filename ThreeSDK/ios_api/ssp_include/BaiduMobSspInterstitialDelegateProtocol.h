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

@class BaiduMobSspInterstitial;

@protocol BaiduMobSspInterstitialDelegate<NSObject>
/**
 * 应用广告位id
 */
- (NSString *)baiduMobSspInterstitialApplicationKey;
/**
 * 返回UIViewController用来展示插屏
 */
- (UIViewController*)viewControllerForPresentingInterstitialModalView;

@optional

#pragma mark Ad Request Lifecycle Notifications

/**
 * 插屏请求成功
 */
- (void)interstitialSuccessToLoadAd:(BaiduMobSspInterstitial *)ad;

/**
 * 插屏请求失败
 */
- (void)interstitialFailToLoadAd:(BaiduMobSspInterstitial *)ad;

#pragma mark Display-Time Lifecycle Notifications
/**
 * 插屏即将展示
 */
- (void)interstitialWillPresentScreen:(BaiduMobSspInterstitial *)ad;

/**
 * 插屏展示结束
 */
- (void)interstitialDidDismissScreen:(BaiduMobSspInterstitial *)ad;
/**
 * 用户点击插屏广告
 */
- (void)interstitialDidClick:(BaiduMobSspInterstitial *)ad;
/**
 * 用户点击内购广告，仅用于内购买广告，返回内购买广告的商品id
 */
- (void)interstitialIAPDidClick:(BaiduMobSspInterstitial *)ad productId:(NSString *)productId;
/**
 * 由于用户点击广告启动另一个应用导致当前应用进入后台或者退出
 */
- (void)interstitialWillLeaveApplication:(BaiduMobSspInterstitial *)ad;

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
