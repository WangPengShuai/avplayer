//
//  HeardTableViewController.m
//  ioshuanwu
//
//  Created by 幻音 on 16/1/4.
//  Copyright © 2016年 幻音. All rights reserved.
//

#import "HeardTableViewController.h"
#import "FullViewController.h"


static NSString * ID = @"cell";
@interface HeardTableViewController ()<FMGVideoPlayViewDelegate>

@property (nonatomic, strong) NSMutableArray * dataArr; // 数据列表
@property (nonatomic, strong) FMGVideoPlayView * fmVideoPlayer; // 播放器
/* 全屏控制器 */
@property (nonatomic, strong) FullViewController *fullVc;


@end

@implementation HeardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _videoSid.title;
    [self.tableView registerClass:[RootTableViewCell class] forCellReuseIdentifier:ID];
    self.fmVideoPlayer = [FMGVideoPlayView videoPlayView];
    self.fmVideoPlayer.delegate = self;
    [self getData];
    [self refresh];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(leftAction:)];
}

- (void)leftAction:(UIBarButtonItem *)sender{
    [_fmVideoPlayer.player pause];
    [_fmVideoPlayer.player setRate:0];
    _fmVideoPlayer.playOrPauseBtn.selected = NO;
    _fmVideoPlayer.danmakuView.hidden = YES;
    //    [_playView.currentItem removeObserver:_playView forKeyPath:@"status"];
    //    [_playView.player replaceCurrentItemWithPlayerItem:nil];
    //    _playView.currentItem = nil;
    //    _playView.player = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 懒加载代码
- (FullViewController *)fullVc
{
    if (_fullVc == nil) {
        _fullVc = [[FullViewController alloc] init];
    }
    return _fullVc;
}

/**
 *   获取数据
 */

- (void)getData{
    NSString * url = [NSString stringWithFormat:listURL,_videoSid.sid];
    self.dataArr = [NSMutableArray array];
    [[GetVideoDataTools shareDataTools] getListDataWithURL:url ListID:_videoSid.sid ListValue:^(NSArray *listArray) {
        self.dataArr = listArray;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 上拉刷新,下拉加载
- (void)refresh{
    NSString * url = [NSString stringWithFormat:listURL,_videoSid.sid];
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[GetVideoDataTools shareDataTools] getListDataWithURL:url ListID:_videoSid.sid ListValue:^(NSArray *listArray) {
            _dataArr = listArray;
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
        NSString *URL = [NSString stringWithFormat:listMoreURL,_videoSid.sid,self.dataArr.count - self.dataArr.count%10];
        [[GetVideoDataTools shareDataTools] getListDataWithURL:URL ListID:_videoSid.sid ListValue:^(NSArray *listArray) {
            [self.dataArr addObjectsFromArray:listArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [tableView.mj_header endRefreshing];
            });
        }];
        // 结束刷新
        [tableView.mj_footer endRefreshing];
    }];
    
    
}

#pragma mark - 视频delegate
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
            _fmVideoPlayer.frame = CGRectMake(0,  275 * _fmVideoPlayer.index + 50 , kScreenWidth, (kScreenWidth-20)/2);
        }];
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
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
    cell.video = self.dataArr[indexPath.row];
    [cell.playButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.playButton.tag = 100 + indexPath.row;
    return cell;
}

- (void)playButtonAction:(UIButton *)sender{
    _fmVideoPlayer.index = sender.tag - 100;
    Video * video = _dataArr[sender.tag - 100];
    [_fmVideoPlayer setUrlString:video.mp4_url];
    _fmVideoPlayer.frame = CGRectMake(0, 275*(sender.tag - 100) + 50 , kScreenWidth, (self.view.frame.size.width-20)/2);
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
