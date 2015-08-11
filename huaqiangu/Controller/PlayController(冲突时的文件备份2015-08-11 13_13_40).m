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

@interface PlayController ()<DMAdViewDelegate>
{
    NSString *hisProgress;
    NSTimer *timer;
    AutoRunLabel *trackLabel;
    DMAdView *_dmAdView;
}
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
    
    _dmAdView.frame = CGRectMake(0, (IS_IPHONE_5?420:320) * VIEWWITH - 50 * VIEWWITH, 320 * VIEWWITH, 50 * VIEWWITH);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _dmAdView.delegate = nil;
    _dmAdView.rootViewController = nil;
    self.navigationController.navigationBarHidden = YES;
}

-(void)initDomobView
{
    _dmAdView.delegate = self; // 设置 Delegate
    _dmAdView.rootViewController = self; // 设置 RootViewController
    [self.PlayHeadView addSubview:_dmAdView]; // 将⼲⼴广告视图添加到⽗父视图中
    [_dmAdView loadAd]; // 开始加载⼲⼴广告}
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [_dmAdView removeFromSuperview]; // 将⼲⼴广告试图从⽗父视图中移除
}

#pragma mark - 
#pragma mark - dmadDelegate

// 成功加载⼲⼴广告后,回调该⽅方法
- (void)dmAdViewSuccessToLoadAd:(DMAdView *)adView{
    NSLog(@"111111111");
    
}

// 加载⼲⼴广告失败后,回调该⽅方法
- (void)dmAdViewFailToLoadAd:(DMAdView *)adView withError:(NSError *)error{
    NSLog(@"222222222");
}
// 当将要呈现出 Modal View 时,回调该⽅方法。如打开内置浏览器。
- (void)dmWillPresentModalViewFromAd:(DMAdView *)adView{
    NSLog(@"333333333");
}
// 当呈现的 Modal View 被关闭后,回调该⽅方法。如内置浏览器被关闭。
- (void)dmDidDismissModalViewFromAd:(DMAdView *)adView{
    NSLog(@"444444444");
}
// 当因⽤用户的操作(如点击下载类⼲⼴广告,需要跳转到Store),需要离开当前应⽤用时,回调该⽅方法 - (void)dmApplicationWillEnterBackgroundFromAd:(DMAdView *)adView;

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _dmAdView = [[DMAdView alloc] initWithPublisherId:kPublisherId placementId:kPlacementId];

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
    if ([STKAudioPlayer sharedManager].state == STKAudioPlayerStatePlaying) {
        [[STKAudioPlayer sharedManager] pause];
    }else{
        [[STKAudioPlayer sharedManager] resume];
    }
    
    [self updateControls];
}

#pragma mark - 下一首
-(void)nextAction
{
    if (self.playIndex < self.playArr.count -1) {
        self.playIndex ++;
    }
    
    [self playMusic];
}

#pragma mark - 上一首
-(void)laseAction
{
    if (self.playIndex > 0) {
        self.playIndex --;
    }
    [self playMusic];
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
//    [self initDomobView];

    self.playArr = arr;
    self.playIndex = index;
    
    [self playMusic];
}

//播放暂停状态
-(void) updateControls
{
    if ([STKAudioPlayer sharedManager].state == STKAudioPlayerStatePlaying){
        self.playBtn.selected = YES;
    }else{
        self.playBtn.selected = NO;
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
//        self.albumImageView.image = [UIImage imageNamed:@"gu"];
    }
    
    NSString *strTrackId = (NSString *)[[STKAudioPlayer sharedManager] currentlyPlayingQueueItemId];
    if ([strTrackId isEqualToString:self.playTrack.playUrl64]){
        return;
    }
    [STKAudioPlayer sharedManager].delegate = self;
    
    TrackModel *track = [[HistoryList sharedManager] updateModel:self.playTrack];
    
    if (track.hisProgress.doubleValue > 0) {
        hisProgress = track.hisProgress;
        self.playTrack.hisProgress = track.hisProgress;
    }
    
    [[STKAudioPlayer sharedManager] play:self.playTrack.playUrl64];

    [self setupTimer];
    
    //保存正在播放的节目
    [CommUtils saveIndex:self.playIndex];
    
    [self performSelector:@selector(setLockScreenInfo) withObject:nil afterDelay:2.0];
}

-(void) setupTimer
{
    if ([timer isValid]) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(tick) userInfo:nil repeats:YES];
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
    [[HistoryList sharedManager] saveContent:self.playTrack];
    
    
    //锁屏播放
    AppDelegate *appDe = appDelegate;
    [appDe.PlayingInfoCenter setObject:[NSNumber numberWithDouble:[STKAudioPlayer sharedManager].progress] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    [appDe.PlayingInfoCenter setObject:[NSNumber numberWithDouble:[STKAudioPlayer sharedManager].duration] forKey:MPMediaItemPropertyPlaybackDuration];
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = appDe.PlayingInfoCenter;
    
    [self updateControls];
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
    [appDe.PlayingInfoCenter setObject:lockContent forKey:MPMediaItemPropertyTitle];
    
    //锁屏专辑名称
    lockContent = ALBUMTITLE;
    [appDe.PlayingInfoCenter setObject:lockContent forKey:MPMediaItemPropertyAlbumTitle];
    
    //锁屏图片
    //锁屏显示的其他内容
    MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage:self.albumImageView.image];
    
    [appDe.PlayingInfoCenter setObject:albumArt forKey:MPMediaItemPropertyArtwork];
    
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:appDe.PlayingInfoCenter];
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = appDe.PlayingInfoCenter;
}

#pragma mark - 播放的代理方法

/// Raised when an item has started playing
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didStartPlayingQueueItemId:(NSObject*)queueItemId{
    
}
/// Raised when an item has finished buffering (may or may not be the currently playing item)
/// This event may be raised multiple times for the same item if seek is invoked on the player
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject*)queueItemId{
    self.playTrack.hisProgress = @"0";
    [[HistoryList sharedManager] saveContent:self.playTrack];
    [self nextAction];
}
/// Raised when the state of the player has changed
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState{
    
}
/// Raised when an item has finished playing
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishPlayingQueueItemId:(NSObject*)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration{
    
}
/// Raised when an unexpected and possibly unrecoverable error has occured (usually best to recreate the STKAudioPlauyer)
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode{
    ;
}

@end
