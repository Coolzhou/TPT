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
@interface TPChart ()

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) NSArray *dataArray; //所有数组

@property (nonatomic, strong) NSArray *currentArray; //当前数组

@property (nonatomic, assign) int currentNum; //当前位置

@property (nonatomic, assign) int allNum; //总位置

@property (nonatomic, assign) int nowNum; //现在位置

@end

@implementation TPChart

- (instancetype)initWithFrame:(CGRect)frame withDataSource:(NSArray *)dataSource{
    self = [super initWithFrame:frame];
    if (self) {
        self.allNum = 0;
        self.nowNum = 0;
        self.backgroundColor = [UIColor clearColor];
        self.curve = NO;
        self.dataArray = dataSource;
        if (dataSource.count>=chartMaxNum) {
            self.currentArray = [dataSource subarrayWithRange:NSMakeRange(0, chartMaxNum)];
        }else{
            self.currentArray = dataSource;
        }
        [self startDraw];
    }
    return self;
}

- (void)startDraw {

    for (int i=0; i<self.currentArray.count; i++) {
        WBTemperature *temps = self.currentArray[i];
        NSString *timeStr = temps.create_time;
        NSString *tempStr =  [NSString stringWithFormat:@"%f",temps.temp];
        [self.timeArray addObject:timeStr];
        [self.valueArray addObject:tempStr];
    }
//    self.myScrollView.frame = self.bounds;

    self.chartLine = [[TPChartLine alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth-30, self.bounds.size.height)];
    self.chartLine.curve = self.curve;
    [self addSubview:self.chartLine];


    if (self.timeArray.count>0) {

        NSMutableArray * yArray = self.valueArray;
        NSArray * xArray = self.timeArray;
        NSInteger count = xArray.count - yArray.count;
        if (count > 0) {

            for (NSInteger i = 0; i < count; i++) {
                [yArray addObject:@(0).stringValue];
            }
        }
        NSArray *sortedArray = [yArray sortedArrayUsingComparator:^(NSNumber *number1,NSNumber *number2) {
            int val1 = [number1 intValue];
            int val2 = [number2 intValue];
            if (val1 > val2) {
                return NSOrderedAscending;
            } else {
                return NSOrderedDescending;
            }
        }];

//        NSLog(@"%@", sortedArray);

        if (yArray.count>1) {
            self.chartLine.yMin = [sortedArray.lastObject floatValue];
            self.chartLine.yMax = [sortedArray.firstObject floatValue];
        }else{
            self.chartLine.yMin = [sortedArray.lastObject floatValue]-3;
            self.chartLine.yMax = [sortedArray.firstObject floatValue]+3;
        }
        [self.chartLine setXValues:xArray];
        [self.chartLine setYValues:yArray];
    }
    [self.chartLine startDrawLines];


    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePans:)];

    [self addGestureRecognizer:self.panGestureRecognizer];
}

#pragma mark 左右滑
- (void)handlePans:(UIPanGestureRecognizer *)sender
{
    self.currentNum = 0;
    self.nowNum = 0;
    CGPoint translation = [sender translationInView:self];
    NSLog(@"11x == %f ,y==%f",translation.x,translation.y);

    int  senderNum =(int)translation.x/15.0;
    if ((senderNum !=self.currentNum)) {

        self.nowNum = senderNum;
        self.currentNum = senderNum;

        NSLog(@"allNum = %d,senderNum = %d,currentNum = %d",self.allNum,senderNum,self.currentNum);

        if ((self.nowNum + self.allNum)>=0 && self.allNum<(self.dataArray.count - chartMaxNum)) {
            self.currentArray = [self.dataArray subarrayWithRange:NSMakeRange(self.nowNum + self.allNum, chartMaxNum)];
        }else{
            self.allNum = 0;
        }
        
        [self.timeArray removeAllObjects];
        [self.valueArray removeAllObjects];
        [self.chartLine removeFromSuperview];
        self.chartLine = nil;
        [self startDraw];
    }

    if (sender.state == UIGestureRecognizerStateEnded) {

        int allValue = self.allNum + self.nowNum;
        if (allValue>=0 && allValue<(self.dataArray.count - chartMaxNum)) {
            self.allNum = allValue;
        }else{
            self.allNum = 0;
        }
        NSLog(@"asdad = %d,,senderNum = %d",self.allNum,senderNum);
    }
    NSLog(@"---------------");
}

- (void)showInView:(UIView *)view {
    [self startDraw];
    [view addSubview:self];
}

- (UIScrollView *)myScrollView {
    if (!_myScrollView) {
        _myScrollView = [[UIScrollView alloc] init];
        [self addSubview:_myScrollView];
    }
    return _myScrollView;
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
