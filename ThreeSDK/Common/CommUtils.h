//
//  CommUtils.h
//  jianzhi
//
//  Created by Jiangwei on 15/5/27.
//  Copyright (c) 2015年 li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface CommUtils : NSObject

//设备唯一标识
+(NSString *)imei;

//设备的名称
+ (NSString*)getMachine;

//app版本号
+(NSString *)getVersion;

//根据User_key判断是否登录
+(BOOL)is_onLine;

//定制navigation的title
+(UILabel *)navTittle:(NSString *)title;

//保存设备唯一标示
+(void)saveMobileKey:(NSString *)mobile_key;

//获取设备唯一标示
+(NSString *)getMobileKey;

//保存用户唯一标示
+(void)saveUserKey:(NSString *)user_key;

//获取用户唯一标示
+(NSString *)getUserKey;

//保存登录用户
+(void)saveUserModel:(UserModel *)user;

//读取登录用户数据
+(UserModel *)readUser;

//退出登录
+(void)quitLoginAction;

//转化NSDate为年份
+(NSInteger)getAgeAction:(NSDate *)testDate;

//转化NNString为NSDate
+(NSDate *)dateFromString:(NSString *)dateString;

//转化NSDateNNString为NNString
+(NSString *)stringFromDate:(NSDate *)date;

//保存隐藏标示
+(void)saveAllowQQLogin:(NSString *)allow_qq_login;

//获取隐藏标示
+(NSString *)getAllowQQLogin;
@end
