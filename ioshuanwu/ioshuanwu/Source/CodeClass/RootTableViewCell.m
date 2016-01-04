//
//  RootTableViewCell.m
//  ioshuanwu
//
//  Created by 幻音 on 15/12/28.
//  Copyright © 2015年 幻音. All rights reserved.
//

#import "RootTableViewCell.h"

@implementation RootTableViewCell

- (UILabel *)title
{
    if (_title == nil) {
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 20)];
//        self.title.font = [UIFont systemFontOfSize:]
        [self.contentView addSubview:_title];
    }
    return _title;
}

- (UILabel *)descriptionLabel
{
    if (_descriptionLabel == nil) {
        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.title.frame), CGRectGetMaxY(self.title.frame), CGRectGetWidth(self.title.frame), 20)];
        self.descriptionLabel.textColor = [UIColor grayColor];
        self.descriptionLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_descriptionLabel];
    }
    return _descriptionLabel;
}

- (UIImageView *)backImage
{
    if (_backImage == nil) {
        self.backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.descriptionLabel.frame), kScreenWidth, CGRectGetWidth(self.title.frame)/2)];
        [self.contentView addSubview:_backImage];
    }
    return _backImage;
}

- (UIButton *)playButton{
    if (_playButton == nil) {
        self.playButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.playButton.frame = CGRectMake(0, 0, 50, 50);
        self.playButton.center = self.backImage.center;
        //        self.playButton.backgroundColor = [UIColor yellowColor];
        [self.contentView addSubview:_playButton];
    }
    return _playButton;
}

- (UIImageView *)timeImage
{
    if (_timeImage == nil) {
        self.timeImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.title.frame), CGRectGetMaxY(self.backImage.frame)+10, 20, 20)];
        [self.contentView addSubview:_timeImage];
    }
    return _timeImage;
}

- (UILabel *)timeLabel
{
    if (_timeLabel == nil) {
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.timeImage.frame), CGRectGetMinY(self.timeImage.frame), CGRectGetWidth(self.timeImage.frame) * 2.5, CGRectGetHeight(self.timeImage.frame))];
        self.timeLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UIImageView *)playCountImage
{
    if (_playCountImage == nil) {
        self.playCountImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.timeLabel.frame), CGRectGetMinY(self.timeLabel.frame), CGRectGetWidth(self.timeImage.frame), CGRectGetHeight(self.timeImage.frame))];
        [self.contentView addSubview:_playCountImage];
    }
    return _playCountImage;
}

- (UILabel *)playCountLabel
{
    if (_playCountLabel == nil) {
        self.playCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.playCountImage.frame), CGRectGetMinY(self.playCountImage.frame), CGRectGetWidth(self.timeLabel.frame), CGRectGetHeight(self.playCountImage.frame))];
        self.playCountLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_playCountLabel];
    }
    return _playCountLabel;
}

- (UIButton *)replyButton
{
    if (_replyButton == nil) {
        self.replyButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.replyButton.frame = CGRectMake(CGRectGetMaxX(self.playerView.frame) - 30, CGRectGetMinY(self.playCountLabel.frame), 15, 15);
        [self addSubview:_replyButton];
    }
    return _replyButton;
}

- (UIButton *)shareButton
{
    if (_shareButton == nil) {
        self.shareButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.replyButton.frame  = CGRectMake(CGRectGetMaxX(self.replyButton.frame), CGRectGetMinY(self.replyButton.frame), CGRectGetWidth(self.replyButton.frame), CGRectGetHeight(self.replyButton.frame));
        [self.contentView addSubview:_shareButton];
    }
    return _shareButton;
}

- (void)setVideo:(Video *)video
{
    self.title.text = video.title;
    self.descriptionLabel.text = video.descriptionDe;
    [self.backImage sd_setImageWithURL:[NSURL URLWithString:video.cover] placeholderImage:[UIImage imageNamed:@"logo"]];
    self.playCountLabel.text = [NSString stringWithFormat:@"%ld.%ld万",video.playCount/10000,video.playCount/1000-video.playCount/10000];
    self.timeLabel.text = [video.ptime substringWithRange:NSMakeRange(12, 4)];
    [self.playButton setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    self.playCountImage.image = [UIImage imageNamed:@"playcount"];
    self.timeImage.image = [UIImage imageNamed:@"time"];
   
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}




@end
