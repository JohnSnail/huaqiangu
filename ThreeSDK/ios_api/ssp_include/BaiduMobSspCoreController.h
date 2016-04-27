//
//  BaiduMobSspCoreController.h
//  BaiduMobSsp
//
//  Created by dengjinxiang on 14-5-13.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaiduMobSspBannerDelegateProtocol.h"
#import "BMSNetworkReachabilityWrapper.h"
#import "BaiduMobSspConfig.h"
#import "BaiduMobSspAdNetworkAdapter.h"
#import "BaiduMobSspBannerView.h"

@class BaiduMobSspAdNetworkConfig;
@class BaiduMobSspConfigStore;

@interface BaiduMobSspCoreController : NSObject <BaiduMobSspConfigDelegate,
                                 BMSNetworkReachabilityDelegate> 

/**
 * You can set the delegate to nil or another object.
 * Make sure you set the delegate to nil when you release an BaiduMobSspView
 * instance to avoid the BaiduMobSspView from calling to a non-existent delegate.
 * If you set the delegate to another object, note that if the new delegate
 * returns a different value for baiduMobSspApplicationKey, it will not overwrite
 * the application key provided by the delegate you supplied for
 * +requestBaiduMobSspViewWithDelegate .
 */
@property (nonatomic, assign) IBOutlet id<BaiduMobSspDelegate> delegate;
@property (nonatomic) BOOL showingModalView;
@property (nonatomic) BaiduMobSspAdViewType adViewType;
@property (nonatomic,assign)BaiduMobSspBannerView *bannerView;
/**
 * Call this method to get a view object that you can add to your own view. You
 * must also provide a delegate.  The delegate provides BaiduMobSsp's application
 * key and can listen for important messages.  You can configure the view's
 * settings and specific ad network information on BaiduMobSsp.com or your own
 * BaiduMobSsp server instance.
 */
- (id)initWithDelegate:(id<BaiduMobSspDelegate>)delegate bannerView:(BaiduMobSspBannerView*) baiduBannerView;

#pragma mark For ad network adapters use only

/**
 * Called by Adapters when there's a new ad view.
 */
- (void)adapter:(BaiduMobSspAdNetworkAdapter *)adapter
                                              didReceiveAdView:(UIView *)view;
/**
 * Called by Adapters when ad view failed.
 */
- (void)adapter:(BaiduMobSspAdNetworkAdapter *)adapter didFailAd:(NSError *)error;
/**
 * Called by Adapters when user click a ad.
 */
- (void)adapter:(BaiduMobSspAdNetworkAdapter *)adapter didClick:(UIView *)view;

/**
 * Called by Adapters when user click iap ad.
 */
- (void)adapter:(BaiduMobSspAdNetworkAdapter *)adapter didIAPClick:(UIView *)view productID:(NSString *)productID;

/**
 * Called by Adapters when the ad request is finished, but the ad view is
 * furnished elsewhere. e.g. Generic Notification
 */
- (void)adapterDidFinishAdRequest:(BaiduMobSspAdNetworkAdapter *)adapter;

@end
