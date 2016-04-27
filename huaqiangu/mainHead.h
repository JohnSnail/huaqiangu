//
//  mainHead.h
//  huaqiangu
//
//  Created by Jiangwei on 15/7/18.
//  Copyright (c) 2015年 Jiangwei. All rights reserved.
//

#ifndef huaqiangu_mainHead_h
#define huaqiangu_mainHead_h

//设置输出
#define TDebug 1
#if TDebug
#define TLog(format, ...)  NSLog(format, ## __VA_ARGS__)
#else
#define TLog(format, ...)
#endif

//屏幕
#define mainscreenhight [UIScreen mainScreen].bounds.size.height
#define mainscreenwidth [UIScreen mainScreen].bounds.size.width
#define IS_IOS_7 ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)?YES:NO
#define IS_IPHONE_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(320,568), [[UIScreen mainScreen] currentMode].size) || (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)) || (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

#define VIEWWITH (mainscreenwidth/320.0)

//单例
#define SINGLETON_CLASS(classname) \
\
+ (classname *)shared##classname \
{\
static dispatch_once_t pred = 0; \
__strong static id _shared##classname = nil; \
dispatch_once(&pred,^{ \
_shared##classname = [[self alloc] init]; \
});  \
return _shared##classname; \
}

#define CREAT_XIB(__xibname__)  {[[[NSBundle mainBundle] loadNibNamed:__xibname__ owner:nil options:nil] objectAtIndex:0]}

//RGB颜色宏定义
#define RGB(red,gre,blu) [UIColor colorWithRed:red/255.0f green:gre/255.0f blue:blu/255.0f alpha:1.0]

#define LM_POP    [self.navigationController popViewControllerAnimated:YES]



//*****************************************
//替换版本时需更换的内容

//苹果id
#define AppStoreAppId @"1055560827"

#pragma mark -
#pragma mark - AlbumTitle

#define ALBUMTITLE @"Papi讲"

#pragma mark -
#pragma mark - UMengKey

#define umAppKey @"53ac2b4656240b97ba07b956"

//#define kCommenColor RGB(248, 102, 47)
//#define kCommenColor RGB(88,185,201)
#define kCommenColor RGB(245,85,130)

//**************** 百度广告 ***********************

#define kBaiduId @"ec7ad5ef"
#define kBaiduBanner @"2010399"
#define kBaiduSplash @"2010402"

//**************** 测试 ***********************

//#define kBaiduId @"ccb60059"
//#define kBaiduSplash @"2006257"

//**************** 岳云鹏 ***********************
//#define kBaiduId @"e89aefee"
//#define kBaiduBanner @"2010416"
//#define kBaiduSplash @"2006257"
//**************** end ***********************

#pragma mark - 
#pragma mark - appdelegate

#define appDelegate  (AppDelegate *)[[UIApplication sharedApplication]delegate];

// 缓存主目录
#define HSCachesDirectory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"HSCache"]

// 保存文件名
#define HSFileName(url) [NSString stringWithFormat:@"%@.mp3",url.md5String]

// 文件的存放路径（caches）
#define HSFileFullpath(url) [HSCachesDirectory stringByAppendingPathComponent:HSFileName(url)]

// 文件的已下载长度
#define HSDownloadLength(url) [[[NSFileManager defaultManager] attributesOfItemAtPath:HSFileFullpath(url) error:nil][NSFileSize] integerValue]

// 存储文件总长度的文件路径（caches）
#define HSTotalLengthFullpath [HSCachesDirectory stringByAppendingPathComponent:@"totalLength.plist"]

#import "NSString+Hash.h"

#endif
