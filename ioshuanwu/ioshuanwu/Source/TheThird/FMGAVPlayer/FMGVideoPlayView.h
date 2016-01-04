//
//  FMGVideoPlayView.h
//  02-远程视频播放(AVPlayer)
//
//  Created by apple on 15/8/16.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class CFDanmakuView;
@class FullViewController;

@protocol  FMGVideoPlayViewDelegate <NSObject>

- (void)videoplayViewSwitchOrientation:(BOOL)isFull;

@end

@interface FMGVideoPlayView : UIView

+ (instancetype)videoPlayView;

@property (nonatomic, assign) NSInteger index;

/* playItem */
@property (nonatomic, weak) AVPlayerItem *currentItem;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;


/* 播放器 */
@property (nonatomic, strong) AVPlayer *player;

/* 弹幕 */

@property (nonatomic, strong) CFDanmakuView * danmakuView;

//@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, copy) NSString *urlString;
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;

/* 包含在哪一个控制器中 */
@property (nonatomic, weak) UIViewController *contrainerViewController;

/* 全屏控制器 */
@property (nonatomic, strong) FullViewController *fullVc;

/* 代理 */
@property (nonatomic, assign) id<FMGVideoPlayViewDelegate>delegate;

- (void)showToolView:(BOOL)isShow;

@end
