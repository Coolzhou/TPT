//
//  TPCommon.h
//  tpt
//
//  Created by apple on 16/7/21.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#ifndef TPCommon_h
#define TPCommon_h


#define  DEVICE_SYSTEM_VERSION ([[[UIDevice currentDevice] systemVersion] floatValue] >=9.0)

#define  DEVICE_SYSTEM_VERSION_ISIOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >=7.0)

#define  DEVICE_SYSTEM_VERSION_ISIOS10 ([[[UIDevice currentDevice] systemVersion] floatValue] >=10.0)

#define  DEVICE_SYSTEM_VERSION_ISIOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] <=8.0)

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define kUserDefaults     [NSUserDefaults standardUserDefaults]
//屏幕宽、高
#define kScreenRect   [[UIScreen mainScreen] bounds]
#define kScreenSize           [[UIScreen mainScreen] bounds].size
#define kScreenWidth          [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight         [[UIScreen mainScreen] bounds].size.height

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)


#define channelOnPeropheralView @"peripheralView"
#define channelOnCharacteristicView @"CharacteristicView"
#define kPeripheralName         @"360qws Electric Bike Service"         //外围设备名称
#define kServiceUUID            @"8A0DFFD0-B80C-4335-8E5F-630031415354" //服务的UUID
#define kCharacteristicWriteUUID     @"8A0DFFD1-B80C-4335-8E5F-630031415354" //读写特征的UUID
#define kCharacteristicReadUUID     @"8A0DFFD2-B80C-4335-8E5F-630031415354" //读通知特征的UUID

#endif /* TPCommon_h */
