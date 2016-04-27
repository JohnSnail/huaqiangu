//
//  BaiduMobSspView.h
//  BaiduMobSsp
//
//  Created by dengjinxiang on 14-5-13.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaiduMobSspBannerDelegateProtocol.h"
#import "BaiduMobSspAdViewType.h"

@interface BaiduMobSspBannerView : UIView
/**
 * delegate委托提供应用id，并且监听广告生命周期中的重要信息
 */
@property (nonatomic, assign) id<BaiduMobSspDelegate> delegate;

/**
 * 初始化实例
 */
//- (id)initWithDelegate:(id<BaiduMobSspDelegate>)delegate frame:(CGRect)f;

/*
 ak:开发appkey
 type:请求广告类型
 delegate:代理对象
 */
- (id) initWithAdType:(BaiduMobSspAdViewType)type
   baiduMobSspViewDelegate:(id<BaiduMobSspDelegate>) delegate;

@end
