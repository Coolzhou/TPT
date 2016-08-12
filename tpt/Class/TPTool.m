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
    [dateFormatter setDateFormat:@"hh:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSLog(@"dateString:%@",dateString);
    return dateString;
}

+(NSString *)getTempCurrentDate{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd hh:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}

//当前温度状态 -1错误数据 0正常 1低热 2中热 3高热 4超热
+(NSString *)getCurrentTempState:(NSString *)temp{

    CGFloat currentTemp = temp.floatValue;
    if (currentTemp>=41) {
        return @"4";
    }else if (currentTemp>=39 && currentTemp<41){
        return @"3";
    }else if (currentTemp>=38 && currentTemp<39){
        return @"2";
    }else if (currentTemp>=37.5 && currentTemp<38){
        return @"2";
    }else if (currentTemp>=35 && currentTemp<37.5){
        return @"1";
    }else{
        return @"-1";
    }
}

@end
