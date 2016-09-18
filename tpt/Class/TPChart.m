//
//  TPChart.m
//  tpt
//
//  Created by apple on 16/8/15.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import "TPChart.h"
#import "TPChartLine.h"
#import "WBTemperature.h"

static const CGFloat kLineStartX = 50.f;
static const CGFloat kTopSpace = 30.f;//距离顶部y值

@interface TPChart ()

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) NSArray *dataArray; //所有数组

@property (nonatomic, strong) NSArray *currentArray; //当前数组

@property (nonatomic, assign) int currentNum; //当前位置

@property (nonatomic, assign) int allNum; //总位置

@property (nonatomic, assign) int nowNum; //现在位置

@property (nonatomic, assign) CGFloat lineH;

@end

@implementation TPChart

- (instancetype)initWithFrame:(CGRect)frame withDataSource:(NSArray *)dataSource{
    self = [super initWithFrame:frame];
    if (self) {

        self.allNum = 0;
        self.nowNum = 0;
        self.backgroundColor = [UIColor clearColor];
        self.curve = NO;
        self.dataArray = [dataSource copy];
        if (dataSource.count>=chartHistoryMaxNum) {
            self.currentArray = [dataSource subarrayWithRange:NSMakeRange(0, chartHistoryMaxNum)];
        }else{
            self.currentArray = dataSource;
        }
        self.lineH = (self.bounds.size.height - 2*kTopSpace)/chartHistoryMaxNum;

        [self addSubview:self.bgView];
        [self addYLabel:self.bgView];
        [self startDraw];
    }
    return self;
}


- (void)startDraw {

//    NSLog(@"self.dataArray = %@",self.dataArray);
    [self.bgView addSubview:self.myScrollView];

    for (int i=0; i<self.dataArray.count; i++) {
        WBTemperature *temps = self.dataArray[i];
        NSString *timeStr = [NSString stringWithFormat:@"%@",[TPTool stringDataWithTimeInterval:temps.create_time]];
        NSString *tempStr =  [NSString stringWithFormat:@"%f",temps.temp];
        [self.timeArray addObject:timeStr];
        [self.valueArray addObject:tempStr];
    }
    NSInteger  dataCount =  self.dataArray.count;
    if (dataCount<=chartMaxNum) {
        self.chartLine = [[TPChartLine alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-70, self.bounds.size.height) withDataArray:self.dataArray];
    }else{
        self.chartLine = [[TPChartLine alloc] initWithFrame:CGRectMake(0, 0, kLineStartX*dataCount+40, self.bounds.size.height) withDataArray:self.dataArray];
    }
    self.chartLine.curve = self.curve;
    [self.myScrollView addSubview:self.chartLine];

    if (self.timeArray.count>0) {
        NSMutableArray * yArray = self.valueArray;
        NSArray * xArray = self.timeArray;
        [self.chartLine setXValues:xArray];
        [self.chartLine setYValues:yArray];
    }
    [self.chartLine startDrawLines];
}


//标记y轴label
- (void)addYLabel:(UIView *)bgView {

    CGFloat maxNum = 42.0;

    for (NSInteger i = 0; i <= chartHistoryMaxNum; i++) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.lineH * i + kTopSpace-5, 30, 10)];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:10.f];
        label.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:label];

       CGFloat tempNum = [TPTool getUnitCurrentTempFloat:(maxNum-i)];
       label.text = [NSString stringWithFormat:@"%.0f",tempNum];
    }
}

- (void)showInView:(UIView *)view {
    [self startDraw];
    [view addSubview:self];
}

-(void)refreshCurrentChart:(NSMutableArray *)dataArray{
    self.dataArray = [dataArray copy];

    if (self.dataArray.count<=chartMaxNum) {
        _myScrollView.contentSize = CGSizeMake(kScreenWidth-70,self.bounds.size.height);
    }else{
        _myScrollView.contentSize = CGSizeMake(kLineStartX*self.dataArray.count+40,self.bounds.size.height);
    }
    CGFloat wightScroll = _myScrollView.contentSize.width - _myScrollView.bounds.size.width;

    [_myScrollView  setContentOffset:CGPointMake(wightScroll, 0) animated:NO];

//    NSLog(@"self.dataARRAY = %ld",dataArray.count);
    [self.chartLine removeFromSuperview];
    [self.myScrollView removeFromSuperview];
    [self startDraw];
}

- (UIScrollView *)myScrollView {
    if (!_myScrollView) {
        _myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(30, 0, kScreenWidth-30-40,self.bounds.size.height)];
        if (self.dataArray.count<=chartMaxNum) {
            _myScrollView.contentSize = CGSizeMake(kScreenWidth-70,self.bounds.size.height);
        }else{
            _myScrollView.contentSize = CGSizeMake(kLineStartX*self.dataArray.count+40,self.bounds.size.height);
        }
        CGFloat wightScroll = _myScrollView.contentSize.width - _myScrollView.bounds.size.width;
        [_myScrollView  setContentOffset:CGPointMake(wightScroll, 0) animated:NO];
        _myScrollView.bounces = NO;
    }
    return _myScrollView;
}


-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, kScreenWidth - 30,self.bounds.size.height)];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 8;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

-(NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSArray alloc]init];
    }
    return _dataArray;
}

-(NSMutableArray *)timeArray{
    if (!_timeArray) {
        _timeArray = [[NSMutableArray alloc]init];
    }
    return _timeArray;
}

-(NSMutableArray *)valueArray{
    if (!_valueArray) {
        _valueArray = [[NSMutableArray alloc]init];
    }
    return _valueArray;
}

-(NSArray*)currentArray{
    if (!_currentArray) {
        _currentArray = [[NSArray alloc]init];
    }
    return _currentArray;
}

@end
