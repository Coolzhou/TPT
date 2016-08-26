//
//  TPBaseViewController.h
//  tpt
//
//  Created by Yi luqi on 16/7/30.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPBaseViewController : UIViewController

@property (nonatomic,strong) UIImageView *bgimageView;//背景图片

@property (nonatomic,strong)UIButton *navbackButton;//返回按钮

@property (nonatomic,strong)UIButton *navrightButton;//右侧按钮

@property (nonatomic,strong)UILabel *navTitleLable;//右侧按钮


//点击左导航按钮
-(void)clickLeftBarButtonItem;

//点击右导航按钮
-(void)clickRightBarButtonItem;

@end
