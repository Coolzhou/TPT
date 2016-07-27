//
//  AppDelegate+shareSDK.h
//  tpt
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (shareSDK)

- (void)shareSDKApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

- (BOOL)shareSDKapplication:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
                 annotation:(id)annotation;

-(BOOL)shareSDKapplication:(UIApplication *)application
                 handleOpenURL:(NSURL *)url;

@end
