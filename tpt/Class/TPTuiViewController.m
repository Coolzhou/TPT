//
//  TPTuiViewController.m
//  tpt
//
//  Created by Yi luqi on 16/7/31.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import "TPTuiViewController.h"
#import "TPTuiSelectView.h"
#import "TPTuiCell.h"
#import "IGDisplayer.h"

@interface TPTuiViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,assign)NSInteger typeNum;

@end

@implementation TPTuiViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navTitleLable.text = NSLocalizedString(@"setting_raiders", @"");
    self.typeNum = 1;
    self.dataArray = [[NSMutableArray alloc]init];
    [self initData];
    
    [self addHeadView];
    
    [self initTableView];
}

#pragma mark 增加按钮列表
-(void)addHeadView{
    
    TPTuiSelectView *tuiSelectView = [[TPTuiSelectView alloc]initWithFrame:CGRectMake(0,84,kScreenWidth, 45)];

    __weak typeof(self) weakSelf = self;
    tuiSelectView.tuiBlock = ^(int num){
        NSLog(@"num = %d",num);
        weakSelf.typeNum = num;
        [weakSelf.tableView reloadData];
    };
    [self.view addSubview:tuiSelectView];

}
#pragma mark 初始化数据
-(void)initData{
        NSString *paththree = [[NSBundle mainBundle]pathForResource:@"TPtui" ofType:@"plist"
                               ];
        self.dataArray = [[NSMutableArray alloc]initWithContentsOfFile:paththree];
}

-(void)initTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.sectionFooterHeight = 0.0001;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(140, 0, 0, 0));
    }];
}
#pragma mark UITableViewDataSource,UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = [self selectTypeNum];
    return array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TPTuiCell *cell = [TPTuiCell theTuiWithTableView:tableView andIndexPath:indexPath];
    NSArray *array = [self selectTypeNum];
    NSDictionary *dict =(NSDictionary *)array[indexPath.row];
    [cell theTuiWithTableViewWithIndexPath:indexPath andType:self.typeNum andDict:dict];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        NSString *content =[self heightRowFirst];

        CGSize size =[content sizeForMaxWidth:(kScreenWidth - 30) font:[UIFont systemFontOfSize:16]];
//        NSLog(@"size.height = %f",size.height);

        return size.height +40;

    }else{
        return 92;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self selectRowAtIndexPath:indexPath];
}

-(void)selectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *titileStr = @"";
    NSString *contentStr = @"";

    if (indexPath.row!=0) {
        if (self.typeNum ==1) {
            if (indexPath.row==0) {
                contentStr = NSLocalizedString(@"raiders_tab1_content_top",@"");
            }else if (indexPath.row==1){
                titileStr = NSLocalizedString(@"raiders_tab1_title_1",@"");
                contentStr = NSLocalizedString(@"raiders_tab1_content_1",@"");
            }else if (indexPath.row==2){
                titileStr = NSLocalizedString(@"raiders_tab1_title_2",@"");
                contentStr = NSLocalizedString(@"raiders_tab1_content_2",@"");
            }else if (indexPath.row==3){
                titileStr = NSLocalizedString(@"raiders_tab1_title_3",@"");
                contentStr = NSLocalizedString(@"raiders_tab1_content_3",@"");
            }else if (indexPath.row==4){
                titileStr = NSLocalizedString(@"raiders_tab1_title_4",@"");
                contentStr = NSLocalizedString(@"raiders_tab1_content_4",@"");
            }else{
                titileStr = NSLocalizedString(@"raiders_tab1_title_5",@"");
                contentStr = NSLocalizedString(@"raiders_tab1_content_5",@"");
            }
        }else if(self.typeNum==2){
            if (indexPath.row==0) {
                contentStr = NSLocalizedString(@"raiders_tab2_content_top",@"");
            }
        }else if (self.typeNum==3){
            if (indexPath.row==0) {
                contentStr = NSLocalizedString(@"raiders_tab3_content_top",@"");
            }else if (indexPath.row==1){
                titileStr = NSLocalizedString(@"raiders_tab1_title_1",@"");
                contentStr = NSLocalizedString(@"raiders_tab3_content_1",@"");
            }else{
                titileStr = NSLocalizedString(@"raiders_tab1_title_2",@"");
                contentStr = NSLocalizedString(@"raiders_tab3_content_2",@"");
            }
        }else{
            if (indexPath.row==0) {
                contentStr = NSLocalizedString(@"raiders_tab4_content_top",@"");
            }else if (indexPath.row==1){
                titileStr = NSLocalizedString(@"raiders_tab1_title_1",@"");
                contentStr = NSLocalizedString(@"raiders_tab4_content_1",@"");
            }else if (indexPath.row==2){
                titileStr = NSLocalizedString(@"raiders_tab1_title_2",@"");
                contentStr = NSLocalizedString(@"raiders_tab4_content_2",@"");
            }else if (indexPath.row==3){
                titileStr = NSLocalizedString(@"raiders_tab1_title_3",@"");
                contentStr = NSLocalizedString(@"raiders_tab4_content_3",@"");
            }else if (indexPath.row==4){
                titileStr = NSLocalizedString(@"raiders_tab1_title_4",@"");
                contentStr = NSLocalizedString(@"raiders_tab4_content_4",@"");
            }else{
                titileStr = NSLocalizedString(@"raiders_tab1_title_5",@"");
                contentStr = NSLocalizedString(@"raiders_tab4_content_5",@"");
            }
        }
        [IGDisplayer showDisplayerWithTitleText:titileStr contentText:contentStr];
    }
}

-(NSString *)heightRowFirst{

    NSString *contentStr = @"";
    if (self.typeNum ==1) {
        contentStr = NSLocalizedString(@"raiders_tab1_content_top",@"");
    }else if(self.typeNum==2){
        contentStr = NSLocalizedString(@"raiders_tab2_content_top",@"");
    }else if (self.typeNum==3){
        contentStr = NSLocalizedString(@"raiders_tab3_content_top",@"");
    }else{
        contentStr = NSLocalizedString(@"raiders_tab4_content_top",@"");
    }
    return contentStr;
}

-(NSArray *)selectTypeNum{
    NSArray *array;
    switch (self.typeNum) {
        case 1:{
            array = (NSArray *)self.dataArray[0];
        }
            break;
        case 2:{
            array = (NSArray *)self.dataArray[1];
        }
            break;
        case 3:{
            array = (NSArray *)self.dataArray[2];
        }
            break;
        case 4:
        {
            array = (NSArray *)self.dataArray[3];
        }
            break;
        default:
            array = [[NSArray alloc]init];;
            break;
    }
    return array;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
