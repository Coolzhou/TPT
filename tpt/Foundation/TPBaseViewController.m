//
//  TPBaseViewController.m
//  tpt
//
//  Created by Yi luqi on 16/7/30.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import "TPBaseViewController.h"

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
