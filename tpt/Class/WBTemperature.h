//
//  WBTemperature.h
//  WenBoshi
//
//  Created by 马浩然 on 15/3/30.
//  Copyright (c) 2015年 luoshuisheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBTemperature : NSObject

/** 温度*/
@property (nonatomic ,assign) CGFloat temp;
/** 时间*/
@property (nonatomic ,copy) NSString *create_time;
/** 完整时间*/
@property (nonatomic ,copy) NSString *temp_time;
/** 温度状态*/
@property (nonatomic ,copy) NSString *temp_state;


///** */
//@property (nonatomic ,assign) int tempID;

@end
