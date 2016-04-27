//
//  BMSNetworkReachabilityWrapper.h
//  BaiduMobSsp
//
//  Created by dengjinxiang on 14-5-8.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <netdb.h>
#import "BMSNetworkReachabilityDelegate.h"

@class BMSNetworkReachabilityWrapper;


// Created for ease of mocking (hence testing)
@interface BMSNetworkReachabilityWrapper : NSObject {
  NSString *_hostname;
  SCNetworkReachabilityRef _reachability;
  id<BMSNetworkReachabilityDelegate> _delegate;
}

@property (nonatomic,readonly) NSString *hostname;
@property (nonatomic,assign) id<BMSNetworkReachabilityDelegate> delegate;

+ (BMSNetworkReachabilityWrapper *) reachabilityWithHostname:(NSString *)host
          callbackDelegate:(id<BMSNetworkReachabilityDelegate>)delegate;

- (id)initWithHostname:(NSString *)host
      callbackDelegate:(id<BMSNetworkReachabilityDelegate>)delegate;

- (BOOL)scheduleInSerialQueue;

- (BOOL)unscheduleFromSerialQueue;

@end
