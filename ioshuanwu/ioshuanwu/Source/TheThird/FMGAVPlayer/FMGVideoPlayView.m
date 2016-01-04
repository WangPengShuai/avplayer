//
//  FMGVideoPlayView.m
//  02-远程视频播放(AVPlayer)
//
//  Created by apple on 15/8/16.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "FMGVideoPlayView.h"
#import "FullViewController.h"

#define kRandomColor [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1]
#define font [UIFont systemFontOfSize:15]

@interface FMGVideoPlayView()<CFDanmakuDelegate>



// 播放器的Layer
@property (weak, nonatomic) AVPlayerLayer *playerLayer;


@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

// 记录当前是否显示了工具栏
@property (assign, nonatomic) BOOL isShowToolView;

/* 定时器 */
@property (nonatomic, strong) NSTimer *progressTimer;

/* 工具栏的显示和隐藏 */
@property (nonatomic, strong) NSTimer *showTimer;

/* 工具栏展示的时间 */
@property (assign, nonatomic) NSTimeInterval showTime;



@property (nonatomic, strong) NSTimer * timer;

#pragma mark - 监听事件的处理
- (IBAction)playOrPause:(UIButton *)sender;
- (IBAction)switchOrientation:(UIButton *)sender;
- (IBAction)slider;
- (IBAction)startSlider;
- (IBAction)sliderValueChange;

- (IBAction)tapAction:(UITapGestureRecognizer *)sender;
- (IBAction)swipeAction:(UISwipeGestureRecognizer *)sender;
- (IBAction)swipeRight:(UISwipeGestureRecognizer *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *forwardImageView;

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@end

@implementation FMGVideoPlayView


// 快速创建View的方法
+ (instancetype)videoPlayView
{
//    static FMGVideoPlayView *fm = nil;
//    static dispatch_once_t once_token;
//    if (fm == nil) {
//        dispatch_once(&once_token, ^{
//            fm = [[[NSBundle mainBundle] loadNibNamed:@"FMGVideoPlayView" owner:nil options:nil] firstObject];
//        });
//    }
//    return fm;
    return [[[NSBundle mainBundle] loadNibNamed:@"FMGVideoPlayView" owner:nil options:nil] firstObject];
    
 }
- (AVPlayer *)player
{
    if (!_player) {

        // 初始化Player和Layer
        _player = [[AVPlayer alloc] init];
    }
    return _player;
}

- (void)awakeFromNib
{
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [self.imageView.layer addSublayer:self.playerLayer];
    
    // 设置工具栏的状态
    self.toolView.alpha = 0;
    self.isShowToolView = NO;
    
    self.forwardImageView.alpha = 0;
    self.backImageView.alpha = 0;
    
    // 设置进度条的内容
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"thumbImage"] forState:UIControlStateNormal];
    [self.progressSlider setMaximumTrackImage:[UIImage imageNamed:@"MaximumTrackImage"] forState:UIControlStateNormal];
    [self.progressSlider setMinimumTrackImage:[UIImage imageNamed:@"MinimumTrackImage"] forState:UIControlStateNormal];
    
    // 设置按钮的状态
    self.playOrPauseBtn.selected = NO;
    
    [self showToolView:YES];
    [self setupDanmakuView];
    [self setupDanmakuData];
    
}

#pragma mark - 观察者对应的方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        if (AVPlayerItemStatusReadyToPlay == status) {
            [self removeProgressTimer];
            [self addProgressTimer];
            [_danmakuView start];
        } else {
            [self removeProgressTimer];
        }
    }
}

- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[self.player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

#pragma mark - 重新布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.playerLayer.frame = self.bounds;
}

#pragma mark - 设置播放的视频
- (void)setUrlString:(NSString *)urlString
{
    _urlString = urlString;
   
    NSURL *url = [NSURL URLWithString:urlString];
    if (self.player.currentItem) {
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    }
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
    self.currentItem = item;
    
    [self.player replaceCurrentItemWithPlayerItem:self.currentItem];
    
    [self.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    // 添加视频播放结束通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_currentItem];
    
}
- (void)moviePlayDidEnd:(NSNotification *)notification {
    __weak typeof(self) weakSelf = self;
    [self.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        [weakSelf.progressSlider setValue:0.0 animated:YES];
        weakSelf.playOrPauseBtn.selected = NO;
    }];
}
// 是否显示工具的View
- (IBAction)tapAction:(UITapGestureRecognizer *)sender {
    [self showToolView:!self.isShowToolView];
//    [self removeShowTimer];
//    if (self.isShowToolView) {
//        [self showToolView:YES];
//    }
}

- (IBAction)swipeAction:(UISwipeGestureRecognizer *)sender {
    [self swipeToRight:YES];
}

- (IBAction)swipeRight:(UISwipeGestureRecognizer *)sender {
    [self swipeToRight:NO];
}

- (void)swipeToRight:(BOOL)isRight
{
    // 1.获取当前播放的时间
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.currentTime);
    
    if (isRight) {
        [UIView animateWithDuration:1 animations:^{
            self.forwardImageView.alpha = 1;
        } completion:^(BOOL finished) {
            self.forwardImageView.alpha = 0;
        }];
        currentTime += 10;
        
    } else {
        [UIView animateWithDuration:1 animations:^{
            self.backImageView.alpha = 1;
        } completion:^(BOOL finished) {
            self.backImageView.alpha = 0;
        }];
        currentTime -= 10;
        
    }
    
    if (currentTime >= CMTimeGetSeconds(self.player.currentItem.duration)) {
        
        currentTime = CMTimeGetSeconds(self.player.currentItem.duration) - 1;
    } else if (currentTime <= 0) {
        currentTime = 0;
    }
    
    [self.player seekToTime:CMTimeMakeWithSeconds(currentTime, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    
    [self updateProgressInfo];
}




- (void)showToolView:(BOOL)isShow
{
    if (self.progressSlider.tag == 100) {
        
//            [self showToolView:YES];
        [self removeShowTimer];
        self.progressSlider.tag = 20;
        return;
    
    }
    [UIView animateWithDuration:1.0 animations:^{
        self.toolView.alpha = !self.isShowToolView;
        self.isShowToolView = !self.isShowToolView;
    }];
}

// 暂停按钮的监听
- (IBAction)playOrPause:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender == nil) {
        self.playOrPauseBtn.selected = NO;
    }
    if (sender.selected) {
        [self.player play];
        [self addShowTimer];
        [self addProgressTimer];
        if (_danmakuView.isPrepared) {
            if (!_timer) {
                _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(onTimeCount) userInfo:nil repeats:YES];
            }
            [_danmakuView start];
        }
    } else {
        [self.player pause];
        [self removeShowTimer];
        [self removeProgressTimer];
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
        [_danmakuView pause];
    }
}

#pragma mark - 定时器操作
- (void)addProgressTimer
{
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}

- (void)removeProgressTimer
{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

- (void)updateProgressInfo
{
    // 1.更新时间
    self.timeLabel.text = [self timeString];
    
    self.progressSlider.value = CMTimeGetSeconds(self.player.currentTime) / CMTimeGetSeconds(self.player.currentItem.duration);
    
    if(self.progressSlider.value == 1)
    {
        self.progressSlider.value = 0;
        self.progressSlider.tag = 100;
//        [self playOrPause:nil];
//        [self sliderValueChange];
        self.player = nil;
        self.playOrPauseBtn.selected = NO;
        self.toolView.alpha = 1;
        
        [self removeProgressTimer];
        [self removeShowTimer];
        self.timeLabel.text = @"00:00/00:00";
        return;

    }

}

- (NSString *)timeString
{
    NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentTime);
//    if (self.player == nil) {
//        return @"00:00/00:00";
//    }
    return [self stringWithCurrentTime:currentTime duration:duration];
}

- (void)addShowTimer
{
    self.showTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateShowTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.showTimer forMode:NSRunLoopCommonModes];
}

- (void)removeShowTimer
{
    [self.showTimer invalidate];
    self.showTimer = nil;
}

- (void)updateShowTime
{
    self.showTime += 1;
    
    if (self.showTime > 2.0) {
        [self tapAction:nil];
        [self removeShowTimer];
        
        self.showTime = 0;
    }
}

#pragma mark - 通过代理方法实现切换屏幕的方向
- (IBAction)switchOrientation:(UIButton *)sender {
    sender.selected = !sender.selected;
    [_delegate videoplayViewSwitchOrientation:sender.selected];
//    [self videoplayViewSwitchOrientation:sender.selected];
}

- (IBAction)slider {
    [self addProgressTimer];
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration) * self.progressSlider.value;
    [self.player seekToTime:CMTimeMakeWithSeconds(currentTime, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (IBAction)startSlider {
    [self removeProgressTimer];

}

- (IBAction)sliderValueChange {
    [self removeProgressTimer];
    [self removeShowTimer];
    if (self.progressSlider.value == 1) {
        self.progressSlider.value = 0;
    }
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration) * self.progressSlider.value;
    NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
    self.timeLabel.text = [self stringWithCurrentTime:currentTime duration:duration];
    [self addShowTimer];
    [self addProgressTimer];
}

- (NSString *)stringWithCurrentTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration
{
//    if (currentTime == duration) {
//        currentTime = 0;
//
////        self.player.currentTime = currentTime;
////        [self updateProgressInfo];
////        [self sliderValueChange];
////        self.progressSlider.value = 0;
//        self.playOrPauseBtn.selected = NO;
//        self.toolView.alpha = 1;
//        
//        [self removeProgressTimer];
//        [self removeShowTimer];
//        self.player = nil;
//        
//    }
    NSInteger dMin = duration / 60;
    NSInteger dSec = (NSInteger)duration % 60;
    
    NSInteger cMin = currentTime / 60;
    NSInteger cSec = (NSInteger)currentTime % 60;
    
    NSString *durationString = [NSString stringWithFormat:@"%02ld:%02ld", dMin, dSec];
    NSString *currentString = [NSString stringWithFormat:@"%02ld:%02ld", cMin, cSec];
    
    return [NSString stringWithFormat:@"%@/%@", currentString, durationString];
}

#pragma mark - 懒加载代码
- (FullViewController *)fullVc
{
    if (_fullVc == nil) {
        _fullVc = [[FullViewController alloc] init];
    }
    return _fullVc;
}

#pragma mark - 弹幕
- (void)setupDanmakuView
{
    CGRect rect =  self.frame;
    _danmakuView = [[CFDanmakuView alloc] initWithFrame:rect];
    _danmakuView.duration = 6.5;
    _danmakuView.centerDuration = 2.5;
    _danmakuView.lineHeight = 17;
    _danmakuView.maxShowLineCount = 8;
    _danmakuView.maxCenterLineCount = 1;
    _danmakuView.delegate = self;
    [self addSubview:_danmakuView];
}

- (void)setupDanmakuData
{
    NSString *danmakufile = [[NSBundle mainBundle] pathForResource:@"danmakufile" ofType:nil];
    NSArray *danmakusDicts = [NSArray arrayWithContentsOfFile:danmakufile];
    
    NSMutableArray* danmakus = [NSMutableArray array];
    for (NSDictionary* dict in danmakusDicts) {
        CFDanmaku* danmaku = [[CFDanmaku alloc] init];
        NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:dict[@"m"] attributes:@{NSFontAttributeName : font, NSForegroundColorAttributeName : kRandomColor}];
        
        NSString* emotionName = [NSString stringWithFormat:@"smile_%zd", arc4random_uniform(90)];
        UIImage* emotion = [UIImage imageNamed:emotionName];
        NSTextAttachment* attachment = [[NSTextAttachment alloc] init];
        attachment.image = emotion;
        attachment.bounds = CGRectMake(0, -font.lineHeight*0.3, font.lineHeight*1.5, font.lineHeight*1.5);
        NSAttributedString* emotionAttr = [NSAttributedString attributedStringWithAttachment:attachment];
        
        [contentStr appendAttributedString:emotionAttr];
        danmaku.contentStr = contentStr;
        
        NSString* attributesStr = dict[@"p"];
        NSArray* attarsArray = [attributesStr componentsSeparatedByString:@","];
        danmaku.timePoint = [[attarsArray firstObject] doubleValue] / 1000;
        danmaku.position = [attarsArray[1] integerValue];
        //        if (danmaku.position != 0) {
        
        [danmakus addObject:danmaku];
        //        }
    }
    
    [_danmakuView prepareDanmakus:danmakus];
}

- (void)onTimeCount
{
    _progressSlider.value+=0.1/120;
    if (_progressSlider.value>120.0) {
        _progressSlider.value=0;
    }
}

- (NSTimeInterval)danmakuViewGetPlayTime:(CFDanmakuView *)danmakuView
{
    if(_progressSlider.value == 1.0) [_danmakuView stop]
        ;
    return _progressSlider.value*120.0;
}

- (BOOL)danmakuViewIsBuffering:(CFDanmakuView *)danmakuView
{
    return NO;
}

- (void)dealloc
{
    [self.currentItem removeObserver:self forKeyPath:@"status" context:nil];
}

@end
