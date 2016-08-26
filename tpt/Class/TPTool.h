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
//返回当前时间hh:ss:mm
+(NSString *)getCurrentDate;

//返回当前时间YYYY/MM/DD hh:ss:mm
+(NSString *)getTempCurrentDate;

//当前温度状态 0正常 1低热 2中热 3高热4 超热
+(NSString *)getCurrentTempState:(NSString *)temp;

//截屏
+(UIImage *) captureScreen;

//保存到相册
+(void)saveScreenshotToPhotosAlbum;

//根据单位℃、℉ 得到不同温度NSString
+(CGFloat)getUnitCurrentTemp:(NSString *)temp;


//根据单位℃、℉ 得到不同温度CGFloat
+(CGFloat)getUnitCurrentTempFloat:(CGFloat)temp;
@end
