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

//RGB颜色宏定义
#define RGB(red,gre,blu) [UIColor colorWithRed:red/255.0f green:gre/255.0f blue:blu/255.0f alpha:1.0]

#define LM_POP    [self.navigationController popViewControllerAnimated:YES]


//苹果id
#define AppStoreAppId @"879096197"

#pragma mark -
#pragma mark - AlbumTitle

#define ALBUMTITLE @"岳云鹏相声"

#pragma mark -
#pragma mark - UMengKey

#define umAppKey @"5374e10e56240b391301d819"

#pragma mark - 
#pragma mark - appdelegate

#define appDelegate  (AppDelegate *)[[UIApplication sharedApplication]delegate];


#endif
