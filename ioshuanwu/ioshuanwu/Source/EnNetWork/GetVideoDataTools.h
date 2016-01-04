//
//  GetVideoDataTools.h
//  ioshuanwu
//
//  Created by 幻音 on 15/12/28.
//  Copyright © 2015年 幻音. All rights reserved.
//

#import <Foundation/Foundation.h>
// heardViewArray
typedef void(^HeardValue)(NSArray *heardArray,NSArray *videoArray);

typedef void(^ListValue)(NSArray *listArray);

@interface GetVideoDataTools : NSObject

@property (nonatomic, strong) NSMutableArray * dataArray;

// 单例
+ (instancetype)shareDataTools;
// 根据URL获取数据
- (void)getHeardDataWithURL:(NSString *)URL HeardValue:(HeardValue) heardValue;

// 根据URL及VideoSid获得数据
- (void)getListDataWithURL:(NSString *)URL ListID:(NSString *)ID ListValue:(ListValue) listValue;

// 根据index返回一个Video
- (Video *)getModelWithIndex:(NSInteger)index;


@end
