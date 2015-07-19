//
//  TrackModel.h
//  huaqiangu
//
//  Created by Jiangwei on 15/7/18.
//  Copyright (c) 2015年 Jiangwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrackModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *playUrl64;
@property (nonatomic, copy) NSString *hisProgress;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
