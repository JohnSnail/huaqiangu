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
#import <STKAudioPlayer.h>

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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[AVAudioSession sharedInstance] setDelegate:self];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    UInt32 size = sizeof(CFStringRef);
    CFStringRef route;
    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &size, &route);
    NSLog(@"route = %@", route);
    
    _PlayingInfoCenter = [[NSMutableDictionary alloc] init];
    [self becomeFirstResponder];
    
    MainController *viewCtrl = [[MainController alloc]init];
    navCtrl = [[KKNavigationController alloc]initWithRootViewController:viewCtrl];
    
    [navCtrl.navigationBar setBarTintColor:kCommenColor];
    self.window.rootViewController = navCtrl;
    [self.window makeKeyAndVisible];
        
    [self umengAtion];
    
//    [[MainList sharedManager] cleanContent];
    
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


- (void)applicationWillResignActive:(UIApplication *)application
{
    
    NSLog(@"\n\n倔强的打出一行字告诉你我要挂起了。。\n\n");
    
    //MBAudioPlayer是我为播放器写的单例，这段就是当音乐还在播放状态的时候，给后台权限，不在播放状态的时候，收回后台权限
    if ([STKAudioPlayer sharedManager].state == STKAudioPlayerStatePlaying||[STKAudioPlayer sharedManager].state == STKAudioPlayerStateBuffering||[STKAudioPlayer sharedManager].state == STKAudioPlayerStatePaused ||[STKAudioPlayer sharedManager].state == STKAudioPlayerStateStopped) {
        //有音乐播放时，才给后台权限，不做流氓应用。
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        [self becomeFirstResponder];
        //开启定时器
//        [[PlayController sharedPlayController] setupTimer:YES];
//        [[PlayController sharedPlayController] setupTimer:YES];
//        [[STKAudioPlayer sharedManager] decideTimerWithType:STKAudioTimerStartBackground andBeginState:YES];
//        [[STKAudioPlayer sharedManager] configNowPlayingInfoCenter];
    }
    else
    {
        [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
        [self resignFirstResponder];
        //检测是都关闭定时器
//        [[PlayController sharedPlayController] setupTimer:NO];
//        [[PlayController sharedPlayController].timer invalidate];
//        [[STKAudioPlayer sharedManager] decideTimerWithType:STKAudioTimerStartBackground andBeginState:NO];
//        [[PlayController sharedPlayController] setupTimer:NO];
    }
}

@end
