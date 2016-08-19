//
//  TPChart.h
//  tpt
//
//  Created by apple on 16/8/15.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPChartLine.h"


@interface TPChart : UIView

@property (nonatomic,strong)NSMutableArray *valueArray;

@property (nonatomic,strong)NSMutableArray *timeArray;

/**
 *  @author sen, 15-12-24 17:12:50
 *
 *  line  是否曲线
 */
@property (nonatomic, assign) BOOL curve;

@property (nonatomic, strong) TPChartLine * chartLine;

@property (nonatomic, strong) UIScrollView * myScrollView;

- (instancetype)initWithFrame:(CGRect)frame withDataSource:(NSArray *)dataSource;

- (void)showInView:(UIView *)view;



@end
