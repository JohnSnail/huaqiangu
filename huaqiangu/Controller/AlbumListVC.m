//
//  AlbumListVC.m
//  huaqiangu
//
//  Created by JiangWeiGuo on 2016/9/18.
//  Copyright © 2016年 Jiangwei. All rights reserved.
//

#import "AlbumListVC.h"
#import "AlbumModel.h"
#import "AlbumCell.h"
#import "MainController.h"
#import "PlayController.h"

@interface AlbumListVC ()<UITableViewDelegate,UITableViewDataSource>{
    UIButton *playBtn;
    NSInteger totalPage;
    NSInteger currentPage;
}

@end

@implementation AlbumListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    currentPage = 1;
    self.albumTbview.backgroundColor = RGB(230, 227, 219);
    self.navigationItem.titleView = [CommUtils navTittle:ALBUMTITLE];

    self.navigationItem.leftBarButtonItem = [LMButton setNavright:@"吐槽" andcolor:[UIColor whiteColor] andSelector:@selector(pushAppStore) andTarget:self];
    
    self.albumTbview.frame = CGRectMake(0, 0, mainscreenwidth, mainscreenhight);
    _albumMuArray = [NSMutableArray arrayWithCapacity:0];
    [self getAlbumListData:currentPage andPageSize:20 andTagName:kAlbumName];
    
    self.albumTbview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self loadMoreData];
    }];
}

-(void)loadMoreData
{
    if (currentPage > totalPage || currentPage == totalPage) {
        self.albumTbview.footer = nil;
        return;
    }else{
        currentPage ++;
        [self getAlbumListData:currentPage andPageSize:20 andTagName:kAlbumName];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self playAnimation];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark -
#pragma mark - 播放动画

-(void)playAnimation
{
    if (![PlayController sharedPlayController].playTrack) {
        playBtn.hidden = YES;
        return;
    }else{
        playBtn.hidden = NO;
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
}

#pragma mark -
#pragma mark - 正在播放
-(void)playingAction
{
    //判断网络环境，数据流量下不播放
    if ([CommUtils checkNetworkStatus] != ReachableViaWiFi) {
        [UIAlertView showWithTitle:@"温馨提示" message:@"当前处于非Wi-Fi网络，在线播放可能会消耗您的流量，是否继续？" cancelButtonTitle:@"取消" otherButtonTitles:@[@"继续"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == [alertView cancelButtonIndex]) {
                return ;
            }else{
                [self pushPlayVC:[CommUtils getPlayIndex]];
            }
        }];
    }else{
        [self pushPlayVC:[CommUtils getPlayIndex]];
    }
}

-(void)pushPlayVC:(NSInteger)indexPlay
{
    PlayController *playVC = [PlayController sharedPlayController];
    playVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:playVC animated:YES];
}

#pragma mark - 给好评

-(void)pushAppStore
{
    if ([MFMailComposeViewController canSendMail]) { // 用户已设置邮件账户
        [self sendEmailAction]; // 调用发送邮件的代码
    }else{
        NSString * url;
        if (IS_IOS_7) {
            url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", AppStoreAppId];
        }
        else{
            url=[NSString stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",AppStoreAppId];
        }
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

#pragma mark -
#pragma mark - 发送邮件

- (void)sendEmailAction
{
    // 邮件服务器
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    // 设置邮件代理
    [mailCompose setMailComposeDelegate:self];
    
    // 设置邮件主题
    [mailCompose setSubject:@"我要吐槽"];
    
    // 设置收件人
    [mailCompose setToRecipients:@[@"jason_name@163.com"]];
    
    /**
     *  设置邮件的正文内容
     */
    NSString *emailContent = @"我是邮件内容";
    // 是否为HTML格式
    [mailCompose setMessageBody:emailContent isHTML:NO];
    // 如使用HTML格式，则为以下代码
    //    [mailCompose setMessageBody:@"<html><body><p>Hello</p><p>World！</p></body></html>" isHTML:YES];
    // 弹出邮件发送视图
    [self presentViewController:mailCompose animated:YES completion:nil];
}

#pragma mark - 邮箱代理

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled: // 用户取消编辑
            NSLog(@"Mail send canceled...");
            break;
        case MFMailComposeResultSaved: // 用户保存邮件
            NSLog(@"Mail saved...");
            break;
        case MFMailComposeResultSent: // 用户点击发送
            NSLog(@"Mail sent...");
            break;
        case MFMailComposeResultFailed: // 用户尝试保存或发送邮件失败
            NSLog(@"Mail send errored: %@...", [error localizedDescription]);
            break;
    }
    
    // 关闭邮件发送视图
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)getAlbumListData:(NSInteger)pageId andPageSize:(NSInteger)pageSize andTagName:(NSString *)tagName
{
    if (pageId == 1) {
        [self.albumMuArray removeAllObjects];
    }
    __weak typeof(self) bSelf = self;
    NSDictionary *params = @{@"calcDimension":@"hot",@"categoryId":kAlbumID,@"device":@"ios",@"pageId":@(pageId),@"pageSize":@(pageSize),@"status":@(0),@"tagName":tagName};
    
    [AFService postMethod:kAlbumList andDict:params completion:^(NSDictionary *results,NSError *error){
        
        totalPage = [[results objectForKey:@"maxPageId"] integerValue];
        NSArray *arr = [results objectForKey:@"list"];
        for (int i=0; i<arr.count; i++) {
            NSDictionary *dic = [arr objectAtIndex:i];
            AlbumModel *album = [[AlbumModel alloc]initWithDict:dic];
            [bSelf.albumMuArray addObject:album];
        }
        [self.albumTbview reloadData];
        [self.albumTbview.footer endRefreshing];
    }];
     
}

#pragma mark - tableview代理方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.albumMuArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100 * VIEWWITH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MainCellIdentifier = @"AlbumCell";
    AlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:MainCellIdentifier];
    if (!cell) {
        cell = (AlbumCell *)CREAT_XIB(@"AlbumCell");
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }

    AlbumModel *album = [self.albumMuArray objectAtIndex:indexPath.row];
    [cell setAlbumCell:album];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlbumModel *album = [self.albumMuArray objectAtIndex:indexPath.row];
    MainController *mainVC = [[MainController alloc]init];
    mainVC.albumID = album.albumId;
    mainVC.albumTitle = album.title;
    [self.navigationController pushViewController:mainVC animated:YES];
}

@end
