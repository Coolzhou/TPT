//
//  AppDelegate.h
//  tpt
//
//  Created by apple on 16/7/19.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BabyBluetooth.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic ,strong) BabyBluetooth *baby;

@property (nonatomic ,assign) BOOL isBackground;

+(AppDelegate *)shareDelegate;


@end

