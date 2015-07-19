//
//  MainController.h
//  huaqiangu
//
//  Created by Jiangwei on 15/7/18.
//  Copyright (c) 2015年 Jiangwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFService.h"
#import "ApiHeader.h"

@interface MainController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTbView;
@property (nonatomic, strong) NSMutableArray *mainMuArray;

@end
