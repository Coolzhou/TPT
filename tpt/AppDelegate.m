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
#import <AVFoundation/AVFoundation.h>
#import <UserNotifications/UserNotifications.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.isBackground = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMinimumDismissTimeInterval:3];
    //音频后台播放设置
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error = nil;
    [session setCategory:AVAudioSessionCategoryPlayback error:&error];
    if (error) {
        NSLog(@"%s %@", __func__, error);
    }else{
        NSLog(@"ssss");
    }
    [session setActive:YES error:nil];


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
        
        UserModel.alert_low = NO;
        UserModel.alert_middle = NO;
        UserModel.alert_high = NO;
        UserModel.alert_supper_high = NO;
    }
    
    self.baby = [BabyBluetooth shareBabyBluetooth];
    
    //shareSDK
    [self shareSDKApplication:application didFinishLaunchingWithOptions:launchOptions];
    
    //注册通知
    [self registerPushServer:application];

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

+(AppDelegate *)shareDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
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
    self.isBackground = YES;
    
    UIApplication*   app = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"backBabyBlue" object:self userInfo:nil];
}


#pragma mark 注册推送
-(void)registerPushServer:(UIApplication *)application
{
    if (DEVICE_SYSTEM_VERSION_ISIOS10) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            
            if (granted) {
                //点击允许
                NSLog(@"注册通知成功");
            } else {
                //点击不允许
                NSLog(@"注册通知失败");
            }
        }];
        //注册推送（同iOS8）
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
    }else {//iOS8到iOS10
        
        //1.创建消息上面要添加的动作(按钮的形式显示出来)
        UIMutableUserNotificationAction *action = [[UIMutableUserNotificationAction alloc] init];
        action.identifier = @"action";//按钮的标示
        action.title=@"Accept";//按钮的标题
        action.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        //    action.authenticationRequired = YES;
        //    action.destructive = YES;
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];
        action2.identifier = @"action2";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action.destructive = YES;
        
        //2.创建动作(按钮)的类别集合
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"alert";//这组动作的唯一标示,推送通知的时候也是根据这个来区分
        [categorys setActions:@[action,action2] forContext:(UIUserNotificationActionContextMinimal)];
        
        //3.创建UIUserNotificationSettings，并设置消息的显示类类型
        UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:( UIUserNotificationTypeAlert | UIRemoteNotificationTypeSound) categories:[NSSet setWithObjects:categorys, nil ,nil]];//categories设置为nil则推送无动作
        [application registerForRemoteNotifications];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    self.isBackground = NO;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"foregroundBabyBlue" object:self userInfo:nil];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
