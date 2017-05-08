//
//  TPTool.m
//  tpt
//
//  Created by apple on 16/8/8.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import "TPTool.h"
#import "MJAudioTool.h"
#import "AppDelegate.h"

@interface TPTool()
@property (nonatomic,strong)UIAlertController *alert;
@end

@implementation TPTool

+(instancetype)sharedToolInstance{
    static TPTool *tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[self alloc]init];
    });
    return tool;
}

//当前温度状态 -1错误数据 0正常 1低热 2中热 3高热 4超热
+(NSString *)getCurrentTempState:(NSString *)temp{

    CGFloat currentTemp = temp.floatValue;
    
    if ((currentTemp>=[UserModel.max_tem_low floatValue])&&(currentTemp<[UserModel.max_tem_middle floatValue])) {
        return @"1";
    }else if ((currentTemp>=[UserModel.max_tem_middle floatValue])&&(currentTemp<[UserModel.max_tem_high floatValue])){
        return @"2";
    }else if ((currentTemp>=[UserModel.max_tem_high floatValue])&&(currentTemp<[UserModel.max_tem_supper_high floatValue])){
        return @"3";
    }else if (currentTemp>=[UserModel.max_tem_supper_high floatValue]){
        return @"4";
    }else{
        return @"-1";
    }   
//    if (currentTemp>=41) {
//        return @"4";
//    }else if (currentTemp>=39 && currentTemp<41){
//        return @"3";
//    }else if (currentTemp>=38 && currentTemp<39){
//        return @"2";
//    }else if (currentTemp>=37.5 && currentTemp<38){
//        return @"2";
//    }else if (currentTemp>=35 && currentTemp<37.5){
//        return @"1";
//    }else{
//        return @"-1";
//    }
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


//根据单位℉ 得到摄氏度温度CGFloat
+(CGFloat)getFahrenheitDegrrTempFloat:(NSString *)temp{
    CGFloat currentFloat = 0.0;

    CGFloat tempFloat = [temp floatValue];
    //    NSLog(@"currentFloat - temp = %f",temp);
    if (UserModel.temp_unit == YES) {
        //摄氏度
        currentFloat = (tempFloat - 32)/1.8;
    }else{
        //华氏度
        currentFloat = tempFloat;
    }
    //    NSLog(@"currentFloat = %f",currentFloat);
    return currentFloat;
}

//根据单位℉ 得到摄氏度温度CGFloat
+(CGFloat)getFahrenheitDegrrCurrentTempFloat:(CGFloat)temp{
    CGFloat currentFloat = 0.0;
    CGFloat tempFloat = temp;
    //    NSLog(@"currentFloat - temp = %f",temp);
    if (UserModel.temp_unit == YES) {
        //摄氏度
        currentFloat = (temp - 32)/1.8;
    }else{
        //华氏度
        currentFloat = tempFloat;
    }
    //    NSLog(@"currentFloat = %f",currentFloat);
    return currentFloat;
}

//根据超限温度提示不同警报
+(void)palyAlartTempFloat:(CGFloat)temp andVC:(UIViewController *)vc{
    
    NSLog(@"temp = %f , low = %f , middle = %f ,hight = %f,supper_hight = %f",temp ,[UserModel.max_tem_low floatValue],[UserModel.max_tem_middle floatValue],[UserModel.max_tem_high floatValue],[UserModel.max_tem_supper_high floatValue] );
    
    AppDelegate *app = [AppDelegate shareDelegate];
    NSLog(@"app.bool =%d",app.isBackground);

    //温度超限报警开关
    if (UserModel.max_alert_state) {
        if ((temp>=[UserModel.max_tem_low floatValue])&&(temp<[UserModel.max_tem_middle floatValue])) {
            if (UserModel.alert_low ==NO) {
                [TPToolShare showAlertView:NSLocalizedString(@"max_tem_low",@"") andVC:vc andType:1];
                
                if (UserModel.max_notify_voice) {
                    //播放音乐
                    [MJAudioTool playMusic:@"main_alert_one.mp3"];
                }
                //振动
                if (UserModel.max_notify_vibration) {
                    [MJAudioTool begainPlayingSoundid];
                }
                if (app.isBackground == YES) {
                    [TPTool senderLocalNotifcation:NSLocalizedString(@"max_tem_low",@"")];
                }
            }
        }else if ((temp>=[UserModel.max_tem_middle floatValue])&&(temp<[UserModel.max_tem_high floatValue])){
            if (UserModel.alert_middle ==NO) {
                [TPToolShare showAlertView:NSLocalizedString(@"max_tem_middle",@"") andVC:vc andType:2];
                if (UserModel.max_notify_voice) {
                    //播放音乐
                    [MJAudioTool playMusic:@"main_alert_two.mp3"];
                }
                //振动
                if (UserModel.max_notify_vibration) {
                    [MJAudioTool begainPlayingSoundid];
                }
                if (app.isBackground == YES) {
                    [TPTool senderLocalNotifcation:NSLocalizedString(@"max_tem_middle",@"")];
                }
            }
        }else if ((temp>=[UserModel.max_tem_high floatValue])&&(temp<[UserModel.max_tem_supper_high floatValue])){
            if (UserModel.alert_high ==NO) {
                [TPToolShare showAlertView:NSLocalizedString(@"max_tem_high",@"") andVC:vc andType:3];
                if (UserModel.max_notify_voice) {
                    //播放音乐
                    [MJAudioTool playMusic:@"main_alert_three.mp3"];
                }
                //振动
                if (UserModel.max_notify_vibration) {
                    [MJAudioTool begainPlayingSoundid];
                }
                
                if (app.isBackground == YES) {
                    [TPTool senderLocalNotifcation:NSLocalizedString(@"max_tem_high",@"")];
                }
            }
            
            
        }else if (temp>=[UserModel.max_tem_supper_high floatValue]){
            if (UserModel.alert_supper_high ==NO) {
                [TPToolShare showAlertView:NSLocalizedString(@"max_tem_supper_high",@"") andVC:vc andType:4];
                if (UserModel.max_notify_voice) {
                    //播放音乐
                    [MJAudioTool playMusic:@"main_alert_free.mp3"];
                }
                //振动
                if (UserModel.max_notify_vibration) {
                    [MJAudioTool begainPlayingSoundid];
                }
                if (app.isBackground == YES) {
                    [TPTool senderLocalNotifcation:NSLocalizedString(@"max_tem_supper_high",@"")];
                }
            }
            
        }else{
            
        }
    }
}


+ (void)senderLocalNotifcation:(NSString *)nofiStr{
    
    NSLog(@"1212112");
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate=[NSDate dateWithTimeIntervalSinceNow:3];
    notification.timeZone=[NSTimeZone defaultTimeZone];
//    notification.applicationIconBadgeNumber = 0; //设置右上角小圆圈数字为1
    notification.soundName= UILocalNotificationDefaultSoundName;
    notification.alertBody = nofiStr;
    [[UIApplication sharedApplication]  scheduleLocalNotification:notification];
}

- (void)showAlertView:(NSString *)alertStr andVC:(UIViewController *)vc andType:(int)type{
    
    if (self.alert) {
        [self.alert dismissViewControllerAnimated:YES completion:^{
        }];
        self.alert = nil;
    }
    self.alert  = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"device_remind",@"") message:alertStr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_once",@"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_no",@"") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        switch (type) {
            case 1:{
                UserModel.alert_low = YES;
            }
                break;
            case 2:{
                UserModel.alert_low = YES;
                UserModel.alert_middle = YES;
            }
                break;
            case 3:{
                UserModel.alert_low = YES;
                UserModel.alert_middle = YES;
                UserModel.alert_high = YES;
            }
                break;
            default:{
                UserModel.alert_low = YES;
                UserModel.alert_middle = YES;
                UserModel.alert_high = YES;
                UserModel.alert_supper_high = YES;
            }
                break;
        }
    }];
    [self.alert addAction:action1];
    [self.alert addAction:action2];
    [vc presentViewController:self.alert animated:YES completion:^{
    }];
}

//设备断开连接时警报
+(void)deviceCutUpalyAlart:(UIViewController *)vc{
    //设备断开连接警报开启
    
    UserModel.alert_low = NO;
    UserModel.alert_middle = NO;
    UserModel.alert_high = NO;
    UserModel.alert_supper_high = NO;
    
    NSLog(@"断开报警 = %d",UserModel.device_disconnect);
    if (UserModel.device_disconnect) {
        AppDelegate *app = [AppDelegate shareDelegate];
        NSLog(@"app.bool =%d",app.isBackground);
        if (app.isBackground == YES) {
            [TPTool senderLocalNotifcation:NSLocalizedString(@"device_disconnected",@"")];
        }
        //提示
        UIAlertController *alert  = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"device_alert",@"") message:NSLocalizedString(@"device_disconnected",@"") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok",@"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:action1];
        [vc presentViewController:alert animated:YES completion:^{
            
        }];
        
        if (UserModel.max_notify_vibration) {
            [MJAudioTool begainPlayingSoundid];
        }
    }else{
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"device_disconnected",@"")];
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

+(NSString *)getCurrentDate{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
//    NSLog(@"dateString:%@",dateString);
    return dateString;
}

+(NSString *)getCurrentDay{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-mm-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSLog(@"dateString:%@",dateString);
    return dateString;
}

+(int)getCurrentTimeIntDate{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    int time = [currentDate timeIntervalSince1970];
//    NSLog(@"IntdateString:%d",time);
    return time;
}

+(NSString *)getTempCurrentDate{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd hh:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}

//时间戳转时间yyyy/MM/dd hh:mm:ss
+(NSString *)dateTimeWithNStringTime:(int)timerInterval{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timerInterval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd hh:mm:ss"];
    NSString *showtime = [formatter stringFromDate:date];
    return showtime;
}
//时间戳转时间hh:mm:ss
+(NSString *)stringDataWithTimeInterval:(int)timerInterval{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timerInterval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm:ss"];
    NSString *showtime = [formatter stringFromDate:date];
    return showtime;
}

//时间NSDate 转时间戳 int
+(int)dateTimeIntervalWithNIntTime:(NSDate *)timer{
    int time = [timer timeIntervalSince1970];
    return time;
}

//NSDate 0点的时间戳 int
+(int)dateZeroTimeIntervalWithIntTime:(NSDate *)timer{

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:timer];
    NSDate *startDate = [calendar dateFromComponents:components];
    int startInt = [TPTool dateTimeIntervalWithNIntTime:startDate];

//    NSLog(@"aaaa = %d ,bb = %d",[TPTool dateTimeIntervalWithNIntTime:startDate] ,[TPTool dateTimeIntervalWithNIntTime:[NSDate date]]);
    return startInt;
}

+(NSString *)dateTimeForLocaleDate:(NSDate *)currentDate{
    NSString *dateFormat;
    NSString *dateComponents = @"yMMMMd";

    NSDateFormatter *monthAndYearFormatter=[[NSDateFormatter alloc] init];

    if ([TPTool getPreferredLanguage]) {
        NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        dateFormat = [NSDateFormatter dateFormatFromTemplate:dateComponents options:0 locale:usLocale];
        monthAndYearFormatter.dateFormat=dateFormat;
        NSString *timeStr = [monthAndYearFormatter stringFromDate:currentDate];
        NSLog(@"timeStr1 = %@",timeStr);
        return timeStr;
    }else{

        NSLocale *zhLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        dateFormat = [NSDateFormatter dateFormatFromTemplate:dateComponents options:0 locale:zhLocale];
        monthAndYearFormatter.dateFormat=dateFormat;
        NSString *timeStr = [monthAndYearFormatter stringFromDate:currentDate];
        NSLog(@"timeStr2 = %@",timeStr);
        return timeStr;
    }
}

#pragma mark 返回本月第一天时间戳
+(int)datecurrentMonthFirestDayTime{
    NSDate *now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal
                               components:NSYearCalendarUnit | NSMonthCalendarUnit
                               fromDate:now];
    comps.day = 1;
    NSDate *firstDay = [cal dateFromComponents:comps];

    int firstTime = [self dateZeroTimeIntervalWithIntTime:firstDay];
    return firstTime;
}

/**
 *得到本机现在用的语言
 * en:英文  zh-Hans:简体中文   zh-Hant:繁体中文    ja:日本  ......
 */
+ (BOOL)getPreferredLanguage
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];

    if ([preferredLang hasPrefix:@"en"]) {
        return YES;
    }else if ([preferredLang hasPrefix:@"zh"]){
        return NO;
    }else{
        return YES;
    }
}

@end
