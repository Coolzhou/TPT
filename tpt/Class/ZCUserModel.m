//
//  ZCModelUser.m
//  zctx
//
//  Created by Darren Zheng on 15/10/8.
//  Copyright © 2015年 sanliang. All rights reserved.
//

#import "ZCUserModel.h"


@implementation ZCUserModel

static NSString * const MAX_TEM_LOW = @"max_tem_low";
static NSString * const MAX_TEM_MIDDLE = @"max_tem_middle";
static NSString * const MAX_TEM_HIGH = @"max_tem_high";
static NSString * const MAX_TEM_SUPPER_HIGH = @"max_tem_supper_high";

static NSString * const MAX_ALERT_STATE = @"max_alert_state";
static NSString * const MAX_NOTIFY_VOICE= @"max_notify_voice";
static NSString * const MAX_NOFIFY_VIBRATION= @"max_notify_vibration";

+ (ZCUserModel *)sharedInstance
{
    static ZCUserModel *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

//低温
-(void)setMax_tem_low:(NSString *)max_tem_low{
    [[NSUserDefaults standardUserDefaults] setObject:max_tem_low forKey:MAX_TEM_LOW];
}

-(NSString *)max_tem_low{
    NSString *tem_low = [[NSUserDefaults standardUserDefaults]objectForKey:MAX_TEM_LOW];
    return tem_low;
}

//中温
-(void)setMax_tem_middle:(NSString *)max_tem_middle{
    [[NSUserDefaults standardUserDefaults] setObject:max_tem_middle forKey:MAX_TEM_MIDDLE];
}
-(NSString *)max_tem_middle{
    NSString *max_middle = [[NSUserDefaults standardUserDefaults]objectForKey:MAX_TEM_MIDDLE];
    return max_middle;
}

//高温
-(void)setMax_tem_high:(NSString *)max_tem_high{
    [[NSUserDefaults standardUserDefaults] setObject:max_tem_high forKey:MAX_TEM_HIGH];
}
-(NSString *)max_tem_high{
    NSString *max_hight = [[NSUserDefaults standardUserDefaults]objectForKey:MAX_TEM_HIGH];
    return max_hight;
}

//超高
-(void)setMax_tem_supper_high:(NSString *)max_tem_supper_high{
    [[NSUserDefaults standardUserDefaults] setObject:max_tem_supper_high forKey:MAX_TEM_SUPPER_HIGH];
}
-(NSString *)max_tem_supper_high{
    NSString *max_super_hight = [[NSUserDefaults standardUserDefaults]objectForKey:MAX_TEM_SUPPER_HIGH];
    return max_super_hight;
}

//警报开关
-(void)setMax_alert_state:(NSString *)max_alert_state{
    [[NSUserDefaults standardUserDefaults] setObject:max_alert_state forKey:MAX_ALERT_STATE];
}
-(NSString *)max_alert_state{
    NSString *max_alert_state = [[NSUserDefaults standardUserDefaults]objectForKey:MAX_ALERT_STATE];
    return max_alert_state;
}

//铃声
-(void)setMax_notify_voice:(NSString *)max_notify_voice{
    [[NSUserDefaults standardUserDefaults] setObject:max_notify_voice forKey:MAX_NOTIFY_VOICE];
}
-(NSString *)max_notify_voice{
    NSString *max_notify_voice = [[NSUserDefaults standardUserDefaults]objectForKey:MAX_NOTIFY_VOICE];
    return max_notify_voice;
}

//振动
-(void)setMax_notify_vibration:(NSString *)max_notify_vibration{
    [[NSUserDefaults standardUserDefaults] setObject:max_notify_vibration forKey:MAX_NOFIFY_VIBRATION];
}
-(NSString *)max_notify_vibration{
    NSString *max_notify_vibration = [[NSUserDefaults standardUserDefaults]objectForKey:MAX_NOFIFY_VIBRATION];
    return max_notify_vibration;
}

@end
