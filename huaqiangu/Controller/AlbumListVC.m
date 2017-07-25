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
#import "WebVC.h"
#import "LSYReadPageViewController.h"

@interface AlbumListVC ()<UITableViewDelegate,UITableViewDataSource,GADBannerViewDelegate,SKStoreProductViewControllerDelegate>{
    UIButton *playBtn;
    NSInteger totalPage;
    NSInteger currentPage;
    GADBannerView *adBannerView;
}


@end

@implementation AlbumListVC

#pragma mark -得到当前时间
- (NSDate *)getCurrentTime{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd-MM-yyyy-HHmmss"];
    NSString *dateTime=[formatter stringFromDate:[NSDate date]];
    NSDate *date = [formatter dateFromString:dateTime];
    
    NSLog(@"---------- currentDate == %@",date);
    return date;
}

- (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy-HHmmss"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    currentPage = 1;
    self.view.backgroundColor = RGB(230, 227, 219);
    self.albumTbview.backgroundColor = RGB(230, 227, 219);
    self.navigationItem.titleView = [CommUtils navTittle:ALBUMTITLE];

    self.navigationItem.leftBarButtonItem = [LMButton setNavright:@"反馈" andcolor:[UIColor whiteColor] andSelector:@selector(pushAppStore) andTarget:self];
    
    self.albumTbview.frame = CGRectMake(0, 0, mainscreenwidth, mainscreenhight);
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy-HHmmss"];
    NSDate *date = [dateFormatter dateFromString:kData];
    
    if([self compareOneDay:[self getCurrentTime] withAnotherDay:date] != -1){
        self.albumTbview.tableHeaderView = [self addAdView];
    }
    
    //添加admob广告
//    [self admobAD];
    
    _albumMuArray = [NSMutableArray arrayWithCapacity:0];
    
    self.albumTbview.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //Call this Block When enter the refresh status automatically
        [self getRankListData:1 andPageSize:20];
//        [self.albumTbview.header endRefreshing];
    }];
    
    [self.albumTbview.header beginRefreshing];
    
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
        [self getRankListData:currentPage andPageSize:20];
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
//    if ([MFMailComposeViewController canSendMail]) { // 用户已设置邮件账户
//        [self sendEmailAction]; // 调用发送邮件的代码
//    }else{
        NSString * url;
        if (IS_IOS_7) {
            url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", AppStoreAppId];
        }
        else{
            url=[NSString stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",AppStoreAppId];
        }
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
//    }
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
    [mailCompose setSubject:@"我要反馈"];
    
    // 设置收件人
    [mailCompose setToRecipients:@[@"jason_name@163.com"]];
    
    /**
     *  设置邮件的正文内容
     */
    NSString *emailContent = @"我是邮件内容";
    // 是否为HTML格式
    [mailCompose setMessageBody:[NSString stringWithFormat:@"%@-%@",ALBUMTITLE,emailContent] isHTML:NO];
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

-(void)getRankListData:(NSInteger)pageId andPageSize:(NSInteger)pageSize
{
    //?device=iPhone&pageId=1&pageSize=20&rankingListId=21&scale=2&target=main&version=5.4.33
    if (pageId == 1) {
        [self.albumMuArray removeAllObjects];
    }
    __weak typeof(self) bSelf = self;
    
    //http://search.ximalaya.com/front/v1?condition=play&core=album&device=iPhone&kw=%E9%AC%BC%E5%90%B9%E7%81%AF&live=true&page=2&paidFilter=false&rows=20&version=5.4.33
    
    //    http://mobile.ximalaya.com/mobile/discovery/v3/rankingList/album?device=iPad&pageId=1&pageSize=20&rankingListId=21&scale=3&target=main&version=5.4.33
    
    //http://mobile.ximalaya.com/mobile/discovery/v1/category/album?calcDimension=hot&categoryId=12&device=ios&pageId=1&pageSize=20&status=0&tagName=%E9%83%AD%E5%BE%B7%E7%BA%B2%E7%9B%B8%E5%A3%B0
    
//    NSDictionary *params = @{@"device":@"ios",@"pageId":@(pageId),@"pageSize":@(pageSize),@"calcDimension":@"hot",@"categoryId":kAlbumID,@"status":@(0),@"tagName":kAlbumName};
//    NSDictionary *params = @{@"page":@(pageId)};
    NSDictionary *params = @{@"device":@"iPhone",@"pageId":@(pageId),@"pageSize":@(pageSize),@"rankingListId":@"21",@"scale":@"3",@"target":@"main",@"version":@"6.3.6"};
    
//    NSDictionary *params = @{@"pageId":@(pageId),@"pageSize":@(pageSize)};//庶女
    
    [AFService getMethod:kListAlbum andDict:params completion:^(NSDictionary *results,NSError *error){
        
        totalPage = [[results objectForKey:@"maxPageId"] integerValue];
        NSArray *arr = [results objectForKey:@"list"];
        for (int i=0; i<arr.count; i++) {
            NSDictionary *dic = [arr objectAtIndex:i];
            AlbumModel *album = [[AlbumModel alloc]initWithDict:dic];
            [bSelf.albumMuArray addObject:album];
        }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy-HHmmss"];
        NSDate *date = [dateFormatter dateFromString:kData];
        
        if([bSelf compareOneDay:[bSelf getCurrentTime] withAnotherDay:date] != -1){
            
            NSArray *array1=[[NSArray alloc] initWithObjects:@"鬼吹灯-龙岭迷窟",@"鬼吹灯-精绝古城",@"鬼吹灯-黄皮子坟",@"鬼吹灯-昆仑神宫",@"鬼吹灯-南海归墟",@"鬼吹灯-巫峡棺山",@"鬼吹灯-湘西尸王",@"鬼吹灯-云南虫谷",nil];
            
            NSArray *array2=[[NSArray alloc] initWithObjects:@"荒漠、扎格拉玛神山、精绝古城、黑塔、鬼洞，或者精绝女王那代表虚无的面孔……当一个接一个的谜题被揭开后，又会再出现新的谜题，总是会有一些东西藏在历史或其他东西的后面，穷尽一生也无法找出，且即使找出真相，又能代表什么？",@"在被人们称之为死亡之海的塔克拉玛干沙漠腹地有大片古老王国的遗址，据史书记载，在西汉时期这里一共大大小小林立着36个王国，其中在尼雅地区就有一个非常著名的国家。",@"1980年夏大兴安岭出现野兽咬死驯鹿的事件，事情越闹越凶，竟然有二十多个人被咬死。几个月后一支来自北京的探险队来到大兴安岭，三天后与外界失联，至今下落不明。",@"古格王朝，它的前身可以上溯到象雄国，王朝大概从9世纪开始，在统一西藏高原的吐蕃王朝瓦解后建立，到17世纪结束，前后世袭了16个国王",@"从美国治病回来的陈教授借举行家宴之机，请求胡八一去寻国宝秦王照骨镜，这面镜子的失落之地正是南海的珊瑚螺旋。众人商议过后，决定去南海寻觅失落的宝物，顺便做些“采蛋”的生意——采捞南海明珠。",@"考古学家孙教授深夜潜入博物馆，被胡八一发现。无可奈何之下，孙教授逐渐表露心迹：他多年研究发现，四川的确有明代观山太保修筑的地仙墓",@"留学日本的阿琴得知父亲除霸清恶而遇害的消息后，急与男友阿勇返回故乡寻找杀害父亲的仇人。而此时，父亲的遗体正由法师运往家乡",@"蛊为远古之时所传神秘巫术，并只在湘西苗族女子之中所有流传，世循传女不传男，其他民族不曾有，纵有类似，但也不远能与此物相比",nil];

            NSArray *arr3 = [[NSArray alloc]initWithObjects:@"llmk", @"jjgc",@"hpzf",@"klsg",@"nhgx",@"wxgs",@"xxsw",@"yncg",nil];
            
            for (int i=0; i<8 ;i++) {
                //添加时效性内容
                AlbumModel *album = [[AlbumModel alloc]init];
                album.title = array1[i];
                //album.albumId = @"5372320";
                album.intro = array2[i];
                album.coverLarge = arr3[i];
                [bSelf.albumMuArray insertObject:album atIndex:i];
                //添加时效性内容 end
            }
        }
        
        
        [self.albumTbview reloadData];
        [self.albumTbview.header endRefreshing];
        [self.albumTbview.footer endRefreshing];
    }];

}

-(UIImageView *)addAdView{
    
    UIImageView *adView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mainscreenwidth, 100* VIEWWITH)];
    adView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [adView addGestureRecognizer:singleTap];
    
    [adView setImage:[UIImage imageNamed:@"gcd"]];
    
    return adView;
}

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    //WebVC *adVC = [[WebVC alloc]init];
    //[self.navigationController pushViewController:adVC animated:YES];
    LSYReadPageViewController *pageView = [[LSYReadPageViewController alloc] init];
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"鬼吹灯-精绝古城"withExtension:@"txt"];
    pageView.resourceURL = fileURL;    //文件位置
    pageView.model = [LSYReadModel getLocalModelWithURL:fileURL];
    [self presentViewController:pageView animated:YES completion:nil];
}

-(void)pushView:(NSString *)name
{
    LSYReadPageViewController *pageView = [[LSYReadPageViewController alloc] init];
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:name withExtension:@"txt"];
    pageView.resourceURL = fileURL;    //文件位置
    pageView.model = [LSYReadModel getLocalModelWithURL:fileURL];
    [self presentViewController:pageView animated:YES completion:nil];
}


-(void)getAlbumListData:(NSInteger)pageId andPageSize:(NSInteger)pageSize andTagName:(NSString *)tagName
{
    if (pageId == 1) {
        [self.albumMuArray removeAllObjects];
    }
    __weak typeof(self) bSelf = self;
//    NSDictionary *params = @{@"calcDimension":@"hot",@"categoryId":kAlbumID,@"device":@"ios",@"pageId":@(pageId),@"pageSize":@(pageSize),@"status":@(0),@"tagName":tagName};
    
    //&pageId=1&pageSize=30
    
    NSDictionary *params = @{@"pageId":@(pageId),@"pageSize":@(pageSize)};//庶女
    
    [AFService postMethod:kAlbumList andDict:params completion:^(NSDictionary *results,NSError *error){
        NSArray *arr = [NSArray array];
        for (int i=0; i<arr.count; i++) {
            NSDictionary *dic = [arr objectAtIndex:i];
            AlbumModel *album = [[AlbumModel alloc]initWithDict:dic];
            [bSelf.albumMuArray addObject:album];
        }
        [self.albumTbview reloadData];
        [self.albumTbview.header endRefreshing];
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
    if ([album.title hasPrefix:@"鬼吹灯"]) {
        [self pushView:album.title];
    }else{
        MainController *mainVC = [[MainController alloc]init];
        mainVC.albumID = album.albumId;
        mainVC.albumTitle = album.title;
        mainVC.albumImage = album.coverLarge;
        [self.navigationController pushViewController:mainVC animated:YES];
    }
}

#pragma mark - 评分取消按钮监听
//取消按钮监听
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - admob广告

-(void)admobAD
{
    adBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    adBannerView.frame = CGRectMake(0, mainscreenhight - 50, mainscreenwidth, 50);
    adBannerView.adUnitID = KadMobKey;
    adBannerView.delegate = self;
    adBannerView.rootViewController = self;
    [self.view addSubview:adBannerView];
    
    GADRequest *request = [GADRequest request];
    [adBannerView loadRequest:request];
}

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    bannerView.hidden = NO;
}

- (void)adView:(GADBannerView *)adView didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"adView:didFailToReceiveAdWithError: %@", error.localizedDescription);
}



- (NSString *)publisherId {
    return PUBLISHERID; //@"your_own_app_id";
}

-(void) willDisplayAd:(BaiduMobAdView*) adview {
    NSLog(@"delegate: will display ad");
}

@end
