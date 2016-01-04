//
//  HeadView.m
//  ioshuanwu
//
//  Created by 幻音 on 15/12/27.
//  Copyright © 2015年 幻音. All rights reserved.
//

#import "HeadView.h"

@implementation HeadView

- (UIButton *) leftOneButton
{
    if (_leftOneButton == nil) {
        self.leftOneButton = [HeardButton buttonWithType:UIButtonTypeInfoDark];
        self.leftOneButton.frame = CGRectMake(0, 0, kScreenWidth/5, kScreenWidth/5);
        self.leftOneButton.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.leftOneButton.nameLabel.textColor = [UIColor darkGrayColor];
        self.leftOneButton.nameLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_leftOneButton];
    }
    return _leftOneButton;
}
- (UIButton *) leftTwoButton
{
    if (_leftTwoButton == nil) {
        self.leftTwoButton = [HeardButton buttonWithType:UIButtonTypeSystem];
        self.leftTwoButton.frame = CGRectMake(CGRectGetMaxX(self.leftOneButton.frame),CGRectGetMinY(self.leftOneButton.frame),CGRectGetWidth(self.leftOneButton.frame),CGRectGetHeight(self.leftOneButton.frame));
        self.leftTwoButton.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.leftTwoButton.nameLabel.textColor = [UIColor darkGrayColor];
        self.leftTwoButton.nameLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_leftTwoButton];
    }
    return _leftTwoButton;
}
- (UIButton *) rightOneButton
{
    if (_rightOneButton == nil) {
        self.rightOneButton = [HeardButton buttonWithType:UIButtonTypeSystem];
        self.rightOneButton.frame = CGRectMake(CGRectGetMaxX(self.leftTwoButton.frame), CGRectGetMinY(self.leftTwoButton.frame), CGRectGetWidth(self.leftTwoButton.frame), CGRectGetHeight(self.leftTwoButton.frame));
        self.rightOneButton.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.rightOneButton.nameLabel.textColor = [UIColor darkGrayColor];
        self.rightOneButton.nameLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_rightOneButton];
    }
    return _rightOneButton;
}
- (UIButton *) rigthTwoButton
{
    if (_rigthTwoButton == nil) {
        self.rigthTwoButton = [HeardButton buttonWithType:UIButtonTypeSystem];
        self.rigthTwoButton.frame = CGRectMake(CGRectGetMaxX(self.rightOneButton.frame), CGRectGetMinY(self.leftTwoButton.frame), CGRectGetWidth(self.leftTwoButton.frame), CGRectGetHeight(self.leftTwoButton.frame));
        self.rigthTwoButton.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.rigthTwoButton.nameLabel.textColor = [UIColor darkGrayColor];
        self.rigthTwoButton.nameLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_rigthTwoButton];
    }
    return _rigthTwoButton;
}

@end
