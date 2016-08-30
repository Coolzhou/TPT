//
//  AppDelegate+shareSDK.m
//  tpt
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import "AppDelegate+shareSDK.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"

@implementation AppDelegate (shareSDK)

- (void)shareSDKApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{


    [ShareSDK registerApp:@"145c6e548ff1c"

          activePlatforms:@[@(SSDKPlatformSubTypeWechatSession),
                            @(SSDKPlatformSubTypeWechatTimeline),
                            @(SSDKPlatformTypeQQ),
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeFacebook),
                            @(SSDKPlatformTypeTwitter),
                            @(SSDKPlatformTypeGooglePlus),
                            @(SSDKPlatformTypeLine),
                            @(SSDKPlatformTypeWhatsApp)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {

         switch (platformType)
         {
            case SSDKPlatformTypeWechat:
                 //设置微信应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupWeChatByAppId:@"wx3db4fa21fcd98229" appSecret:@"d3031a27d8909774b05df71df850d008"];
                 break;
             case SSDKPlatformTypeQQ:
                 //设置QQ应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupQQByAppId:@"1105440397"
                                      appKey:@"V8CVLVkNqEB1RI3t"
                                    authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"1708550035"
                                           appSecret:@"703b904c100683f3ed515f5f86235cc2"
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeFacebook:
                 //设置Facebook应用信息,其中authType设置为使用SSO＋Web形式授权

                 [appInfo SSDKSetupFacebookByApiKey:@"1649623158695091" appSecret:@"7531e43cb2d83c8967a219a5a9e8d8fd" authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeTwitter:
                 //设置Twitter应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupTwitterByConsumerKey:@"lvLq2bN8fqtZPKxU2Sv5TAEHb" consumerSecret:@"YX1CxiBPMXvgGKHkXoiOHg4eFWl7fQ6QKYZFetmWWQAVyrFgP1" redirectUri:@"http://www.sharesdk.cn"];
                 break;
             case SSDKPlatformTypeGooglePlus:
                 [appInfo SSDKSetupGooglePlusByClientID:@"232554794995.apps.googleusercontent.com" clientSecret:@"PEdFgtrMw97aCvf0joQj7EMk" redirectUri:@"http://localhost"];
                 break;
             default:
                 break;
         }
     }];
}

-(BOOL)shareSDKapplication:(UIApplication *)application
             handleOpenURL:(NSURL *)url{

    return YES;
    
}

- (BOOL)shareSDKapplication:(UIApplication *)application
                    openURL:(NSURL *)url
          sourceApplication:(NSString *)sourceApplication
                 annotation:(id)annotation{

    return YES;

}



@end
