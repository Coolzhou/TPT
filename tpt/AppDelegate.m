//
//  AppDelegate.m
//  tpt
//
//  Created by apple on 16/7/19.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+shareSDK.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyBluetooth.h"

#import "MCLeftSlideViewController.h"
#import "MCLeftSortsViewController.h"
#import "MCFirstPageVIewController.h"
#import "MCMainNavgationVC.h"

#import "ZCUserModel.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMinimumDismissTimeInterval:3];

    NSArray *centralManagerIdentifiers = launchOptions[UIApplicationLaunchOptionsBluetoothCentralsKey];
    NSLog(@"centralManagerIdentifiers = %@",centralManagerIdentifiers);

    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStartTemp"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStartTemp"];
        UserModel.max_tem_low = @"37.5";
        UserModel.max_tem_middle = @"38.1";
        UserModel.max_tem_high = @"39.1";
        UserModel.max_tem_supper_high = @"40.1";
        UserModel.temp_currentElec = @"35";
        UserModel.temp_check = @"0.0";
        UserModel.max_alert_state = YES;
        UserModel.max_notify_vibration = YES;
        UserModel.max_notify_voice = YES;
        UserModel.temp_unit = NO;
        UserModel.device_disconnect = YES;
    }
    //shareSDK
    [self shareSDKApplication:application didFinishLaunchingWithOptions:launchOptions];

    [self initRootViewController];

    [self.window makeKeyAndVisible];
    return YES;
}

/// 设置跟控制器
-(void)initRootViewController{

    MCFirstPageVIewController *firstVC = [[MCFirstPageVIewController alloc] init];

    UINavigationController *firstNav = [[MCMainNavgationVC alloc] initWithRootViewController:firstVC];

    MCLeftSortsViewController *leftVC = [[MCLeftSortsViewController alloc] init];
    MCLeftSlideViewController *rootVC = [[MCLeftSlideViewController alloc] initWithLeftView:leftVC andMainView:firstNav];
    self.window.rootViewController = rootVC;

}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [self shareSDKapplication:application handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [self shareSDKapplication:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

    [[NSNotificationCenter defaultCenter]postNotificationName:@"backBabyBlue" object:self userInfo:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"foregroundBabyBlue" object:self userInfo:nil];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
