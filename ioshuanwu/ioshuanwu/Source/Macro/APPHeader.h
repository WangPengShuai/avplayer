//
//  APPHeader.h
//  ProjectMusic
//
//  Created by young on 15/7/31.
//  Copyright (c) 2015年 young. All rights reserved.
//  这里存放普通的app宏定义和声明等信息.

#ifndef Project_APPHeader_h
#define Project_APPHeader_h

#define kScreenWidth CGRectGetWidth([UIScreen mainScreen].bounds)
#define kScreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)

#import "RootTableViewController.h"
#import "HeadView.h"
#import "HeardButton.h"
#import "VideoSid.h"
#import "Video.h"
#import "GetVideoDataTools.h"
#import "RootTableViewCell.h"
#import "VideoViewController.h"
#import "HeardTableViewController.h"

















































//TODO 提示
#define STRINGIFY(S) #S
#define DEFER_STRINGIFY(S) STRINGIFY(S)
#define PRAGMA_MESSAGE(MSG) _Pragma(STRINGIFY(message(MSG)))
#define FORMATTED_MESSAGE(MSG) "[TODO-" DEFER_STRINGIFY(__COUNTER__) "] " MSG " \n" \
DEFER_STRINGIFY(__FILE__) " line " DEFER_STRINGIFY(__LINE__)
#define KEYWORDIFY try {} @catch (...) {}
// 最终使用下面的宏
#define TODO(MSG) KEYWORDIFY PRAGMA_MESSAGE(FORMATTED_MESSAGE(MSG))


#endif
