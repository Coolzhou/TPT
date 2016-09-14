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
#import "ATDatePicker.h"
@interface TPTHistoryVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)TPChart * chart;  //折线图

@property (nonatomic,strong)TPChartLine * chartLine;  //折线图

@property (nonatomic,strong)UIButton *timeButton; //时间But

@property (nonatomic,strong)NSMutableArray *dataArray;//状态数组

@property (nonatomic,strong)NSMutableArray *historyArray; //历史记录数组

@property (nonatomic,strong)NSDate *timeDate; //记录日期

@end

@implementation TPTHistoryVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleLable.text = NSLocalizedString(@"setting_history", @"");
    self.timeDate = [NSDate date];
    [self initData];
    [self initTableView];
    [self initTableViewHeadView];
}
-(void)initData{

//    NSArray *histroyArray = [WBCacheTool getTemperature];
//    if (histroyArray.count>1500) {
//        [WBCacheTool deleteAllTemp];
//    }
//    self.historyArray = [histroyArray mutableCopy];
//
//    NSArray *array = [TPTStateCacheTool getTemperature];
//
//    if ( array.count>500) {
//        [TPTStateCacheTool deleteAllTemp];
//    }
//    self.dataArray = [array mutableCopy];
////    NSLog(@"historyArray = %@  ==== dataArray = %@",self.historyArray,self.dataArray);



    NSArray *histroyArray = [WBCacheTool temperatureDateCounts:[TPTool dateTimeIntervalWithNIntTime:self.timeDate]];
    NSLog(@"history. = %@",histroyArray);



}

-(void)initTableViewHeadView{

    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,310)];
    headerView.backgroundColor = [UIColor clearColor];
    [headerView addSubview:self.timeButton];

    self.chart = [[TPChart alloc]initWithFrame:CGRectMake(0,40, SCREEN_WIDTH, 260) withDataSource:self.historyArray];
    [headerView addSubview:self.chart];
    self.tableView.tableHeaderView = headerView;
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

    [SVProgressHUD showSuccessWithStatus:@"删除成功"];
}

#pragma mark 刷新tableView
-(void)reloadTableViewData{
    NSLog(@"aaaaa");
    [self.tableView reloadData];
}

#pragma mark 点击日期
-(void)selectDateTime{

    __weak typeof(self) weakSelf = self;
    ATDatePicker *datePicker = [[ATDatePicker alloc] initWithDatePickerMode:UIDatePickerModeDate DateFormatter:@"yyyy-MM-dd" datePickerFinishBlock:^(NSDate *date) {
        if (![date isEqualToDate:weakSelf.timeDate]) {
            weakSelf.timeDate = date;
            [weakSelf.timeButton setTitle:[TPTool dateTimeForLocaleDate:date] forState:UIControlStateNormal];
            [weakSelf reloadTableViewData];
        }
    }];
    datePicker.maximumDate = [NSDate date];
    datePicker.date = self.timeDate;
    [datePicker show];
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

-(UIButton *)timeButton{
    if (!_timeButton) {
        _timeButton = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2,0,200, 30)];
        _timeButton.backgroundColor =[UIColor whiteColor];
        _timeButton.layer.cornerRadius = 5;
        _timeButton.layer.masksToBounds = YES;
        _timeButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_timeButton addTarget:self action:@selector(selectDateTime) forControlEvents:UIControlEventTouchUpInside];
        [_timeButton setTitleColor:MainContentColor forState:UIControlStateNormal];
        [_timeButton setTitle:[TPTool dateTimeForLocaleDate:[NSDate date]] forState:UIControlStateNormal];
    }
    return _timeButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
