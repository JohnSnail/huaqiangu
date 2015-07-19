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

@interface AppDelegate ()

@end

@implementation AppDelegate


//后台播放音乐

-(void)backPlayMusic
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *setCategoryError = nil;
    [session setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
    NSError *activationError = nil;
    [session setActive:YES error:&activationError];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self backPlayMusic];
    
    MainController *viewCtrl = [[MainController alloc]init];
    
    MLNavigationController *navCtrl = [[MLNavigationController alloc]initWithRootViewController:viewCtrl];
    
    [navCtrl.navigationBar setBarTintColor:RGB(76, 193, 211)];
    
    self.window.rootViewController = navCtrl;
    [self.window makeKeyAndVisible];

    return YES;
}

@end
