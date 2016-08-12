//
//  TPTool.m
//  tpt
//
//  Created by apple on 16/8/8.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import "TPTool.h"

@implementation TPTool

+(NSString *)getCurrentDate{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSLog(@"dateString:%@",dateString);
    return dateString;
}

@end
