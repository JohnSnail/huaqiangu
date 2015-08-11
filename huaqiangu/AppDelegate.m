//
//  AppDelegate.m
//  huaqiangu
//
//  Created by Jiangwei on 15/7/18.
//  Copyright (c) 2015年 Jiangwei. All rights reserved.
//

#import "AppDelegate.h"
#import "MainController.h"
#import "MLNavigationController.h"
#import <AVFoundation/AVFoundation.h>
#import "PlayController.h"
#import <MobClick.h>

@interface AppDelegate ()

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
        
    [self lockScrollerView];
    
    [self umengAtion];
    
    MainController *viewCtrl = [[MainController alloc]init];
    
    MLNavigationController *navCtrl = [[MLNavigationController alloc]initWithRootViewController:viewCtrl];
    
    [navCtrl.navigationBar setBarTintColor:RGB(76, 193, 211)];
    
    self.window.rootViewController = navCtrl;
    [self.window makeKeyAndVisible];

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
