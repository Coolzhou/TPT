//
//  TPTHistoryVC.m
//  tpt
//
//  Created by apple on 16/8/12.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import "TPTHistoryVC.h"
#import "TPTHistoryCell.h"
#import "SNChart.h"
#import "TPTStateCacheTool.h"
@interface TPTHistoryVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)SNChart * chart;  //折线图

@property (nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation TPTHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleLable.text = @"历史记录";

    [self initData];
    [self initTableView];
//    [self initTableViewHeadView];
}

-(void)initData{
    NSArray *array = [TPTStateCacheTool getTemperature];
    self.dataArray = [array mutableCopy];
    
}


-(void)initTableViewHeadView{

//    self.chart = [[SNChart alloc] initWithFrame:CGRectMake(15,kScreenHeight-280, self.view.frame.size.width-30, 260) withDataSource:self andChatStyle:SNChartStyleLine];
//    [self.tableView.tableHeaderView = self.chart;
}

- (NSArray *)chatConfigYValue:(SNChart *)chart {
    return @[@"36",@"38"];
}

- (NSArray *)chatConfigXValue:(SNChart *)chart {
    return @[@"1",@"2",];
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
        NSLog(@"row = %ld",row);
    };
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPHONE_6 ||IS_IPHONE_6) {
        return 90;
    }else{
        return 70;
    }
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
