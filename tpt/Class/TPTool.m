//
//  TPTool.m
//  tpt
//
//  Created by apple on 16/8/8.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import "TPTool.h"
#import "MJAudioTool.h"
@implementation TPTool

+(instancetype)sharedToolInstance{
    static TPTool *tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[self alloc]init];
    });
    return tool;
}

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

//截屏
+ (UIImage *) captureScreen {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [keyWindow bounds];

    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
//保存到相册
+ (void)saveScreenshotToPhotosAlbum
{
    UIImageWriteToSavedPhotosAlbum([TPTool captureScreen], nil, nil, nil);
}

//根据单位℃、℉ 得到不同温度NSString
+(CGFloat)getUnitCurrentTemp:(NSString *)temp{

    CGFloat currentFloat = 0.0;
    CGFloat tempFloat = [temp floatValue];

    if (UserModel.temp_unit == NO) {
        //摄氏度
        currentFloat = tempFloat;
    }else{
        //华氏度
        currentFloat = 1.8 * tempFloat + 32;
    }
    return currentFloat;
}

//根据单位℃、℉ 得到不同温度CGFloat
+(CGFloat)getUnitCurrentTempFloat:(CGFloat)temp{
    CGFloat currentFloat = 0.0;
    CGFloat tempFloat = temp;
//    NSLog(@"currentFloat - temp = %f",temp);
    if (UserModel.temp_unit == NO) {
        //摄氏度
        currentFloat = tempFloat;
    }else{
        //华氏度
        currentFloat = 1.8 * tempFloat + 32;
    }

//    NSLog(@"currentFloat = %f",currentFloat);
    return currentFloat;
}

//根据超限温度提示不同警报
+(void)palyAlartTempFloat:(CGFloat)temp{

    //温度超限报警开关
    if (UserModel.max_alert_state) {
        if ((temp>=[UserModel.max_tem_low floatValue])&&(temp<[UserModel.max_tem_middle floatValue])) {
            if (UserModel.max_notify_voice) {
                //播放音乐
                [MJAudioTool playMusic:@"innocence.mp3"];
                //播放音效
//                [MJAudioTool playSound:@"alarm.wav"];
            }
            //振动
            if (UserModel.max_notify_vibration) {
                [MJAudioTool begainPlayingSoundid];
            }
        }else if ((temp>=[UserModel.max_tem_middle floatValue])&&(temp<[UserModel.max_tem_high floatValue])){
            if (UserModel.max_notify_voice) {
                //播放音乐
                [MJAudioTool playMusic:@"innocence.mp3"];
                //播放音效
//                [MJAudioTool playSound:@"alarm.wav"];
            }
            //振动
            if (UserModel.max_notify_vibration) {
                [MJAudioTool begainPlayingSoundid];
            }
        }else if ((temp>=[UserModel.max_tem_high floatValue])&&(temp<[UserModel.max_tem_supper_high floatValue])){
            if (UserModel.max_notify_voice) {
                //播放音乐
                [MJAudioTool playMusic:@"innocence.mp3"];
//                播放音效
//                [MJAudioTool playSound:@"alarm.wav"];
            }
            //振动
            if (UserModel.max_notify_vibration) {
                [MJAudioTool begainPlayingSoundid];
            }
        }else if (temp>=[UserModel.max_tem_supper_high floatValue]){
            if (UserModel.max_notify_voice) {
                //播放音乐
                [MJAudioTool playMusic:@"innocence.mp3"];
//                //播放音效
//                [MJAudioTool playSound:@"alarm.wav"];
            }
            //振动
            if (UserModel.max_notify_vibration) {
                [MJAudioTool begainPlayingSoundid];
            }
        }else{
            
        }
    }
}

//设备断开连接时警报
+(void)deviceCutUpalyAlart{
    //设备断开连接警报开启
    if (UserModel.device_disconnect) {
        //播放音乐
//        [MJAudioTool playMusic:@"innocence.mp3"];
        ////播放音效
        //[MJAudioTool playSound:@"alarm.wav"];

        [SVProgressHUD showErrorWithStatus:@"蓝牙设备断开连接"];
    }
}

//间隔
+(NSInteger)getMaxTemp:(CGFloat)temp{
    NSInteger  num = 0;
    if (temp>=0 && temp<=1) {
        return num = 1;
    }else if (temp>1 && temp<=2){
        return num = 2;
    }else if (temp>2 && temp<=3){
        return num = 3;
    }else if (temp>3 && temp<=4){
        return num = 4;
    }else if (temp>4 && temp<=5){
        return num = 5;
    }else if (temp>5 && temp<=6){
        return num = 6;
    }else{
        return 1;
    }
}




@end
