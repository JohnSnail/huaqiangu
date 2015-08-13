//
//  MainController.m
//  huaqiangu
//
//  Created by Jiangwei on 15/7/18.
//  Copyright (c) 2015年 Jiangwei. All rights reserved.
//

#import "MainController.h"
#import "TrackModel.h"
#import "PlayController.h"

@interface MainController ()
{
    NSInteger pageId;
    NSInteger totalPage;
    NSString *albumTitle;
    UIButton *playBtn;
}

@end

@implementation MainController

static NSInteger i = 0;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.mainTbView.backgroundColor = RGB(230, 227, 219);
    self.navigationController.navigationBarHidden = NO;
    [self.mainTbView reloadData];
    [self playAnimation];
}

-(void)scrollViewToIndex
{
    if (i == 0) {
        if ([CommUtils getPlayIndex] < self.mainMuArray.count) {
            ;
        }
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:[CommUtils getPlayIndex] inSection:0];
        [self.mainTbView scrollToRowAtIndexPath:scrollIndexPath
                               atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        i++;
    }
}

#pragma mark - 
#pragma mark - 播放动画

-(void)playAnimation
{
    if (!playBtn) {
        playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    if (IS_IOS_7) {
        playBtn.frame = CGRectMake(mainscreenwidth - 50,0, 40, 40);
    }else{
        playBtn.frame = CGRectMake(mainscreenwidth - 50,20, 40, 40);
    }
    playBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -20);
    [playBtn setImage:[UIImage imageNamed:@"play_1"] forState:UIControlStateNormal];
    [CommUtils navigationPlayButtonItem:playBtn];
    
    [playBtn addTarget:self action:@selector(playingAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:playBtn];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.leftBarButtonItem = [LMButton setNavright:@"好评" andcolor:[UIColor whiteColor] andSelector:@selector(pushAppStore) andTarget:self];
    self.navigationItem.titleView = [CommUtils navTittle:ALBUMTITLE];
    
    pageId = 1;
    _mainMuArray = [NSMutableArray arrayWithCapacity:0];

    self.mainTbView.frame = CGRectMake(0, 0, mainscreenwidth, mainscreenhight);
    [self getNetData];

    self.mainTbView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self loadMoreData];
    }];
}

#pragma mark - 
#pragma mark - 正在播放
-(void)playingAction
{
    PlayController *playVC = [PlayController sharedPlayController];
    playVC.hidesBottomBarWhenPushed = YES;
    if (self.mainMuArray.count != 0) {
        [playVC pushArr:self.mainMuArray andIndex:[CommUtils getPlayIndex]];
    }
    [self.navigationController pushViewController:playVC animated:YES];
}

#pragma mark - 给好评
-(void)pushAppStore
{
    NSString * url;
    if (IS_IOS_7) {
        url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", AppStoreAppId];
    }
    else{
        url=[NSString stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",AppStoreAppId];
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

//上拉刷新
-(void)loadMoreData
{
    if (pageId < totalPage) {
        pageId ++;
        [self getNetData];
    }else{
        [self.mainTbView.footer noticeNoMoreData];
    }
}

-(void)getNetData
{
    if (pageId == 1) {
        [self.mainMuArray removeAllObjects];
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@/30",@(pageId)];
    NSString *postStr = [NSString stringWithFormat:@"%@%@%@",kMainHeader,urlStr,kDevice];
    
    __weak typeof(self) bSelf = self;
    [AFService postMethod:postStr andDict:nil completion:^(NSDictionary *results,NSError *error){
        totalPage = [[[results objectForKey:@"tracks"] objectForKey:@"maxPageId"] integerValue];
        
        NSArray *arr = [[results objectForKey:@"tracks"] objectForKey:@"list"];

        for (int i = 0; i < arr.count; i++) {
            TrackModel *track = [[TrackModel alloc]initWithDict:arr[i]];
//            NSString *strTitle = [NSString stringWithFormat:@"七星鲁王宫%@",track.title];
//            track.title = strTitle;
            
            [bSelf.mainMuArray addObject:track];
        }
        [bSelf.mainTbView reloadData];
        [bSelf.mainTbView.footer endRefreshing];
        
        if (bSelf.mainMuArray.count != 0) {
            if (bSelf.mainMuArray.count >= [CommUtils getPlayIndex]) {
                [bSelf scrollViewToIndex];
            }else{
                [self loadMoreData];
            }
        }
    }];
}

#pragma mark - tableview代理方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mainMuArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = RGB(230, 227, 219);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor blackColor];
    }
    TrackModel *track = self.mainMuArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.text = track.title;
    
    if (indexPath.row == [CommUtils getPlayIndex]) {
        cell.textLabel.textColor = RGB(76, 193, 211);
    }else{
        cell.textLabel.textColor = [UIColor blackColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayController *playVC = [PlayController sharedPlayController];
    playVC.hidesBottomBarWhenPushed = YES;
    [playVC pushArr:self.mainMuArray andIndex:indexPath.row];
    [self.navigationController pushViewController:playVC animated:YES];
}

@end
