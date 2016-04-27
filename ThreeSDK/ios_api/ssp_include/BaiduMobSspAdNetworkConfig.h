//
//  BaiduMobSspAdNetworkConfig.h
//  BaiduMobSsp
//
//  Created by dengjinxiang on 14-5-13.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaiduMobSspBannerDelegateProtocol.h"
#import "BaiduMobSspAdNetworkAdapter.h"

#define BMSAdNetworkConfigKeyType       @"alliance"
#define BMSAdNetworkConfigKeyNID        @"nid"
#define BMSAdNetworkConfigKeyName       @"nname"
#define BMSAdNetworkConfigKeyWeight     @"weight"
#define BMSAdNetworkConfigKeyPriority   @"priority"
#define BMSAdNetworkConfigKeyCred       @"key"
#define BMSAdNetworkConfigKeyParam1     @"l1"
#define BMSAdNetworkConfigKeyParam2     @"l2"
#define BMSAdNetworkConfigKeyStrategyId @"strategyId"

@class BaiduMobSspError;
@class BaiduMobSspAdNetworkRegistry;

@interface BaiduMobSspAdNetworkConfig : NSObject {
    BaiduMobSspAdNetworkType networkType;
    NSString *nid;
    NSString *networkName;
    double trafficPercentage;
    NSInteger priority;
    NSMutableDictionary *credentials;
    Class adapterClass;
    int strategyId;
}

- (id)initWithDictionary:(NSDictionary *)adNetConfigDict
       adNetworkRegistry:(BaiduMobSspAdNetworkRegistry *)registry
                   error:(BaiduMobSspError **)error;

@property (nonatomic,readonly) BaiduMobSspAdNetworkType networkType;
@property (nonatomic,readonly) NSString *nid;
@property (nonatomic,readonly) NSString *networkName;
@property (nonatomic,readonly) double trafficPercentage;
@property (nonatomic,readonly) NSInteger priority;
@property (nonatomic,readonly) NSMutableDictionary *credentials;
@property (nonatomic,readonly) NSString *pubId;
@property (nonatomic,readonly) Class adapterClass;
@property (nonatomic,readonly) int strategyId;

@end
