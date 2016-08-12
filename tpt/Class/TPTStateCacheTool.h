//
//  TPTStateCacheTool.h
//  tpt
//
//  Created by apple on 16/8/12.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import <Foundation/Foundation.h>


@class WBTemperature;

@interface TPTStateCacheTool : NSObject

/** 缓存温度*/
+(void)addTemperature:(WBTemperature *)temp;

/** 混存一组温度数据*/
+(void)addtemperatures:(NSArray *)tempAry;

/** 获取一组数组里面的数据*/
+(NSArray *)getTemperature;

/** 获取一组数据的最大温度*/
+(CGFloat)getMaxTemp:(int)tempID;

/** 获取一组数据的最小温度*/
+(CGFloat)getMinTemp:(int)tempID;

/** 总共记录的数组数*/
+(NSArray*)temperatureCounts;

/** 删除一条温度*/
+(void)deleteTemp:(int)tempID;

+(void)deleteAllTemp;

@end
