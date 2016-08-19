//
//  WChart.m
//  WChartView
//
//  Created by wangsen on 15/12/24.
//  Copyright © 2015年 wangsen. All rights reserved.
//

#import "SNChart.h"
#import "SNChartLine.h"
#import "SNChartBar.h"
@interface SNChart ()
@property (nonatomic, strong) UIScrollView * myScrollView;
@property (nonatomic, strong) SNChartLine * chartLine;
@property (nonatomic, strong) SNChartBar * chartBar;
@property (nonatomic, weak) id<SNChartDataSource>dataSource;
@property (nonatomic, assign) SNChartStyle chartStyle;
@end
@implementation SNChart

- (instancetype)initWithFrame:(CGRect)frame withDataSource:(id<SNChartDataSource>)dataSource andChatStyle:(SNChartStyle)chartStyle {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.dataSource = dataSource;
        self.chartStyle = chartStyle;
        self.curve = NO;
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
    }
    return self;
}


- (void)startDraw {
    
    if (_chartStyle == SNChartStyleLine) {

        self.myScrollView.frame = self.bounds;
        self.chartLine = [[SNChartLine alloc] initWithFrame:self.bounds];
        self.chartLine.curve = self.curve;
        [self.myScrollView addSubview:self.chartLine];

        if (self.timeArray.count>0) {

            NSMutableArray * yArray = self.valueArray;
            NSArray * xArray = self.timeArray;
            NSInteger count = xArray.count - yArray.count;
            if (count > 0) {

                for (NSInteger i = 0; i < count; i++) {
                    [yArray addObject:@(0).stringValue];

                }
            }

//            NSArray * sourtArray = [yArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//
//                return [obj2 floatValue] > [obj1 floatValue];
//            }];


            NSArray *sortedArray = [yArray sortedArrayUsingComparator:^(NSNumber *number1,NSNumber *number2) {
                int val1 = [number1 intValue];
                int val2 = [number2 intValue];
                if (val1 > val2) {
                    return NSOrderedAscending;
                } else {
                    return NSOrderedDescending;
                }
            }];

            NSLog(@"%@", sortedArray);

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
        
        self.myScrollView.contentSize = CGSizeMake(self.bounds.size.width, 0);

    } else {
        
        self.myScrollView.frame = self.bounds;
        self.chartBar = [[SNChartBar alloc] initWithFrame:self.bounds];
        [self.myScrollView addSubview:self.chartBar];
        
        NSMutableArray * yArray = [NSMutableArray arrayWithArray:[self.dataSource chatConfigYValue:self]];
        NSArray * xArray = [self.dataSource chatConfigXValue:self];
        NSInteger count = xArray.count - yArray.count;
        if (count > 0) {
            
            for (NSInteger i = 0; i < count; i++) {
                [yArray addObject:@(0).stringValue];
                
            }
        }
        
        NSArray * sourtArray = [yArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            
            return [obj2 floatValue] > [obj1 floatValue];
        }];
        
        self.chartBar.yMax = [sourtArray.firstObject floatValue];
        [self.chartBar setXValues:xArray];
        [self.chartBar setYValues:yArray];
        
        [self.chartBar startDrawBars];
        
        self.myScrollView.contentSize = CGSizeMake(chartBarTheXAxisSpan * (xArray.count +1) + chartBarStartX, 0);
        CGRect frame = self.chartBar.frame;
        frame.size.width = chartBarStartX + xArray.count * chartBarTheXAxisSpan;
        self.chartBar.frame = frame;

    }
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


-(void)setValueArray:(NSMutableArray *)valueArray{
    _valueArray = valueArray;
    NSLog(@"value = %@",valueArray);
}

-(void)setTimeArray:(NSMutableArray *)timeArray{
    _timeArray = timeArray;

    NSLog(@"time = %@",timeArray);

    [self.chartLine removeFromSuperview];
    [self startDraw];
}
@end
