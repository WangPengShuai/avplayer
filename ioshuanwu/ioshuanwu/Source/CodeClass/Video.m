//
//  Video.m
//  ioshuanwu
//
//  Created by 幻音 on 15/12/28.
//  Copyright © 2015年 幻音. All rights reserved.
//

#import "Video.h"

@implementation Video

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"description"]) {
        self.descriptionDe = value;
    }
}

@end
