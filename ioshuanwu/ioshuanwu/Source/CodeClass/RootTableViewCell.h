//
//  RootTableViewCell.h
//  ioshuanwu
//
//  Created by 幻音 on 15/12/28.
//  Copyright © 2015年 幻音. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FMGVideoPlayView;
@interface RootTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel          * title;
@property (nonatomic, strong) UILabel          * descriptionLabel;
@property (nonatomic, strong) FMGVideoPlayView * playerView;
@property (nonatomic, strong) UIImageView      * timeImage;
@property (nonatomic, strong) UILabel          * timeLabel;
@property (nonatomic, strong) UIImageView      * playCountImage;
@property (nonatomic, strong) UILabel          * playCountLabel;
@property (nonatomic, strong) UIButton         * replyButton;
@property (nonatomic, strong) UIButton         * shareButton;
@property (nonatomic, strong) UIImageView      * backImage;
@property (nonatomic, strong) UIButton         * playButton;

@property (nonatomic, strong) Video            * video;

@end
