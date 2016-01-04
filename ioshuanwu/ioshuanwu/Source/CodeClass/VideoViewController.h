//
//  VideoViewController.h
//  ioshuanwu
//
//  Created by 幻音 on 15/12/28.
//  Copyright © 2015年 幻音. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FullViewController;

@interface VideoViewController : UIViewController

@property (nonatomic, strong) Video *video;
@property (nonatomic, strong) FMGVideoPlayView *playView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UITextField * testDanma;
@property (nonatomic, strong) UIButton * sendButton;
@property (nonatomic, strong) UIButton * hiddenButton;



+ (instancetype) shareVideoController;

@end
