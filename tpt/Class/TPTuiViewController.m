//
//  TPTuiViewController.m
//  tpt
//
//  Created by Yi luqi on 16/7/31.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import "TPTuiViewController.h"

#import "TPTuiSelectView.h"

@interface TPTuiViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation TPTuiViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navTitleLable.text = @"退烧攻略";
    
    [self addHeadView];
}

#pragma mark 增加按钮列表
-(void)addHeadView{
    
    TPTuiSelectView *tuiSelectView = [[TPTuiSelectView alloc]initWithFrame:CGRectMake(0,64,kScreenWidth, 30)];
    tuiSelectView.tuiBlock = ^(int num){
        NSLog(@"num = %d",num);
    };
    [self.view addSubview:tuiSelectView];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
