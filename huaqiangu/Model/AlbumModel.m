//
//  AlbumModel.m
//  huaqiangu
//
//  Created by JiangWeiGuo on 2016/9/18.
//  Copyright © 2016年 Jiangwei. All rights reserved.
//

#import "AlbumModel.h"

@implementation AlbumModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
            if (![obj isKindOfClass:[NSNull class]]) {
                SEL se = NSSelectorFromString(key);
                if ([self respondsToSelector:se]) {
                    [self setValue:obj forKey:key];
                }
            }
        }];
    }
    return self;
}

@end
