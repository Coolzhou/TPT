//
//  MCLeftSortsViewController.h
//  LeftSlide
//
//  Created by apple on 16/4/29.
//  Copyright © 2016年 machao. All rights reserved.
//

#import "MCLeftSortsViewController.h"
#import "MCLeftSliderManager.h"
#import "TPTHistoryVC.h"
#import "TPTuiViewController.h"
#import "TPTSetUpVC.h"

#import "TPLeftCell.h"

@interface MCLeftSortsViewController () <UITableViewDelegate,UITableViewDataSource>{
    NSArray *picArray;
    NSArray *titleArray;
}

@end

@implementation MCLeftSortsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    picArray = [NSArray arrayWithObjects:@"left_home",@"left_history",@"left_down",@"left_setup",nil];
    titleArray = [NSArray arrayWithObjects:NSLocalizedString(@"setting_main",@""),NSLocalizedString(@"setting_history",@""),NSLocalizedString(@"setting_raiders", @""),NSLocalizedString(@"setting_", @""),nil];


    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    bgImageView.contentMode = UIViewContentModeScaleAspectFit;
    bgImageView.image = [UIImage imageNamed:@"left_view_bg"];
    [self.view addSubview:bgImageView];

    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(kMainPageDistance/2, (kScreenHeight - 300)/3, kScreenWidth - kMainPageDistance, 300) style:UITableViewStylePlain];
//    self.tableview = tableview;
    tableview.backgroundColor = [UIColor clearColor];


//    tableview.tableFooterView = [[UIView alloc]init];
//    tableview.sectionHeaderHeight = 0;
//    tableview.sectionFooterHeight = 0;
    tableview.dataSource = self;
    tableview.delegate  = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:tableview];
//    tableview.separatorColor = [UIColor whiteColor];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TPLeftCell *cell = [TPLeftCell theLeftCellWithTableView:tableView];
    cell.titlesLable.text = titleArray[indexPath.row];
    cell.leftImgView.image =[UIImage imageNamed:picArray[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *pushvc =nil;
    switch (indexPath.row) {
        case 0:{
            [[MCLeftSliderManager sharedInstance].LeftSlideVC closeLeftView];//关闭左侧抽屉
        }
            break;
        case 1:{
            pushvc = [[TPTHistoryVC alloc] init];

            [[MCLeftSliderManager sharedInstance].LeftSlideVC closeLeftView];//关闭左侧抽屉
            [[MCLeftSliderManager sharedInstance].mainNavigationController pushViewController:pushvc animated:NO];
        }
            break;
        case 2:{
            pushvc = [[TPTuiViewController alloc] init];
            [[MCLeftSliderManager sharedInstance].LeftSlideVC closeLeftView];//关闭左侧抽屉
            [[MCLeftSliderManager sharedInstance].mainNavigationController pushViewController:pushvc animated:NO];
        }
            break;
        case 3:{
            pushvc = [[TPTSetUpVC alloc] init];
            [[MCLeftSliderManager sharedInstance].LeftSlideVC closeLeftView];//关闭左侧抽屉
            [[MCLeftSliderManager sharedInstance].mainNavigationController pushViewController:pushvc animated:NO];
        }
            break;
            
        default:{
//            pushvc = [[MCOtherViewController alloc] init];
            [[MCLeftSliderManager sharedInstance].LeftSlideVC closeLeftView];//关闭左侧抽屉
//            [[MCLeftSliderManager sharedInstance].mainNavigationController pushViewController:pushvc animated:NO];
        }
            break;
    }


}


@end
