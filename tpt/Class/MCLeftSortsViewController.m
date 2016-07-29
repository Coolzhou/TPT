//
//  MCLeftSortsViewController.h
//  LeftSlide
//
//  Created by apple on 16/4/29.
//  Copyright © 2016年 machao. All rights reserved.
//

#import "MCLeftSortsViewController.h"
#import "MCLeftSliderManager.h"
#import "MCOtherViewController.h"
#import "TPLeftCell.h"

@interface MCLeftSortsViewController () <UITableViewDelegate,UITableViewDataSource>{
    NSArray *picArray;
    NSArray *titleArray;
}

@end

@implementation MCLeftSortsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    picArray = [NSArray arrayWithObjects:@"left_home",@"left_history",@"left_down",@"left_setup",@"left_signout",nil];
    titleArray = [NSArray arrayWithObjects:@"首页",@"历史记录",@"退烧攻略",@"系统设置",@"退出",nil];


    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    bgImageView.contentMode = UIViewContentModeScaleAspectFit;
    bgImageView.image = [UIImage imageNamed:@"left_view_bg"];
    [self.view addSubview:bgImageView];

    UITableView *tableview = [[UITableView alloc]init];
    tableview.backgroundColor = [UIColor orangeColor];
    self.tableview = tableview;
    [self.view addSubview:tableview];

    tableview.frame = CGRectMake(50, 0,kScreenWidth, kScreenHeight);
    tableview.tableFooterView = [[UIView alloc]init];
    tableview.sectionHeaderHeight = 0;
    tableview.sectionFooterHeight = 0;
    tableview.dataSource = self;
    tableview.delegate  = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
//    tableview.separatorColor = [UIColor whiteColor];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TPLeftCell *cell = [TPLeftCell theLeftCellWithTableView:tableView];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor clearColor];
    cell.titleLable.text = titleArray[indexPath.row];
    cell.imageView.image =[UIImage imageNamed:picArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MCOtherViewController *vc = [[MCOtherViewController alloc] init];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    vc.titleName = cell.textLabel.text;
    [[MCLeftSliderManager sharedInstance].LeftSlideVC closeLeftView];//关闭左侧抽屉
    [[MCLeftSliderManager sharedInstance].mainNavigationController pushViewController:vc animated:NO];

}


@end
