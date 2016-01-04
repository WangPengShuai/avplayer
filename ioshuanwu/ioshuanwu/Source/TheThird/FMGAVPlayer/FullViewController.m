//
//  FullViewController.m
//  02-远程视频播放(AVPlayer)
//
//  Created by apple on 15/8/16.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "FullViewController.h"
#import "FullView.h"

@interface FullViewController ()

@end

@implementation FullViewController

- (void)loadView
{
    FullView *fullView = [[FullView alloc] init];
    self.view = fullView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

@end
