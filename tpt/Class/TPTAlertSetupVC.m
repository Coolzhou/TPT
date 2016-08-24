//
//  TPTAlertSetupVC.m
//  tpt
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import "TPTAlertSetupVC.h"
#import "alertSetOneCell.h"
#import "alertSetTwoCell.h"
#import "alertSetThreeCell.h"
#import "alertSetFreeCell.h"

#import "CustomAlertView.h"
@interface TPTAlertSetupVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *tableView;

@end

@implementation TPTAlertSetupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleLable.text = NSLocalizedString(@"max_tem", @"");
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
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section==0) {
        alertSetOneCell *cell = [alertSetOneCell thealertSetOneCellWithTableView:tableView andIndexPath:indexPath];
        return cell;
    }else if (indexPath.section ==1){
        alertSetTwoCell *cell = [alertSetTwoCell thealertSetTwoCellWithTableView:tableView andIndexPath:indexPath];
        return cell;
    }else if(indexPath.section ==2){
        alertSetThreeCell *cell = [alertSetThreeCell thealertSetThreeCellWithTableView:tableView andIndexPath:indexPath];
        return cell;
    }else{
        alertSetFreeCell *cell = [alertSetFreeCell thealertSetFreeCellWithTableView:tableView andIndexPath:indexPath];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {

        NSString *content = NSLocalizedString(@"max_tem_explanation",@"");
        CGSize size =[content sizeForMaxWidth:(kScreenWidth - 50) font:[UIFont systemFontOfSize:15]];
        NSLog(@"size.height = %f",size.height);
        
        return size.height+20;
    }else if(indexPath.section==1){
        return 44;
    }else if(indexPath.section ==2){
        return 200;
    }else{
        return 133;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 30;
    }else{
        return 20;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
