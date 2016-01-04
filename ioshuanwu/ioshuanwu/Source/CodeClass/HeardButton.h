//
//  HeardButton.h
//  ioshuanwu
//
//  Created by 幻音 on 15/12/28.
//  Copyright © 2015年 幻音. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VideoSid;

@interface HeardButton : UIButton

@property (nonatomic, strong) UIImageView * titleImage;
@property (nonatomic, strong) UILabel     * nameLabel;
@property (nonatomic, strong) VideoSid    * videoSid;

@end
