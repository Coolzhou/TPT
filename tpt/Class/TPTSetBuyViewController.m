//
//  TPTSetBuyViewController.m
//  tpt
//
//  Created by zhou on 2017/6/1.
//  Copyright © 2017年 MDJ. All rights reserved.
//

#import "TPTSetBuyViewController.h"
#import <WebKit/WebKit.h>
@interface TPTSetBuyViewController ()

@property (nonatomic,strong)WKWebView *webView;

@end

@implementation TPTSetBuyViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[[self.navigationController.navigationBar subviews]objectAtIndex:0] setAlpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:MainTitleColor imageSize:CGSizeMake(SCREEN_WIDTH, 64)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = NSLocalizedString(@"system_device_name_1",@"");;
    
    [self.view addSubview:self.webView];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://h5.m.taobao.com/awp/core/detail.htm?id=551592826586"]]];
    [self.view addSubview:self.webView];
}


- (WKWebView *)webView{
    if (!_webView) {
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        
    }
    return _webView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
