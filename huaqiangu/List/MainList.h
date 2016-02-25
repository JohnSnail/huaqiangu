//
//  MainList.h
//  huaqiangu
//
//  Created by JiangWeiGuo on 16/2/25.
//  Copyright © 2016年 Jiangwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainList : NSObject
{
    FMDatabase *_db;
}

+ (MainList *)sharedManager;

//创建数据库
-(void)createDataBase;

//保存一条记录
-(void)saveContent:(TrackModel *)track;

//删除一条记录
-(void)deleteContent:(TrackModel *)track;

//修改节目信息
-(void)mergeWithContent:(TrackModel *)track;

//获取主页面数据
-(NSArray *)getMainArray;

@end
