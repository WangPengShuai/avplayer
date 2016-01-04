//
//  HeardButton.m
//  ioshuanwu
//
//  Created by 幻音 on 15/12/28.
//  Copyright © 2015年 幻音. All rights reserved.
//

#import "HeardButton.h"

@implementation HeardButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        self.videoSid = [[VideoSid alloc] init];
    }
    return self;
}

- (UIImageView *)titleImage
{
    if (_titleImage == nil) {
        self.titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.frame)/4, 10, CGRectGetWidth(self.frame)/2, CGRectGetWidth(self.frame)/2)];
        self.titleImage.layer.cornerRadius = CGRectGetWidth(self.frame)/2*0.5;
        self.titleImage.layer.masksToBounds = YES;
        [self.titleImage sd_setImageWithURL:[NSURL URLWithString:_videoSid.imgsrc] placeholderImage:[UIImage imageNamed:@"logo"]];
        [self addSubview:_titleImage];
    }
    return _titleImage;
}

- (UILabel *)nameLabel
{
    if (_nameLabel == nil) {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleImage.frame), CGRectGetMaxY(self.titleImage.frame)+5, CGRectGetWidth(self.titleImage.frame), CGRectGetHeight(self.titleImage.frame)/2)];
        self.nameLabel.text = _videoSid.title;
        [self addSubview:_nameLabel];
    }
    return _nameLabel;
}



@end
