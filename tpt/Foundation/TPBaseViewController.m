//
//  TPBaseViewController.m
//  tpt
//
//  Created by Yi luqi on 16/7/30.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import "TPBaseViewController.h"
#import "TPTool.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKExtension/SSEShareHelper.h>

@interface TPBaseViewController ()

@end

@implementation TPBaseViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setInViewWillAppear];
    
}

-(void)viewDidLoad{
    [super viewDidLoad];

    //背景图片
    [self.view addSubview:self.bgimageView];
    
    
    UIBarButtonItem *left_navigationItem = [[UIBarButtonItem alloc]initWithCustomView:self.navbackButton];
    
    UIBarButtonItem *right_navigationItem = [[UIBarButtonItem alloc]initWithCustomView:self.navrightButton];
    
    self.navigationItem.leftBarButtonItem = left_navigationItem;
    self.navigationItem.rightBarButtonItem = right_navigationItem;
    self.navigationItem.titleView = self.navTitleLable;

}

-(void)clickLeftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickRightBarButtonItem{

    NSLog(@"分享到相册");

    [self screenShare];
}


#pragma mark 分享
-(void)shareReftList{

    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"shareImg.png"]];
    //    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {

        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                         images:imageArray
                                            url:[NSURL URLWithString:@"http://mob.com"]
                                          title:@"分享标题"
                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:@[@(SSDKPlatformSubTypeWechatSession),
                                         @(SSDKPlatformSubTypeWechatTimeline),
                                         @(SSDKPlatformTypeQQ),
                                         @(SSDKPlatformTypeSinaWeibo),
                                         @(SSDKPlatformTypeFacebook),
                                         @(SSDKPlatformTypeTwitter),
                                         @(SSDKPlatformTypeGooglePlus),
                                         @(SSDKPlatformTypeLine),
                                         @(SSDKPlatformTypeWhatsApp)]
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {

                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];

                               NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];

    }
}

/**
 *  屏幕截图分享
 */
- (void)screenShare
{
    /**
     * 使用ShareSDKExtension插件可以实现屏幕截图分享，对于原生界面和OpenGL的游戏界面同样适用
     * 通过使用SSEShareHelper可以调用屏幕截图分享方法，在方法的第一个参数里面可以取得截图图片和分享处理入口，只要构造分享内容后，将要分享的内容和平台传入分享处理入口即可。
     *
     * 小技巧：
     * 当取得屏幕截图后，如果shareHandler入口不满足分享需求（如截取屏幕后需要弹出分享菜单而不是直接分享），可以不调用shareHandler进行分享，而是在block中写入自定义的分享操作。
     * 这样的话截屏分享接口实质只充当获取屏幕截图的功能。
     **/

    __weak TPBaseViewController *theController = self;

    [SVProgressHUD show];

    [SSEShareHelper screenCaptureShare:^(SSDKImage *image, SSEShareHandler shareHandler) {

        if (!image)
        {
            //如果无法取得屏幕截图则使用默认图片
            image = [[SSDKImage alloc] initWithImage:[UIImage imageNamed:@"shareImg.png"] format:SSDKImageFormatJpeg settings:nil];
        }

        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                         images:@[image]
                                            url:[NSURL URLWithString:@"http://mob.com"]
                                          title:@"分享标题"
                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:theController.view //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:@[@(SSDKPlatformSubTypeWechatSession),
                                         @(SSDKPlatformSubTypeWechatTimeline),
                                         @(SSDKPlatformTypeQQ),
                                         @(SSDKPlatformTypeSinaWeibo),
                                         @(SSDKPlatformTypeFacebook),
                                         @(SSDKPlatformTypeTwitter),
                                         @(SSDKPlatformTypeGooglePlus),
                                         @(SSDKPlatformTypeLine),
                                         @(SSDKPlatformTypeWhatsApp)]
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {

                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];

                               NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
                               break;
                           }
                           default:
                               break;
                       }
                            [SVProgressHUD dismiss];
                   }

         ];
    } onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
    }];
}



-(UIImageView *)bgimageView{
    if (!_bgimageView) {
        _bgimageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _bgimageView.image = [UIImage imageNamed:@"main_bg"];
        
    }
    return _bgimageView;
}

-(UIButton *)navbackButton{
    if (!_navbackButton) {
        _navbackButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        [_navbackButton setImage:[UIImage imageNamed:@"navigation_back"] forState:UIControlStateNormal];
        [_navbackButton addTarget:self action:@selector(clickLeftBarButtonItem) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navbackButton;
}

-(UIButton *)navrightButton{
    if (!_navrightButton) {
        _navrightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        [_navrightButton setImage:[UIImage imageNamed:@"navigation_share"] forState:UIControlStateNormal];
        [_navrightButton addTarget:self action:@selector(clickRightBarButtonItem) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navrightButton;
}

-(UILabel *)navTitleLable{
    if (!_navTitleLable) {
        _navTitleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,120, 44)];
        _navTitleLable.textAlignment = NSTextAlignmentCenter;
        _navTitleLable.textColor = MainTitleColor;
        _navTitleLable.font = [UIFont systemFontOfSize:17];
    }
    return _navTitleLable;
}
@end
