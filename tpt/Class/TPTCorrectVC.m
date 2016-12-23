//
//  TPTCorrectVC.m
//  tpt
//
//  Created by apple on 16/8/22.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import "TPTCorrectVC.h"
#import "TPTCorrectCell.h"
#import "TPTCorrectInfoCell.h"


@interface TPTCorrectVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *tableView;

@end

@implementation TPTCorrectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleLable.text = NSLocalizedString(@"setting_tem_check_title", @"");
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
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        TPTCorrectCell *cell = [TPTCorrectCell theTPTCorrectCellWithTableView:tableView];
        __weak typeof(self) weakself = self;
        cell.dissBlock =^{
            [weakself dissCurrentVC];
        };
        return cell;
    }else{
        TPTCorrectInfoCell *cell = [TPTCorrectInfoCell theTPTCorrectInfoCellWithTableView:tableView];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        return 225;
    }else{
        return [UITableViewCell whc_CellHeightForIndexPath:indexPath tableView:tableView];
    }
}


-(void)dissCurrentVC{
    [self.navigationController popViewControllerAnimated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
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
