//
//  RootTableViewController.m
//  ioshuanwu
//
//  Created by 幻音 on 15/12/27.
//  Copyright © 2015年 幻音. All rights reserved.
//

#import "RootTableViewController.h"
#import "MJRefresh.h"
#import "FullViewController.h"

@interface RootTableViewController ()<FMGVideoPlayViewDelegate>

@property (nonatomic, strong) NSArray * videoSidArray; // videoSid数组
@property (nonatomic, strong) NSMutableArray * videoArray; // video数组
@property (nonatomic, strong) FMGVideoPlayView * fmVideoPlayer; // 播放器
/* 全屏控制器 */
@property (nonatomic, strong) FullViewController *fullVc;

@end

@implementation RootTableViewController
static NSString *ID = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"视频";
    [self setHeardView];
    [self.tableView registerClass:[RootTableViewCell class] forCellReuseIdentifier:ID];
   self.fmVideoPlayer = [FMGVideoPlayView videoPlayView];// 创建播放器
    self.fmVideoPlayer.delegate = self;
    [self refresh];
}

#pragma mark - 懒加载代码
- (FullViewController *)fullVc
{
    if (_fullVc == nil) {
        _fullVc = [[FullViewController alloc] init];
    }
    return _fullVc;
}

- (void)videoplayViewSwitchOrientation:(BOOL)isFull{
    if (isFull) {
        [self.navigationController presentViewController:self.fullVc animated:NO completion:^{
            [self.fullVc.view addSubview:self.fmVideoPlayer];
            _fmVideoPlayer.center = self.fullVc.view.center;
            
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                _fmVideoPlayer.frame = self.fullVc.view.bounds;
                self.fmVideoPlayer.danmakuView.frame = self.fmVideoPlayer.frame;
                
            } completion:nil];
        }];
    } else {
        [self.fullVc dismissViewControllerAnimated:NO completion:^{
            [self.view addSubview:_fmVideoPlayer];
            _fmVideoPlayer.frame = CGRectMake(0,  275 * _fmVideoPlayer.index + kScreenWidth/5 + 50 , kScreenWidth, (kScreenWidth-20)/2);
        }];
    }

}
/**
 *  获取页面顶HeardView
 */
- (void)setHeardView{
    HeadView *heardView = [[HeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/5)];
    self.tableView.tableHeaderView = heardView;
    self.videoSidArray = [[NSArray alloc] init];
    self.videoArray = [[NSMutableArray alloc] init];
    [[GetVideoDataTools shareDataTools] getHeardDataWithURL:homeURL HeardValue:^(NSArray *heardArray, NSArray *videoArray) {
        _videoSidArray = heardArray;
        [self.videoArray addObjectsFromArray:videoArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            VideoSid * videoOne = [[VideoSid alloc]init];
            videoOne = _videoSidArray[0];
            [heardView.leftOneButton.titleImage sd_setImageWithURL:[NSURL URLWithString:videoOne.imgsrc] placeholderImage:[UIImage imageNamed:@"logo"]];
            heardView.leftOneButton.nameLabel.text = videoOne.title;
            [heardView.leftOneButton addTarget:self action:@selector(leftOneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            VideoSid * videoTow = [[VideoSid alloc]init];
            videoTow = _videoSidArray[1];
            [heardView.leftTwoButton.titleImage sd_setImageWithURL:[NSURL URLWithString:videoTow.imgsrc] placeholderImage:[UIImage imageNamed:@"logo"]];
            heardView.leftTwoButton.nameLabel.text = videoTow.title;
            [heardView.leftTwoButton addTarget:self action:@selector(leftTwoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            VideoSid * videoThree = [[VideoSid alloc]init];
            videoThree = _videoSidArray[2];
            [heardView.rightOneButton.titleImage sd_setImageWithURL:[NSURL URLWithString:videoThree.imgsrc] placeholderImage:[UIImage imageNamed:@"logo"]];
            heardView.rightOneButton.nameLabel.text = videoThree.title;
            [heardView.rightOneButton addTarget:self action:@selector(rightOneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            VideoSid * videoFour = [[VideoSid alloc]init];
            videoFour = _videoSidArray[3];
            [heardView.rigthTwoButton.titleImage sd_setImageWithURL:[NSURL URLWithString:videoFour.imgsrc] placeholderImage:[UIImage imageNamed:@"logo"]];
            heardView.rigthTwoButton.nameLabel.text = videoFour.title;
            [heardView.rigthTwoButton addTarget:self action:@selector(rightOneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.tableView reloadData];
        });

    }];

}

/**
 *  heardview点击
 *
 */

- (void)leftOneButtonAction:(UIButton *)sender
{
    HeardTableViewController * heardVC = [[HeardTableViewController alloc] init];
    heardVC.videoSid = _videoSidArray[0];
    [self.navigationController pushViewController:heardVC animated:YES];
}

- (void)leftTwoButtonAction:(UIButton *)sender{
    HeardTableViewController * heardVC = [[HeardTableViewController alloc] init];
    heardVC.videoSid = _videoSidArray[1];
    [self.navigationController pushViewController:heardVC animated:YES];
}

- (void)rightOneButtonAction:(UIButton *)sender{
    HeardTableViewController * heardVC = [[HeardTableViewController alloc] init];
    heardVC.videoSid = _videoSidArray[2];
    [self.navigationController pushViewController:heardVC animated:YES];
}

- (void)rightTwoButtonAction:(UIButton *)sender{
    NSLog(@"123");
    HeardTableViewController * heardVC = [[HeardTableViewController alloc] init];
    heardVC.videoSid = _videoSidArray[3];
    [self.navigationController pushViewController:heardVC animated:YES];
}

/**
 *  下拉刷新 上拉加载
 */

- (void)refresh{
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[GetVideoDataTools shareDataTools] getHeardDataWithURL:homeURL HeardValue:^(NSArray *heardArray, NSArray *videoArray) {
            _videoArray = videoArray;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [tableView.mj_header endRefreshing];
            });
        }];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSString *URL = [NSString stringWithFormat:moreURL,self.videoArray.count - self.videoArray.count%10];
        [[GetVideoDataTools shareDataTools] getHeardDataWithURL:URL HeardValue:^(NSArray *heardArray, NSArray *videoArray) {
            [self.videoArray addObjectsFromArray:videoArray];
            [[GetVideoDataTools shareDataTools].dataArray addObjectsFromArray:videoArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [tableView.mj_header endRefreshing];
            });
        }];
        // 结束刷新
        [tableView.mj_footer endRefreshing];
    }];


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videoArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 275;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RootTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath]; //根据indexPath准确地取出一行，而不是从cell重用队列中取出
    if (cell == nil) {
        cell = [[RootTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.video = self.videoArray[indexPath.row];
    [cell.playButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.playButton.tag = 100 + indexPath.row;
    return cell;
}

// 根据点击的Cell控制播放器的位置
- (void)playButtonAction:(UIButton *)sender{
    _fmVideoPlayer.index = sender.tag - 100;
    Video * video = _videoArray[sender.tag - 100];
    [_fmVideoPlayer setUrlString:video.mp4_url];
    _fmVideoPlayer.frame = CGRectMake(0, 275*(sender.tag - 100) + kScreenWidth/5 + 50  , kScreenWidth, (self.view.frame.size.width-20)/2);
    [self.view addSubview:_fmVideoPlayer];
    _fmVideoPlayer.contrainerViewController = self;
    [_fmVideoPlayer.player play];
    [_fmVideoPlayer showToolView:NO];
    _fmVideoPlayer.playOrPauseBtn.selected = YES;
    _fmVideoPlayer.hidden = NO;
}

// 根据Cell位置隐藏并暂停播放
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _fmVideoPlayer.index) {
        [_fmVideoPlayer.player pause];
        _fmVideoPlayer.hidden = YES;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_fmVideoPlayer.player pause];
    _fmVideoPlayer.hidden = YES;
    VideoViewController *videoController = [VideoViewController shareVideoController];
    videoController.video = self.videoArray[indexPath.row];
    [self.navigationController pushViewController:videoController animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
