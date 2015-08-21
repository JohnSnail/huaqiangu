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

@interface AppDelegate ()<BaiduMobAdSplashDelegate>
{
    KKNavigationController *navCtrl;
}
@property (nonatomic, strong) BaiduMobAdSplash *splash;

@end

@implementation AppDelegate


#pragma mark -
#pragma mark - 友盟统计

-(void)umengAtion
{
    //友盟统计
    [MobClick startWithAppkey:umAppKey];
}

#pragma mark -
#pragma mark - 百度开屏广告

-(void)baiduSplash
{
    self.customSplashView = [[UIView alloc]initWithFrame:self.window.frame];
    self.customSplashView.backgroundColor = [UIColor whiteColor];
    [self.window addSubview:self.customSplashView];
    
    self.splash = [[BaiduMobAdSplash alloc] init];
    self.splash.delegate = self;
    self.splash.AdUnitTag = kBaiduSplash;
    self.splash.canSplashClick = YES;
//    self.splash.useCache = NO;
    [self.splash loadAndDisplayUsingContainerView:self.customSplashView];
//    [self.splash loadAndDisplayUsingKeyWindow:self.window];
}

- (NSString *)publisherId {
    return kBaiduId; //your_own_app_id
}

/**
 *  启动位置信息
 */
-(BOOL) enableLocation{
    return NO;
}


/**
 *  广告展示成功
 */
- (void)splashSuccessPresentScreen:(BaiduMobAdSplash *)splash{
    NSLog(@"广告展示成功");
//    self.window.rootViewController = navCtrl;
}

/**
 *  广告展示失败
 */
- (void)splashlFailPresentScreen:(BaiduMobAdSplash *)splash withError:(BaiduMobFailReason) reason{
    NSLog(@"广告展示失败%u",reason);
    
    [self.customSplashView removeFromSuperview];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];

//    self.window.rootViewController = navCtrl;
}

/**
 *  广告展示结束
 */
- (void)splashDidDismissScreen:(BaiduMobAdSplash *)splash{
    NSLog(@"广告展示结束");
    
    [self.customSplashView removeFromSuperview];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];

//    self.window.rootViewController = navCtrl;
}

- (void)dealloc
{
    self.customSplashView = nil;
    self.splash = nil;
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

    [self baiduSplash];
    
    [self lockScrollerView];
    [self umengAtion];


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
