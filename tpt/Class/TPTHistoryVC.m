//
//  TPTHistoryVC.m
//  tpt
//
//  Created by apple on 16/8/12.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import "TPTHistoryVC.h"
#import "TPTHistoryCell.h"
#import "WBTemperature.h"
#import "TPTStateCacheTool.h"
#import "TPChartLine.h"
#import "TPChart.h"
#import "WBCacheTool.h"
@interface TPTHistoryVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)TPChart * chart;  //折线图

@property (nonatomic,strong)TPChartLine * chartLine;  //折线图

@property (nonatomic,strong)NSMutableArray *dataArray;//状态数组

@property (nonatomic,strong)NSMutableArray *historyArray; //历史记录数组

@end

@implementation TPTHistoryVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    NSArray *histroyArray = [WBCacheTool getTemperature];
    if (histroyArray.count>1500) {
        [WBCacheTool deleteAllTemp];
    }
    self.historyArray = [histroyArray mutableCopy];


    NSArray *array = [TPTStateCacheTool getTemperature];

    if ( array.count>500) {
        [TPTStateCacheTool deleteAllTemp];
    }
    self.dataArray = [array mutableCopy];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleLable.text = NSLocalizedString(@"setting_history", @"");

    [self initData];
    [self initTableView];
    [self initTableViewHeadView];
}
-(void)initData{


}

-(void)initTableViewHeadView{

    self.chart = [[TPChart alloc]initWithFrame:CGRectMake(15,kScreenHeight-280, self.view.frame.size.width-30, 260) withDataSource:self.historyArray];
    self.tableView.tableHeaderView = self.chart;
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
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(84, 0, 0, 0));
    }];
}
#pragma mark UITableViewDataSource,UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakself = self;
    TPTHistoryCell *cell = [TPTHistoryCell theTPTHistoryCellWithTableView:tableView andIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.tempModel = self.dataArray[indexPath.row];
    cell.delectHistBlock = ^(NSInteger row){
        [weakself removeDataArrayCell:row];
    };
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

-(void)removeDataArrayCell:(NSInteger)row{

    WBTemperature *tempModel = self.dataArray[row];
    [TPTStateCacheTool deleteTemp:tempModel.create_time];

    [self.dataArray removeObjectAtIndex:row];
    NSArray *_tempIndexPathArr = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:0]];
    [self.tableView deleteRowsAtIndexPaths:_tempIndexPathArr withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView reloadData];

    [SVProgressHUD showWithStatus:@"删除成功"];

//    [[[iToast makeText:@"删除成功"]setGravity:iToastGravityCenter] show];

}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

-(NSMutableArray *)historyArray{
    if (!_historyArray) {
        _historyArray = [[NSMutableArray alloc]init];
    }
    return _historyArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
