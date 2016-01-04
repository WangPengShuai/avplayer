//
//  GetVideoDataTools.m
//  ioshuanwu
//
//  Created by 幻音 on 15/12/28.
//  Copyright © 2015年 幻音. All rights reserved.
//

#import "GetVideoDataTools.h"

@implementation GetVideoDataTools

+ (instancetype)shareDataTools
{
    static GetVideoDataTools *gd = nil;
    static dispatch_once_t token;
    if (gd == nil) {
        dispatch_once(&token, ^{
            gd = [[GetVideoDataTools alloc] init];
        });
    }
    return gd;
}

- (void)getHeardDataWithURL:(NSString *)URL HeardValue:(HeardValue)heardValue
{
    dispatch_queue_t global_t = dispatch_get_global_queue(0, 0);
    dispatch_async(global_t, ^{
        NSURL *url = [NSURL URLWithString:URL];
        NSMutableArray *heardArray = [NSMutableArray array];
        NSMutableArray *videoArray = [NSMutableArray array];
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * response, NSData *  data, NSError *  connectionError) {
            if (data == nil) {
                NSLog(@"错误%@",connectionError);
                return ;
            }
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSArray *videoList = [dict objectForKey:@"videoList"];
            NSArray *videoSidList = [dict objectForKey:@"videoSidList"];
            for (NSDictionary * video in videoList) {
                Video * v = [[Video alloc] init];
                [v setValuesForKeysWithDictionary:video];
                [videoArray addObject:v];
            }
            [self.dataArray addObjectsFromArray:videoArray];
            // 加载头标题
            for (NSDictionary *d in videoSidList) {
                VideoSid *g = [[VideoSid alloc] init];
                [g setValuesForKeysWithDictionary:d];
                [heardArray addObject:g];
            }
            heardValue(heardArray,videoArray);
        }];
        
    });

}

- (void)getListDataWithURL:(NSString *)URL ListID:(NSString *)ID ListValue:(ListValue) listValue{
    dispatch_queue_t global_t = dispatch_get_global_queue(0, 0);
    dispatch_async(global_t, ^{
        NSURL *url = [NSURL URLWithString:URL];
        NSMutableArray *listArray = [NSMutableArray array];
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * response, NSData *  data, NSError *  connectionError) {
            if (data == nil) {
                NSLog(@"错误%@",connectionError);
                return ;
            }
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSArray *videoList = [dict objectForKey:ID];
            for (NSDictionary * video in videoList) {
                Video * v = [[Video alloc] init];
                [v setValuesForKeysWithDictionary:video];
                [listArray addObject:v];
            }
            listValue(listArray);
        }];
        
    });

}

// 懒加载初始数组
- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (Video *)getModelWithIndex:(NSInteger)index
{
    return self.dataArray[index];
}


@end
