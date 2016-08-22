//
//  ZCModelUser.h
//  zctx
//
//  Created by Darren Zheng on 15/10/8.
//  Copyright © 2015年 sanliang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UserModel [ZCUserModel sharedInstance]

@interface ZCUserModel : NSObject

+ (ZCUserModel *)sharedInstance;
@property (nonatomic,strong)NSString *username;
@property (nonatomic, strong) NSString *max_tem_low; //低热
@property (nonatomic, strong) NSString *max_tem_middle; //中热
@property (nonatomic, strong) NSString *max_tem_high;   //高热
@property (nonatomic, strong) NSString *max_tem_supper_high; //超高热
@property (nonatomic, strong) NSString *max_alert_state; //警报开启、关闭
@property (nonatomic, strong) NSString *max_notify_voice; //铃声
@property (nonatomic, strong) NSString *max_notify_vibration;  //振动

@property (nonatomic, strong) NSString *temp_check;

@end
