//
//  TPTSetUpVC.m
//  tpt
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import "TPTSetUpVC.h"
#import "TPTAlertSetupVC.h"
#import "TPTDutyVC.h"
#import "TPTDeviceInfoVC.h"

#import "TPTCorrectVC.h"
#import "TPTSetupCell.h"
#import "TPTSetEleCell.h"
#import "TPTSetOtherCell.h"

@interface TPTSetUpVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *tableView;

@end

@implementation TPTSetUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navTitleLable.text = NSLocalizedString(@"setting_",@"");
    [self initTableView];
}

-(void)initTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.sectionFooterHeight = 0.0001;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
}
#pragma mark UITableViewDataSource,UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

//    static NSString *ID = @"cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
//    }
//    return cell;

    __weak typeof(self) weakself = self;
    if (indexPath.section==0) {
        TPTSetupCell *cell = [TPTSetupCell theTPTSetupCellWithTableView:tableView andIndexPath:indexPath];
        cell.setUpBlock = ^(NSInteger tag){
            [weakself clickSectionOneTableViewCell:tag];
        };
        return cell;
    }else if (indexPath.section ==1){
        TPTSetEleCell *cell = [TPTSetEleCell theTPTSetEleCellWithTableView:tableView andIndexPath:indexPath];
        return cell;
    }else{
        TPTSetOtherCell *cell = [TPTSetOtherCell theTPTSetOtherCellWithTableView:tableView andIndexPath:indexPath];
        cell.setOtherBlock = ^(NSInteger tag){
            [weakself clickSectionThreeTableViewCell:tag];
        };
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 308;
    }else if(indexPath.section==1){
        return 67;
    }else{
        return 162;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 30;
    }else if(section==1){
        return 40;
    }else{
        return 40;
    }
}

#pragma mark 点击了第一行cell
-(void)clickSectionOneTableViewCell:(NSInteger)row{
    if (row==1) {
        TPTAlertSetupVC * alertVC = [[TPTAlertSetupVC alloc]init];
        [self.navigationController pushViewController:alertVC animated:YES];
    }else{
        TPTCorrectVC * alertVC = [[TPTCorrectVC alloc]init];
        [self.navigationController pushViewController:alertVC animated:YES];
    }
}

#pragma mark 点击了第三行cell
-(void)clickSectionThreeTableViewCell:(NSInteger)row{
    if (row==1) {
        TPTDeviceInfoVC *info = [[TPTDeviceInfoVC alloc]init];
        [self.navigationController pushViewController:info animated:YES];
    }else{
        TPTDutyVC * alertVC = [[TPTDutyVC alloc]init];
        [self.navigationController pushViewController:alertVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
