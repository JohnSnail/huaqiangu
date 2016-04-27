//
//  BMSNetworkReachabilityDelegate.h
//  BaiduMobSspSdk
//
//  Created by dengjinxiang on 14-5-8.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

@class BMSNetworkReachabilityWrapper;

@protocol BMSNetworkReachabilityDelegate <NSObject>

@optional
- (void)reachabilityBecameReachable:(BMSNetworkReachabilityWrapper *)reachability;
- (void)reachabilityNotReachable:(BMSNetworkReachabilityWrapper *)reachability;

@end
