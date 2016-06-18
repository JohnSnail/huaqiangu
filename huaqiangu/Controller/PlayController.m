//
//  PlayController.m
//  huaqiangu
//
//  Created by Jiangwei on 15/7/18.
//  Copyright (c) 2015年 Jiangwei. All rights reserved.
//

#import "PlayController.h"
#import "AppDelegate.h"
#import "DTTimingViewController.h"
#import "DTTimingManager.h"

@interface PlayController ()<GADInterstitialDelegate>
{
    NSString *hisProgress;
    AutoRunLabel *trackLabel;
    GADBannerView *adBannerView;
}

@property(nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation PlayController

SINGLETON_CLASS(PlayController);


#pragma mark - 
#pragma mark - 适配iPhone6

-(void)setFrameView
{
    NSLog(@"ios = %d", IS_IPHONE_5);
    self.bgImageView.frame = CGRectMake(0, 0, 320 * VIEWWITH, (IS_IPHONE_5?420:320) * VIEWWITH);
    self.PlayHeadView.frame = CGRectMake(0, 0, 320 * VIEWWITH, (IS_IPHONE_5?420:320) * VIEWWITH);

    self.albumImageView.frame = CGRectMake(20 * VIEWWITH, 90 * VIEWWITH, 150 * VIEWWITH, 150 * VIEWWITH);
    self.backBtn.frame = CGRectMake(20 * VIEWWITH, 20 * VIEWWITH, 44 * VIEWWITH, 44 * VIEWWITH);
    
    self.albTitle.frame = CGRectMake(22 * VIEWWITH, 248 * VIEWWITH, 148 * VIEWWITH, 29 * VIEWWITH);
    
    self.playBtn.frame = CGRectMake(135 * VIEWWITH, (IS_IPHONE_5?453:353) * VIEWWITH, 50 * VIEWWITH, 50 * VIEWWITH);
    self.nextBtn.frame = CGRectMake(221 * VIEWWITH, (IS_IPHONE_5?448:348) * VIEWWITH, 60 * VIEWWITH, 60 * VIEWWITH);
    self.lastBtn.frame = CGRectMake(39 * VIEWWITH, (IS_IPHONE_5?448:348) * VIEWWITH, 60 * VIEWWITH, 60 * VIEWWITH);
    self.playSlider.frame = CGRectMake(48 * VIEWWITH, (IS_IPHONE_5?514:414) * VIEWWITH, 224 * VIEWWITH, 31 * VIEWWITH);
    self.playLeftLabel.frame = CGRectMake(0, (IS_IPHONE_5?518:418) * VIEWWITH, 42 * VIEWWITH, 21 * VIEWWITH);
    self.playRightLabel.frame = CGRectMake(278 * VIEWWITH, (IS_IPHONE_5?518:418) * VIEWWITH, 42 * VIEWWITH, 21 * VIEWWITH);
    self.timeBtn.frame = CGRectMake(274 * VIEWWITH, 27 * VIEWWITH, 30 * VIEWWITH, 30 * VIEWWITH);
    self.countLabel.frame = CGRectMake(200 * VIEWWITH, 248 * VIEWWITH, 112 * VIEWWITH, 29 * VIEWWITH);
    self.bannerView.frame = CGRectMake(0, (IS_IPHONE_5?420:320) * VIEWWITH - 50 * VIEWWITH, 320 * VIEWWITH, 50 * VIEWWITH);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}


#pragma mark - 
#pragma mark - 添加admob广告

-(void)addAdmobView{
    [adBannerView removeFromSuperview];
    
    adBannerView = [[GADBannerView alloc]init];
    adBannerView.frame = CGRectMake(0, 0, self.bannerView.frame.size.width, self.bannerView.frame.size.height);
    adBannerView.adUnitID = KadMobKey;
    adBannerView.rootViewController = self;
    [self.bannerView addSubview:adBannerView];
    
    [adBannerView loadRequest:[GADRequest request]];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setFrameView];
    [self addHeadView];
    [self setTrackScrollerLabel];
    
    [self playMusic];
    
    [DTTimingManager sharedDTTimingManager].timingBlk = ^(NSNumber *timing) {
        if (timing.integerValue == 0) {
            
            self.countLabel.text = @" ";
            if ([DTTimingManager sharedDTTimingManager].timingState != TimingStateNone) {
                [[STKAudioPlayer sharedManager] pause];
            }
        }else{
            self.countLabel.text = [CommUtils formatIntoDateWithSecond:timing];
        }
    };
    
    [self addAdmobView];
    [self createAndLoadInterstitial];
    
    [STKAudioPlayer sharedManager].delegate = self;
    
    //播放结束代理方法
//    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(nextAction) name: @"nextAction" object: nil];
}


#pragma mark - 
#pragma mark - 节目title滚动

-(void)setTrackScrollerLabel
{
    trackLabel = [[AutoRunLabel alloc]init];
    trackLabel.frame = CGRectMake(22 * VIEWWITH, 285 * VIEWWITH, 148 * VIEWWITH, 21 * VIEWWITH);
    trackLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
    trackLabel.textColor = RGB(187, 186, 194);
    trackLabel.font = [UIFont systemFontOfSize:16];
    [self.PlayHeadView addSubview:trackLabel];
}

#pragma mark - 播放暂停
-(void)playAction
{
    NSLog(@"status = %d",[STKAudioPlayer sharedManager].state);
    if ([STKAudioPlayer sharedManager].state == STKAudioPlayerStatePlaying) {
        [[STKAudioPlayer sharedManager] pause];
        if (self.interstitial.isReady) {
            [self.interstitial presentFromRootViewController:self];
        }
    }else if([STKAudioPlayer sharedManager].state == STKAudioPlayerStatePaused){
        [[STKAudioPlayer sharedManager] resume];
    }else{
        [self playMusic];
    }
}

#pragma mark - 下一首
-(void)nextAction
{
    [self addAdmobView];
    
    if (self.playIndex < self.playArr.count -1) {
        self.playIndex ++;
    }
    
    [self playMusic];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadAction" object:nil];
}

#pragma mark - 上一首
-(void)laseAction
{
    [self addAdmobView];

    if (self.playIndex > 0) {
        self.playIndex --;
    }
    [self playMusic];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadAction" object:nil];
}

-(void)addHeadView
{
    //去除按钮按下效果
    self.lastBtn.adjustsImageWhenHighlighted = NO;
    self.nextBtn.adjustsImageWhenHighlighted = NO;
    
    self.bgImageView.backgroundColor = [UIColor blackColor];
    self.bgImageView.alpha = 0.3;
    self.PlayHeadView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"playHead.png"]];
    [self.view addSubview:self.PlayHeadView];
    
    //滑条
    [self.playSlider setThumbImage:[UIImage imageNamed:@"play_point"] forState:UIControlStateNormal];
    [self.playSlider setThumbImage:[UIImage imageNamed:@"play_point"] forState:UIControlStateHighlighted];
    [self.playSlider addTarget:self action:@selector(valueChange) forControlEvents:UIControlEventValueChanged];
    
    //返回和播放按钮
    [self.backBtn addTarget:self action:@selector(backMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.playBtn addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
    [self.nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [self.lastBtn addTarget:self action:@selector(laseAction) forControlEvents:UIControlEventTouchUpInside];
    [self.timeBtn addTarget:self action:@selector(timeAction) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 
#pragma mark - 定时按钮触发方法

-(void)timeAction
{
    DTTimingViewController *timeVC = [[DTTimingViewController alloc] initWithNibName:@"DTTimingViewController" bundle:nil];
    timeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:timeVC animated:YES];
}

//拖动滑动条
-(void)valueChange {
    if (![STKAudioPlayer sharedManager]) {
        return;
    }
    [[STKAudioPlayer sharedManager] seekToTime:self.playSlider.value];
}


-(void)backMethod
{
    LM_POP;
}

-(void)pushArr:(NSArray *)arr andIndex:(NSInteger)index
{
    self.playArr = arr;
    self.playIndex = index;
    
    [self playMusic];
}

//播放暂停状态
-(void) updateControls
{
    if ([STKAudioPlayer sharedManager].state == STKAudioPlayerStatePlaying){
        self.playBtn.selected = YES;
        [self setupTimer:YES];
    }else{
        self.playBtn.selected = NO;
        [self setupTimer:NO];
    }
}

-(void)playMusic
{
    if (self.playArr.count != 0) {
        self.playTrack = self.playArr[self.playIndex];
        
        self.albTitle.text = ALBUMTITLE;
        NSMutableString *muStr = nil;
        if (self.playTrack.title) {
            muStr = [NSMutableString stringWithString:self.playTrack.title];
        }
        if (muStr.length > 8) {
            trackLabel.moveSpeech = -50.0f;
        }else{
            trackLabel.moveSpeech = 0;
        }
        trackLabel.text = muStr;
        
        [self.albumImageView sd_setImageWithURL:[NSURL URLWithString:self.playTrack.coverLarge] placeholderImage:[UIImage imageNamed:@"main_otherplace"]];
    }
    
    NSString *strTrackId = (NSString *)[[STKAudioPlayer sharedManager] currentlyPlayingQueueItemId];
    if ([strTrackId isEqualToString:self.playTrack.playUrl64]&& [STKAudioPlayer sharedManager].state == STKAudioPlayerStatePlaying){
        return;
    }
    TrackModel *track = [[HistoryList sharedManager] updateModel:self.playTrack];
    
    if (track.hisProgress.doubleValue > 0) {
        hisProgress = track.hisProgress;
        self.playTrack.hisProgress = track.hisProgress;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:HSFileFullpath(self.playTrack.playUrl64)]) {
        NSURL* url = [NSURL fileURLWithPath:HSFileFullpath(self.playTrack.playUrl64)];
        [[STKAudioPlayer sharedManager] playURL:url withQueueItemID:self.playTrack.playUrl64];
    }else{
        [[STKAudioPlayer sharedManager] play:self.playTrack.playUrl64];
    }
    
    [self setupTimer:YES];
    
    [CommUtils saveIndex:self.playIndex];
    [[HistoryList sharedManager] saveContent:self.playTrack];
    
    [self performSelector:@selector(setLockScreenInfo) withObject:nil afterDelay:2.0];
}

-(void) setupTimer:(BOOL)isBackGround
{
    if(isBackGround == YES){
        if (![self.timer isValid]){
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
            [self.timer fire];
        }
    }else{
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(void) tick
{
    if (![STKAudioPlayer sharedManager] || [STKAudioPlayer sharedManager].duration == 0)
    {
        self.playSlider.value = 0;
        return;
    }
    
    self.playSlider.minimumValue = 0;
    self.playSlider.maximumValue = [STKAudioPlayer sharedManager].duration;
    self.playSlider.value = [STKAudioPlayer sharedManager].progress;
    
    if (hisProgress.doubleValue != 0) {
        [[STKAudioPlayer sharedManager] seekToTime:hisProgress.doubleValue];
        hisProgress = 0;
    }
    
    self.playLeftLabel.text = [CommUtils progressValue:[STKAudioPlayer sharedManager].progress];
    self.playRightLabel.text = [CommUtils progressValue:[STKAudioPlayer sharedManager].duration];
    self.playTrack.hisProgress = [NSString stringWithFormat:@"%@",@([STKAudioPlayer sharedManager].progress)];
    [[HistoryList sharedManager] mergeWithContent:self.playTrack];
    
    
    //锁屏播放
    AppDelegate *appDe = appDelegate;
    [appDe.PlayingInfoCenter setSafeObject:[NSNumber numberWithDouble:[STKAudioPlayer sharedManager].progress] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    [appDe.PlayingInfoCenter setSafeObject:[NSNumber numberWithDouble:[STKAudioPlayer sharedManager].duration] forKey:MPMediaItemPropertyPlaybackDuration];
    
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:appDe.PlayingInfoCenter];
}


#pragma mark - 
#pragma mark - 锁屏播放

- (void)setLockScreenInfo
{
    AppDelegate * appDe = appDelegate;
    //移除之前的
    [appDe.PlayingInfoCenter removeAllObjects];
    
    NSString *lockContent = self.playTrack.title;
   
    //锁屏显示的节目名称
    [appDe.PlayingInfoCenter setSafeObject:lockContent forKey:MPMediaItemPropertyTitle];
    
    //锁屏专辑名称
    lockContent = ALBUMTITLE;
    [appDe.PlayingInfoCenter setSafeObject:lockContent forKey:MPMediaItemPropertyAlbumTitle];
    
    //锁屏图片
    //锁屏显示的其他内容
    MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage:self.albumImageView.image];
    
    [appDe.PlayingInfoCenter setSafeObject:albumArt forKey:MPMediaItemPropertyArtwork];
    
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:appDe.PlayingInfoCenter];
}

#pragma mark - 播放的代理方法

/// Raised when an item has started playing
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didStartPlayingQueueItemId:(NSObject*)queueItemId{
    
}

/// Raised when an item has finished buffering (may or may not be the currently playing item)
/// This event may be raised multiple times for the same item if seek is invoked on the player
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject*)queueItemId{
    
}
/// Raised when the state of the player has changed
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState{
//    if (previousState == STKAudioPlayerStatePlaying && state  == STKAudioPlayerStateBuffering) {
//        [self playAction];
//    }
    NSLog(@"state == %u",state);

    NSLog(@"previousState == %u",previousState);
    
    [self updateControls];
}

/// Raised when an item has finished playing
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishPlayingQueueItemId:(NSObject*)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration{
    if ([queueItemId isEqual:self.playTrack.playUrl64] && stopReason == STKAudioPlayerStopReasonEof) {
        self.playTrack.hisProgress = @"0";
        [[HistoryList sharedManager] mergeWithContent:self.playTrack];
        [self nextAction];
    }
}
/// Raised when an unexpected and possibly unrecoverable error has occured (usually best to recreate the STKAudioPlauyer)
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode{
    NSLog(@"%u错误",errorCode);
}

#pragma mark - 
#pragma mark - admob 插屏

- (void)createAndLoadInterstitial {
    self.interstitial =
    [[GADInterstitial alloc] initWithAdUnitID:kGADInterKey];
    self.interstitial.delegate = self;
    [self.interstitial loadRequest:[GADRequest request]];
}

- (void)interstitial:(GADInterstitial *)interstitial
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, [error localizedDescription]);
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self createAndLoadInterstitial];
}

@end
