//
//  TPTool.h
//  tpt
//
//  Created by apple on 16/8/8.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TPToolShare [TPTool sharedToolInstance]

@interface TPTool : NSObject

+(instancetype)sharedToolInstance;

//当前温度状态 0正常 1低热 2中热 3高热4 超热
+(NSString *)getCurrentTempState:(NSString *)temp;

//截屏
+(UIImage *)captureScreen;

//保存到相册
+(void)saveScreenshotToPhotosAlbum;

//根据单位℃、℉ 得到不同温度NSString
+(CGFloat)getUnitCurrentTemp:(NSString *)temp;


//根据单位℃ 得到华氏度温度CGFloat
+(CGFloat)getUnitCurrentTempFloat:(CGFloat)temp;

//根据单位℉ 得到摄氏度温度CGFloat
+(CGFloat)getFahrenheitDegrrTempFloat:(NSString *)temp;

//根据单位℉ 得到摄氏度温度CGFloat
+(CGFloat)getFahrenheitDegrrCurrentTempFloat:(CGFloat)temp;

//根据超限温度提示不同警报
+(void)palyAlartTempFloat:(CGFloat)temp andVC:(UIViewController *)vc;

//设备断开连接时警报
+(void)deviceCutUpalyAlart:(UIViewController *)vc;

//间隔
+(NSInteger)getMaxTemp:(CGFloat)temp;

//返回当前时间
+(NSString *)getCurrentDate;

//返回当前时间戳
+(int)getCurrentTimeIntDate;

//返回当前时间YYYY/MM/DD hh:ss:mm
+(NSString *)getTempCurrentDate;


//时间戳转时间yyyy/MM/dd hh:mm:ss
+(NSString *)dateTimeWithNStringTime:(int)timerInterval;

//时间戳转时间hh:mm:ss
+(NSString *)stringDataWithTimeInterval:(int)timerInterval;

//时间yyyy/MM/dd hh:mm:ss 转时间戳 int
+(int)dateTimeIntervalWithNIntTime:(NSDate *)timer;

//NSDate 0点的时间戳 int
+(int)dateZeroTimeIntervalWithIntTime:(NSDate *)timer;

//pragma mark 返回本月第一天时间戳
+(int)datecurrentMonthFirestDayTime;

//时间
+(NSString *)dateTimeForLocaleDate:(NSDate *)currentDate;
//判断当前系统系统语言
+ (BOOL)getPreferredLanguage;

@end
