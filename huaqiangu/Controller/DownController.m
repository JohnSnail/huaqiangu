//
//  DownController.m
//  huaqiangu
//
//  Created by JiangWeiGuo on 16/2/23.
//  Copyright © 2016年 Jiangwei. All rights reserved.
//

#import "DownController.h"
#import "DownCell.h"

@interface DownController ()

@end

@implementation DownController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self naviAction];
    [self initDownAction];
}

#pragma mark - 
#pragma mark - 获取页面数据
-(void)sendArray:(NSMutableArray *)array
{
    TrackModel *newModel = [[TrackModel alloc]init];
    newModel.title = @"全选";
    [self.downMuArray addObject:newModel];
    [self.downMuArray addObjectsFromArray:array];
    [self.downTbView reloadData];
}

#pragma mark - 
#pragma mark - 导航栏处理
-(void)naviAction
{
    self.navigationItem.leftBarButtonItem = [LMButton setNavleftButtonWithImg:@"back" andSelector:@selector(backAction) andTarget:self];
    self.navigationItem.titleView = [CommUtils navTittle:@"选择节目"];
}

-(void)backAction
{
    [self dismissViewControllerAnimated:YES completion:^{
        self.downMuArray = nil;
        self.downTbView = nil;
    }];
}

#pragma mark - 
#pragma mark - 初始化相关参数
-(void)initDownAction
{
    self.downTbView.frame = CGRectMake(0, 0, mainscreenwidth, mainscreenhight - 50);
    self.downFootView.frame = CGRectMake(0, mainscreenhight - 50, mainscreenwidth, 50);
    
    _downMuArray = [NSMutableArray arrayWithCapacity:0];
    self.downTbView.backgroundColor = RGB(230, 227, 219);
    self.downFootView.backgroundColor = kCommenColor;
    
    [self.downBtn setTitle:@"下载" forState:UIControlStateNormal];
    [self.downBtn addTarget:self action:@selector(downAction) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 
#pragma mark - 下载方法
-(void)downAction{
    NSLog(@"下载");
}

#pragma mark - tableview代理方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.downMuArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MainCellIdentifier = @"DownCell";
    
    DownCell *cell = [tableView dequeueReusableCellWithIdentifier:MainCellIdentifier];
    if (!cell) {
        cell = (DownCell *)CREAT_XIB(@"DownCell");
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.nameLabel.textColor = [UIColor blackColor];
    }
    TrackModel *track = self.downMuArray[indexPath.row];
    cell.nameLabel.font = [UIFont systemFontOfSize:16];
    cell.nameLabel.text = track.title;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DownCell * newCell = (DownCell *)[self.downTbView cellForRowAtIndexPath:indexPath];
    newCell.chooseBtn.selected = !newCell.chooseBtn.selected;
}

@end
