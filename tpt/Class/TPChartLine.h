//
//  TPChartLine.h
//  tpt
//
//  Created by apple on 16/8/15.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import <UIKit/UIKit.h>


static const CGFloat LineStartX = 40.f;

@interface TPChartLine : UIView{
    CGFloat chartLineTheXAxisSpan;
}



@property (nonatomic, strong) NSArray * xValues;
@property (nonatomic, strong) NSArray * yValues;

@property (nonatomic, assign) CGFloat yMax;

@property (nonatomic, assign) CGFloat yMin;

@property (nonatomic, assign) BOOL curve;//是否曲线

- (instancetype)initWithFrame:(CGRect)frame withDataArray:(NSArray *)dataSource;

/**
 *  @author sen, 15-12-24 10:12:59
 *
 *  开始绘制图表
 */
- (void)startDrawLines;

@end
