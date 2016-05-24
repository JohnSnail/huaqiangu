//
//  DTTimingViewController.m
//  duotin2.0
//
//  Created by Vienta on 14-10-17.
//  Copyright (c) 2014年 Duotin Network Technology Co.,LTD. All rights reserved.
//

#import "DTTimingViewController.h"
#import "DTTimingManager.h"
#import "PlayController.h"

@interface DTTimingViewController (){
    GADBannerView *adBannerView;
}
@end

@implementation DTTimingViewController
{
    NSMutableArray *_timingData;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        
    self.navigationItem.rightBarButtonItem = [LMButton setNavright:@"反馈" andcolor:[UIColor whiteColor] andSelector:@selector(pushAppStore) andTarget:self];

    [self layoutUI];
    _timingData = [NSMutableArray arrayWithCapacity:0];
    [_timingData addObject:@{@"content": @"不开启",
                             @"state":@(TimingStateNone)}];
    [_timingData addObject:@{@"content": @"10分钟后",
                             @"state":@(TimingStateTenMins)}];
    [_timingData addObject:@{@"content": @"20分钟后",
                             @"state":@(TimingStateTwentyMins)}];
    [_timingData addObject:@{@"content": @"30分钟后",
                             @"state":@(TimingStateThirtyMins)}];
    [_timingData addObject:@{@"content": @"60分钟后",
                             @"state":@(TimingStateOneHour)}];
    [_timingData addObject:@{@"content": @"90分钟后",
                             @"state":@(TimingStateNinetyMins)}];
    [_timingData addObject:@{@"content": @"当前单曲播放完毕后",
                             @"state":@(TimingStateAfterCurrentFinish)}];
    
    [self.tbvTiming performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    
    self.tbvTiming.backgroundColor = RGB(230, 227, 219);

    self.navigationItem.leftBarButtonItem=[LMButton setNavleftComboButtonWithImg:@"back" andSelector:@selector(backMethod) andTarget:self];
    
    [self addAdmobView];
}

#pragma mark -
#pragma mark - 添加admob广告

-(void)addAdmobView{
    adBannerView = [[GADBannerView alloc]init];
    adBannerView.frame = CGRectMake(0, mainscreenhight - 50 * VIEWWITH, 320 * VIEWWITH, 50 * VIEWWITH);
    adBannerView.adUnitID = KadMobKey;
    adBannerView.rootViewController = self;
    [self.view addSubview:adBannerView];
    
    [adBannerView loadRequest:[GADRequest request]];    
}

-(void)backMethod
{
    LM_POP;
}


- (void)layoutUI
{
    self.tbvTiming.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = [CommUtils navTittle:@"定时关闭"];
}

#pragma mark -
#pragma UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_timingData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"timingCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    UIImageView * lineImg = [CommUtils cuttingLineWithOriginx:10 andOriginY:43.5];
    [cell.contentView addSubview:lineImg];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    NSInteger idx = indexPath.row;
    NSDictionary *dict = [_timingData objectAtIndex:idx];
    cell.textLabel.text = [dict objectForKey:@"content"];
    if ([[dict objectForKey:@"state"] integerValue] == [DTTimingManager sharedDTTimingManager].timingState){
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selectCell"]];
    } else {
        cell.accessoryView = nil;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger selectIdx = indexPath.row;
    NSDictionary *selectDict = [_timingData objectAtIndex:selectIdx];
    NSNumber *timingState = [selectDict objectForKey:@"state"];
    if ([timingState integerValue] == TimingStateAfterCurrentFinish) {
        if([PlayController sharedPlayController].playTrack.title) {
            [[DTTimingManager sharedDTTimingManager] startTiming:TimingStateAfterCurrentFinish];
        } else {
            [UIAlertView showWithTitle:@"温馨提示" message:@"当前没有播放节目" cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:nil];
        }
        
    } else {
        [[DTTimingManager sharedDTTimingManager] startTiming:[timingState integerValue]];
    }


    [self.tbvTiming performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
