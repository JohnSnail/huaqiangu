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
#import <MessageUI/MessageUI.h>

@interface MainController : UIViewController<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTbView;
@property (weak, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *chooseSeg;
@property (weak, nonatomic) IBOutlet UIButton *downBtn;
@property (weak, nonatomic) IBOutlet UIButton *orderBtn;
@property (nonatomic, strong) NSMutableArray *mainMuArray;
@property (nonatomic, strong) NSMutableArray *downMuArray;
@property (nonatomic, strong) NSMutableArray *needDownMuArray;

@end
