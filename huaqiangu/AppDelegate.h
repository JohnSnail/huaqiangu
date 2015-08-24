//
//  AppDelegate.h
//  huaqiangu
//
//  Created by Jiangwei on 15/7/18.
//  Copyright (c) 2015年 Jiangwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,AVAudioSessionDelegate>
@property (strong, nonatomic) NSMutableDictionary* PlayingInfoCenter;


@property (strong, nonatomic) UIView *customSplashView;
@property (strong, nonatomic) UIWindow *window;

//测试

@end

