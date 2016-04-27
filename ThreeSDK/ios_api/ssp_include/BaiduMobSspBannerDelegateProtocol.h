//
//  BaiduMobSspDelegate.h
//  BaiduMobSsp
//
//  Created by dengjinxiang on 14-5-8.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaiduMobSspCommonConfig.h"

@class BaiduMobSspBannerView;

@protocol BaiduMobSspDelegate<NSObject>

@required
/**
 *  应用广告位id
 */
- (NSString *)baiduMobSspApplicationKey;

/**
 * 返回UIViewController
 */
- (UIViewController*)viewController;

@optional

#pragma mark Ad Request Lifecycle Notifications
/**
 * 成功请求到广告
 */
- (void)baiduMobSspDidReceiveAd:(BaiduMobSspBannerView *)baiduMobSspBannerView;
/**
 * 请求广告失败
 */
- (void)baiduMobSspDidFailToReceiveAd:(BaiduMobSspBannerView *)baiduMobSspBannerView;
/**
 * 广告开始展示
 */
- (void)baiduMobSspPresent:(BaiduMobSspBannerView *)baiduMobSspBannerView;
/**
 * 用户点击内购广告，仅用于内购买广告，返回内购买广告的商品id
 */
- (void)baiduMobSspDidIAPAdClickedAd:(BaiduMobSspBannerView *)baiduMobSspBannerView withProductId:(NSString *)productId;
#pragma mark Display-Time when shown a full screen
/**
 * 用于用户点击广告，将全屏展示webview
 */
- (void)baiduMobSspWillPresentFullScreenModal;
/**
 * 退出webview的全屏展示
 */
- (void)baiduMobSspDidDismissFullScreenModal;

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
