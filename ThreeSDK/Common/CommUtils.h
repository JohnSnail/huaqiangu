//
//  CommUtils.h
//  jianzhi
//
//  Created by Jiangwei on 15/5/27.
//  Copyright (c) 2015年 li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommUtils : NSObject

//定制navigation的title
+(UILabel *)navTittle:(NSString *)title;
+(NSString *)progressValue:(double)value;

//保存正在播放的节目
+(void)saveIndex:(NSInteger)index;
+(NSInteger)getPlayIndex;

//正在播放
+ (void)navigationPlayButtonItem:(UIButton *)btn;
@end
