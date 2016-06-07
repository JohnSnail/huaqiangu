//
//  AppDelegate.m
//  huaqiangu
//
//  Created by Jiangwei on 15/7/18.
//  Copyright (c) 2015年 Jiangwei. All rights reserved.
//

#import "AppDelegate.h"
#import "MainController.h"
#import <AVFoundation/AVFoundation.h>
#import "PlayController.h"
#import <MobClick.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "DownController.h"

@interface AppDelegate (){
    
    KKNavigationController *navCtrl;
}

@end

@implementation AppDelegate


#pragma mark -
#pragma mark - 友盟统计

-(void)umengAtion
{
    //友盟统计
    [MobClick startWithAppkey:umAppKey];
}

- (void)dealloc
{
    self.customSplashView = nil;
    self.window = nil;
}

#pragma mark - 
#pragma mark - 锁屏播放设置
-(void)lockScrollerView
{
    _PlayingInfoCenter = [[NSMutableDictionary alloc] init];
    //锁屏播放设置
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    MainController *viewCtrl = [[MainController alloc]init];
    navCtrl = [[KKNavigationController alloc]initWithRootViewController:viewCtrl];
    
    [navCtrl.navigationBar setBarTintColor:kCommenColor];
    self.window.rootViewController = navCtrl;
    [self.window makeKeyAndVisible];
    //添加百度开屏
    
    [self lockScrollerView];
    [self umengAtion];
    
    
//    [[MainList sharedManager] cleanContent];

    //下载数据
    [[DownController sharedManager] getDownData];
    [[DownController sharedManager] downAction];
    
    [Fabric with:@[CrashlyticsKit]];
    return YES;
}

#pragma mark - 
#pragma mark - 锁屏播放设置

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:
            case UIEventSubtypeRemoteControlPause:
            case UIEventSubtypeRemoteControlTogglePlayPause:{
                [[PlayController sharedPlayController] playAction];
            }
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack: {
                [[PlayController sharedPlayController] laseAction];
                break;
            }
            case UIEventSubtypeRemoteControlNextTrack: {
                [[PlayController sharedPlayController] nextAction];
                break;
            }
            default: {
                break;
            }
        }
    }
}


@end
