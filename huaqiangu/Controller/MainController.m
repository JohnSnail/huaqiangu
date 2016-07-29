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
#import "DownController.h"
#import "MainList.h"
#import "MainCell.h"
#import "HSDownloadManager.h"

#define COUNT 30

@interface MainController ()
{
    NSInteger pageId;
    NSInteger totalPage;
    NSString *albumTitle;
    UIButton *playBtn;
    NSInteger totalTracks;
    NSString *orderStr;
    DownloadState downStatus;
}

@end

@implementation MainController

static NSInteger i = 0;
static NSInteger j = 0;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.mainTbView.backgroundColor = RGB(230, 227, 219);
    self.navigationController.navigationBarHidden = NO;
    
    [self.mainTbView reloadData];
    [self playAnimation];
    
    NSLog(@"downStatus = %u", downStatus);
    if (downStatus !=  DownloadStateStart) {
        [self automaticDownloads];
    }
}

-(void)scrollViewToIndex
{
    if (i == 0) {
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

#pragma mark - 
#pragma mark - 初始化排序和下载按钮
-(void)initDownOrderAction
{
    [self.downBtn setBackgroundImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    [self.orderBtn setBackgroundImage:[UIImage imageNamed:orderStr] forState:UIControlStateNormal];
    
    [self.downBtn addTarget:self action:@selector(downAction) forControlEvents:UIControlEventTouchUpInside];
    [self.orderBtn addTarget:self action:@selector(orderAction) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 
#pragma mark - 下载按钮触发方法
-(void)downAction
{
    DownController *downVC = [DownController sharedManager];
    KKNavigationController *nacVC = [[KKNavigationController alloc] initWithRootViewController:downVC];
    [nacVC.navigationBar setBarTintColor:kCommenColor];
    [self.navigationController presentViewController:nacVC animated:YES completion:^{
        [downVC getDownData];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    downStatus = DownloadStateCompleted;//初始化下载状态
    self.navigationItem.leftBarButtonItem = [LMButton setNavright:@"吐槽" andcolor:[UIColor whiteColor] andSelector:@selector(pushAppStore) andTarget:self];

    self.navigationItem.titleView = [CommUtils navTittle:ALBUMTITLE];
    
    pageId = 1;
    _mainMuArray = [NSMutableArray arrayWithCapacity:0];
    _downMuArray = [NSMutableArray arrayWithCapacity:0];
    _needDownMuArray = [NSMutableArray arrayWithCapacity:0];

    self.mainTbView.frame = CGRectMake(0, 0, mainscreenwidth, mainscreenhight);
    orderStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"orderStr"];
    if (!orderStr) {
        orderStr = @"true";
    }

    if ([CommUtils checkNetworkStatus] == NotReachable) {
        [self getDownArray];
    }else{
        [self getNetData];
    }
    
    UIColor *comColor = [UIColor whiteColor];
    NSDictionary *colorAttr = [NSDictionary dictionaryWithObject:comColor forKey:NSForegroundColorAttributeName];
    [self.chooseSeg setTitleTextAttributes:colorAttr forState:UIControlStateNormal];
    self.chooseSeg.tintColor = [UIColor whiteColor];
    [self.chooseSeg addTarget:self action:@selector(didClicksegmentedControlAction:)forControlEvents:UIControlEventValueChanged];
    
    [self initDownOrderAction];
    
    [self setFrameView];
    
    //上下一曲通知更新列表
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reloadMainList) name: @"reloadAction" object: nil];
    
    self.orderBtn.hidden = YES;
    
    self.mainTbView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self loadMoreData];
    }];
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


-(void)setFrameView
{
    [self.downBtn setAdjustsImageWhenHighlighted:NO];
    [self.orderBtn setAdjustsImageWhenHighlighted:NO];
    
    self.downBtn.frame = CGRectMake(10 * VIEWWITH, 8 * VIEWWITH, 30 * VIEWWITH, 30 * VIEWWITH);
    self.orderBtn.frame = CGRectMake(287 * VIEWWITH, 13 * VIEWWITH, 23 * VIEWWITH, 23 * VIEWWITH);
    self.chooseSeg.frame = CGRectMake(120 * VIEWWITH, 11 * VIEWWITH, 81 * VIEWWITH, 29 * VIEWWITH);
}

-(void)reloadMainList
{
    [self.mainTbView reloadData];
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

-(void)getDownArray{
    
//    self.mainTbView.footer = nil;
    
    NSMutableArray *downArray = [NSMutableArray arrayWithCapacity:0];
    self.mainMuArray = [NSMutableArray arrayWithArray:[[MainList sharedManager] getMainArray]];
    
    for (int i = 0; i < self.mainMuArray.count; i++) {
        TrackModel *track = self.mainMuArray[i];
        if ([track.downStatus isEqualToString:@"done"]) {
            [downArray addObject:track];
        }
    }
    
    [self.mainMuArray removeAllObjects];
    self.mainMuArray = [NSMutableArray arrayWithArray:downArray];
    [self.mainTbView reloadData];
}

#pragma mark -
#pragma mark - UISegmentedControl 方法

-(void)didClicksegmentedControlAction:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    NSLog(@"Index %li", (long)Index);
    switch (Index) {
        case 0:{
            [self getMainData];
        }
            break;
        case 1:{
            [self getDownArray];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 排序
-(void)orderAction
{
    NSInteger playIndex = [CommUtils getPlayIndex];
    if ([orderStr isEqualToString:@"false"]) {
        orderStr = @"true";
    }else{
        orderStr = @"false";
    }
    [CommUtils saveIndex:(totalTracks - 1 - playIndex)];
    [[NSUserDefaults standardUserDefaults] setObject:orderStr forKey:@"orderStr"];
    pageId = 1;
    [self getNetData];
    
    [self.orderBtn setBackgroundImage:[UIImage imageNamed:orderStr] forState:UIControlStateNormal];
}

//上拉刷新
-(void)loadMoreData
{
    if (pageId < totalPage) {
        pageId ++;
        [self getNetData];
    }else{
//        [self.mainTbView.footer noticeNoMoreData];
        self.mainTbView.footer = nil;
    }
}


//#pragma mark - 
//#pragma mark - 获取首页数据

-(void)getMainData
{
    self.mainTbView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self loadMoreData];
    }];
    
     self.mainMuArray = [NSMutableArray arrayWithArray:[[MainList sharedManager] getMainArray]];
    if (self.mainMuArray.count != 0) {
        pageId = ceilf((float)self.mainMuArray.count / COUNT);
        totalPage = pageId + 1;
        
        [self.mainTbView reloadData];
        [self scrollViewToIndex];
        
    }
    [self getNetData];
}

-(void)getNetData
{
    if (pageId == 1) {
        [self.mainMuArray removeAllObjects];
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",@(pageId),@(COUNT)];
    NSString *postStr = [NSString stringWithFormat:@"%@%@/%@/%@%@",kMainHeader,kMainIDArr[j],orderStr,urlStr,kDevice];
    
    __weak typeof(self) bSelf = self;
    [AFService postMethod:postStr andDict:nil completion:^(NSDictionary *results,NSError *error){
        
        if([[results objectForKey:@"ret"] integerValue] != 0){
            if(j < kMainIDArr.count){
                j++;
                [self getNetData];
            }
        }
        
        totalTracks = [[[results objectForKey:@"album"] objectForKey:@"tracks"] integerValue];
        
        totalPage = [[[results objectForKey:@"tracks"] objectForKey:@"maxPageId"] integerValue];
        
        NSArray *arr = [[results objectForKey:@"tracks"] objectForKey:@"list"];

        for (int i = 0; i < arr.count; i++) {
            TrackModel *track = [[TrackModel alloc]initWithDict:arr[i]];
            track.downStatus = @"on";
            [bSelf.mainMuArray addObject:track];
        }
        
        [bSelf.mainTbView reloadData];
        [bSelf.mainTbView.footer endRefreshing];
        
        if (bSelf.mainMuArray.count != 0) {
            if (bSelf.mainMuArray.count > [CommUtils getPlayIndex]) {
                [bSelf scrollViewToIndex];
            }else{
                [self loadMoreData];
            }
        }
        
        if ([CommUtils checkNetworkStatus] == ReachableViaWiFi) {
            [self.needDownMuArray removeAllObjects];
            
            for (int i = 0; i<self.mainMuArray.count; i++) {
                TrackModel *track = self.mainMuArray[i];
                track.orderStr = [NSString stringWithFormat:@"%d",i];
                if (![track.downStatus isEqualToString:@"done"]) {
                    [self.needDownMuArray addObject:track];
                }
            }
            if (downStatus !=  DownloadStateStart) {
                [self automaticDownloads];
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
    static NSString *MainCellIdentifier = @"MainCell";
    MainCell *cell = [tableView dequeueReusableCellWithIdentifier:MainCellIdentifier];
    if (!cell) {
        cell = (MainCell *)CREAT_XIB(@"MainCell");
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    TrackModel *track = self.mainMuArray[indexPath.row];
    TrackModel *newTrack = [[MainList sharedManager] updateModel:track];
    if (newTrack) {
        track.downStatus = newTrack.downStatus;
    }
    cell.titleLabel.text = track.title;
    cell.downLabel.text = @"在线";
    cell.downLabel.textColor = kCommenColor;

//    if ([track.downStatus isEqualToString:@"done"]) {
//        cell.downLabel.text = @"本地";
//        cell.downLabel.textColor = [UIColor darkGrayColor];
//    }else if([track.downStatus isEqualToString:@"doing"]){
//        if([CommUtils checkNetworkStatus] == ReachableViaWiFi){
//            NSInteger proIndex = [[HSDownloadManager sharedInstance] progress:track.playUrl64] * 100;
//            cell.downLabel.text = [NSString stringWithFormat:@"%ld%%",proIndex];
//        }else{
//            cell.downLabel.text = @"暂停";
//        }
//        cell.downLabel.textColor = kCommenColor;
//    }else{
//        cell.downLabel.text = @"在线";
//        cell.downLabel.textColor = kCommenColor;
//    }
    
    if (indexPath.row == [CommUtils getPlayIndex]){
        cell.titleLabel.textColor = kCommenColor;

        NSMutableString *muStr = [NSMutableString stringWithString:track.title];
        if (muStr.length > 20) {
            cell.titleLabel.moveSpeech = -50.0f;
        }else{
            cell.titleLabel.moveSpeech = 0;
        }
    }else{
        cell.titleLabel.textColor = [UIColor blackColor];
        cell.titleLabel.moveSpeech = 0;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrackModel *track = self.mainMuArray[indexPath.row];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:HSFileFullpath(track.playUrl64)]){
        [self pushPlayVC:indexPath.row];
    }else if ([CommUtils checkNetworkStatus] != ReachableViaWiFi) {
        [UIAlertView showWithTitle:@"温馨提示" message:@"当前处于非Wi-Fi网络，在线播放可能会消耗您的流量，是否继续？" cancelButtonTitle:@"取消" otherButtonTitles:@[@"继续"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == [alertView cancelButtonIndex]) {
                return ;
            }else{
                [self pushPlayVC:indexPath.row];
            }
        }];
    }else{
        [self pushPlayVC:indexPath.row];
    }
}

-(void)pushPlayVC:(NSInteger)indexPlay
{
    PlayController *playVC = [PlayController sharedPlayController];
    playVC.hidesBottomBarWhenPushed = YES;
    if (self.mainMuArray.count != 0) {
        [playVC pushArr:self.mainMuArray andIndex:indexPlay];
    }
    [self.navigationController pushViewController:playVC animated:YES];
}



#pragma mark 开启任务下载资源
- (void)download:(NSString *)url progressLabel:(UILabel *)progressLabel progressView:(UIProgressView *)progressView button:(UIButton *)button
{
    [[HSDownloadManager sharedInstance] download:url progress:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateDownView:progress];
        });
    } state:^(DownloadState state) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            downStatus = state;
            
            if (state == DownloadStateCompleted) {
                TrackModel *track = self.needDownMuArray[0];
                track.downStatus = @"done";
                [[MainList sharedManager] saveContent:track];
                
                [self.mainTbView reloadData];
                
                [self.needDownMuArray removeObjectAtIndex:0];
                [self automaticDownloads];
            }
        });
    }];
}

#pragma mark 按钮状态
- (NSString *)getTitleWithDownloadState:(DownloadState)state
{
    switch (state) {
        case DownloadStateStart:
            return @"暂停";
        case DownloadStateSuspended:
        case DownloadStateFailed:
            return @"开始";
        case DownloadStateCompleted:
            return @"完成";
        default:
            break;
    }
}

-(void)automaticDownloads
{
//    if (self.needDownMuArray.count != 0 && [CommUtils checkNetworkStatus] == ReachableViaWiFi) {
//        TrackModel *track = self.needDownMuArray[0];
//        track.downStatus = @"doing";
//        [[MainList sharedManager] saveContent:track];
//        
//        NSIndexPath *indexP = [NSIndexPath indexPathForRow:track.orderStr.integerValue inSection:0];
//        MainCell *newCell = [self.mainTbView cellForRowAtIndexPath:indexP];
//        
//        [self download:track.playUrl64 progressLabel:newCell.downLabel progressView:nil button:nil];
//    }
}

#pragma mark - 下载进度

-(void)updateDownView:(CGFloat)progress
{
    TrackModel *track = self.needDownMuArray[0];
    NSInteger integer = progress * 100;
    NSIndexPath *indexP = [NSIndexPath indexPathForRow:track.orderStr.integerValue inSection:0];
    MainCell *newCell = [self.mainTbView cellForRowAtIndexPath:indexP];
    newCell.downLabel.text =  [NSString stringWithFormat:@"%ld%%",integer];
}

@end
