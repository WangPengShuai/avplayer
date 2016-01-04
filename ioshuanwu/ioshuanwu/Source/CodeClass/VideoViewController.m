//
//  VideoViewController.m
//  ioshuanwu
//
//  Created by 幻音 on 15/12/28.
//  Copyright © 2015年 幻音. All rights reserved.
//

#import "VideoViewController.h"
#import "FullViewController.h"

#define kRandomColor [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1]
@interface VideoViewController ()<CFDanmakuDelegate,FMGVideoPlayViewDelegate>

/* 全屏控制器 */
@property (nonatomic, strong) FullViewController *fullVc;

@property (nonatomic, assign) BOOL isShowDanmak;

@end

@implementation VideoViewController


+ (instancetype)shareVideoController
{
    static VideoViewController * video = nil;
    static dispatch_once_t token;
    if (video == nil) {
        dispatch_once(&token, ^{
            video = [[VideoViewController alloc] init];
        });
    }
    return video;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.playView.urlString != _video.mp4_url) {
        [_playView setUrlString:_video.mp4_url];
        [_playView.player play];
        _playView.playOrPauseBtn.selected = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_play];
    [self setupView];
    self.navigationItem.title = _video.title;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonAction:)];
}


// 测试发送弹幕
- (void)setupView{
    self.testDanma = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.playView.frame)+10, CGRectGetWidth(self.playView.frame), 40)];
    self.testDanma.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_testDanma];
    self.sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.sendButton.frame = CGRectMake(40, CGRectGetMaxY(self.testDanma.frame), 40, 40);
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    self.sendButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.sendButton addTarget:self action:@selector(sendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sendButton];
    self.hiddenButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.hiddenButton.frame = CGRectMake(CGRectGetMaxX(self.sendButton.frame)+130, CGRectGetMinY(self.sendButton.frame), 100, CGRectGetHeight(self.sendButton.frame));
    [self.hiddenButton setTitle:@"隐藏弹幕" forState:UIControlStateNormal];
    self.hiddenButton.titleLabel.font = [UIFont systemFontOfSize:20];
    self.isShowDanmak = YES;
    [self.view addSubview:_hiddenButton];
    [self.hiddenButton addTarget:self action:@selector(hiddenButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)hiddenButtonAction:(UIButton *)sender{
    if (_isShowDanmak) {
        self.playView.danmakuView.hidden =YES;
        self.isShowDanmak = NO;
        [self.hiddenButton setTitle:@"显示弹幕" forState:UIControlStateNormal];
        
    }else{
        self.playView.danmakuView.hidden = NO;
        self.isShowDanmak = YES;
        [self.hiddenButton setTitle:@"隐藏弹幕" forState:UIControlStateNormal];
    }
}

- (void)sendButtonAction:(UIButton *)sender{
    int time = ([self danmakuViewGetPlayTime:nil]+1);
    NSString *mString = _testDanma.text;
    CFDanmaku* danmaku = [[CFDanmaku alloc] init];
    danmaku.contentStr = [[NSMutableAttributedString alloc] initWithString:mString attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15], NSForegroundColorAttributeName : kRandomColor}];
    danmaku.timePoint = time;
    [_playView.danmakuView sendDanmakuSource:danmaku];
    self.testDanma.text = nil;

}

/**
 *  播放器
 */
- (void)p_play{
    self.playView = [FMGVideoPlayView videoPlayView];
    self.playView.delegate = self;
    _playView.index = 0;
    // 视频资源路径
    [_playView setUrlString:_video.mp4_url];
    // 播放器显示位置（竖屏时）
    _playView.frame = CGRectMake(0, 70, kScreenWidth, kScreenWidth/2);
    // 添加到当前控制器的view上
    [self.view addSubview:_playView];
    [_playView.player play];
    _playView.playOrPauseBtn.selected = YES;
    // 指定一个作为播放的控制器
    _playView.contrainerViewController = self;
    _playView.danmakuView.delegate = self;
    
}

#pragma mark - 懒加载代码
- (FullViewController *)fullVc
{
    if (_fullVc == nil) {
        _fullVc = [[FullViewController alloc] init];
    }
    return _fullVc;
}

- (void)leftBarButtonAction:(UIBarButtonItem *)sender{
    [_playView.player pause];
    [_playView.player setRate:0];
    _playView.playOrPauseBtn.selected = NO;
    _playView.danmakuView.hidden = YES;
//    [_playView.currentItem removeObserver:_playView forKeyPath:@"status"];
//    [_playView.player replaceCurrentItemWithPlayerItem:nil];
//    _playView.currentItem = nil;
//    _playView.player = nil;
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 视频代理方法

- (void)videoplayViewSwitchOrientation:(BOOL)isFull
{
    if (isFull) {
        [self.navigationController presentViewController:self.fullVc animated:NO completion:^{
            [self.fullVc.view addSubview:self.playView];
            _playView.center = self.fullVc.view.center;
            
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                _playView.frame = self.fullVc.view.bounds;
                self.playView.danmakuView.frame = self.playView.frame;
                
            } completion:nil];
        }];
    } else {
        [self.fullVc dismissViewControllerAnimated:NO completion:^{
            [self.view addSubview:_playView];
            _playView.frame = CGRectMake(0,  70 , kScreenWidth, (kScreenWidth-20)/2);
        }];
    }

}


#pragma mark - 弹幕代理方法
- (NSTimeInterval)danmakuViewGetPlayTime:(CFDanmakuView *)danmakuView
{
    if(_playView.progressSlider.value == 1.0) [_playView.danmakuView stop]
        ;
    return _playView.progressSlider.value*120.0;
}

- (BOOL)danmakuViewIsBuffering:(CFDanmakuView *)danmakuView
{
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
