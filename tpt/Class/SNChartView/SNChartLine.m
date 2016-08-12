//
//  WChartLine.m
//  WChartView
//
//  Created by wangsen on 15/12/13.
//  Copyright © 2015年 wangsen. All rights reserved.
//

#import "SNChartLine.h"
#import "UIBezierPath+curved.h"
#define kBtnTag 100
#define kLableMin 35
#define kLineColor RGB(138, 234, 193)
#define kCirCleColor [UIColor orangeColor]
#define kHVLineColor RGB(236, 237, 238)
#define kBulldesFont [UIFont systemFontOfSize:10]

static const CGFloat kTopSpace = 30.f;//距离顶部y值


@interface SNChartLine ()
@property (nonatomic, strong) CAShapeLayer * shapeLayer;
@property (nonatomic, strong) NSMutableArray * pointXArray;
@property (nonatomic, strong) NSMutableArray * pointYArray;
@property (nonatomic, strong) NSMutableArray * points;

@property (nonatomic, strong) UIImageView * bulldesImageView;
@property (nonatomic, strong) UILabel * bulldesLabel;

@property (nonatomic, assign) CGFloat lineH;

@end
@implementation SNChartLine

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor redColor];
        self.curve = NO;
        self.lineH = 0;
        chartLineTheXAxisSpan = (self.bounds.size.width-2*chartLineStartX)/(chartMaxNum-1);
        [self drawHorizontal];
        [self drawVertical];
    }
    return self;
}

- (NSMutableArray *)pointYArray {
    if (!_pointYArray) {
        _pointYArray = [NSMutableArray array];
    }
    return _pointYArray;
}

- (NSMutableArray *)points {
    if (!_points) {
        _points = [NSMutableArray array];
    }
    return _points;
}

- (NSMutableArray *)pointXArray {
    if (!_pointXArray) {
        _pointXArray = [NSMutableArray array];
    }
    return _pointXArray;
}

- (void)setYMax:(CGFloat)yMax {
    _yMax = yMax;
}

- (void)setCurve:(BOOL)curve {
    _curve = curve;
}

- (void)setYValues:(NSArray *)yValues {
    _yValues = yValues;
//    [self drawHorizontal];
}

- (void)setXValues:(NSArray *)xValues {
    _xValues = xValues;
//    [self drawVertical];
}
//画横线
- (void)drawHorizontal {
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];

    self.lineH = (self.bounds.size.height - 2*kTopSpace)/chartMaxNum;
    
    for (NSInteger i = 0; i <= chartMaxNum; i++) {
        
        [path moveToPoint:CGPointMake(chartLineStartX, self.lineH * i + kTopSpace)];
        [path addLineToPoint:CGPointMake(chartLineStartX + (chartMaxNum - 1) * chartLineTheXAxisSpan, self.lineH * i + kTopSpace)];
        [path closePath];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = kHVLineColor.CGColor;
        shapeLayer.fillColor = kHVLineColor.CGColor;
        shapeLayer.lineWidth = 0.4f;
        [self.layer addSublayer:shapeLayer];
    }
}
//画竖线
- (void)drawVertical {

    UIBezierPath * path = [UIBezierPath bezierPath];
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    
    for (NSInteger i = 0; i < chartMaxNum; i++) {
        
        [path moveToPoint:CGPointMake(chartLineStartX+ chartLineTheXAxisSpan*i,kTopSpace)];
        [path addLineToPoint:CGPointMake(chartLineStartX + chartLineTheXAxisSpan * i,self.bounds.size.height-kTopSpace)];
        [path closePath];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = kHVLineColor.CGColor;
        shapeLayer.fillColor = kHVLineColor.CGColor;
        shapeLayer.lineWidth = 0.4f;
        [self.layer addSublayer:shapeLayer];
    }
}

- (void)startDrawLines {
    //设置x轴
    for (NSInteger i = 0; i < _xValues.count; i++) {
        [self.pointXArray addObject:@(chartLineStartX + chartLineTheXAxisSpan * i)];
    }
    //设置y轴
    for (NSInteger i = 0; i < _xValues.count; i++) {

//        NSLog(@"aaa = %f",chartLineTheYAxisSpan * kYEqualPaths - [_yValues[i] floatValue]/_yMax * chartLineTheYAxisSpan * kYEqualPaths + kTopSpace);
//
//        NSLog(@"50 * 7  - 30 + = %f",(self.lineH * kYEqualPaths-[_yValues[i] floatValue]-kLableMin)/(_yMax-kLableMin) * self.lineH *kYEqualPaths);


    [self.pointYArray addObject:@(self.lineH * chartMaxNum-([_yValues[i] floatValue]-kLableMin)/(_yMax-kLableMin) * self.lineH *chartMaxNum+kTopSpace)];

//        [self.pointYArray addObject:@(chartLineTheYAxisSpan * kYEqualPaths - [_yValues[i] floatValue]/_yMax * chartLineTheYAxisSpan * kYEqualPaths + kTopSpace)];
    }
    
    for (NSInteger i = 0; i < self.pointXArray.count; i++) {
        CGPoint point = CGPointMake([self.pointXArray[i] floatValue], [self.pointYArray[i] floatValue]);
//        NSValue * value = [NSValue valueWithBytes:&point objCType:@encode(CGPoint)];
        NSValue * value = [NSValue valueWithCGPoint:point];
        [self.points addObject:value];
    }
    //画线
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.lineCap = kCALineCapRound;
    _shapeLayer.lineJoin = kCALineJoinRound;
    _shapeLayer.lineWidth = 2.f;
    _shapeLayer.fillColor = [UIColor clearColor].CGColor;
    _shapeLayer.strokeEnd = 0.f;
    _shapeLayer.strokeColor = kLineColor.CGColor;
    [self.layer addSublayer:_shapeLayer];

    UIBezierPath * bezierLine = [UIBezierPath bezierPath];
    for (NSInteger i = 0; i < self.points.count; i++) {
        CGPoint point = [self.points[i] CGPointValue];
        if (i == 0) {
            [bezierLine moveToPoint:point];
        } else {
            [bezierLine addLineToPoint:point];
        }
        [self addCircle:point andIndex:i];
        [self addXLabel:point andIndex:i];
    }
    
    [self addYLabel];
    
    if (self.curve) {
        bezierLine =[bezierLine smoothedPathWithGranularity:20];//设置曲线
    }
    _shapeLayer.path = bezierLine.CGPath;
    
//    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    pathAnimation.duration = self.points.count * 0.5f;
//    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
//    pathAnimation.toValue = [NSNumber numberWithFloat:1.f];
//    pathAnimation.autoreverses = NO;
//    [_shapeLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    _shapeLayer.strokeEnd = 1.f;
}

//圆圈
- (void)addCircle:(CGPoint)point andIndex:(NSInteger)index {
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,8, 8)];
    view.center = point;
    view.backgroundColor = RGB(253, 221, 12);
    view.layer.cornerRadius = 4.f;
    view.layer.masksToBounds = YES;
    [self addSubview:view];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 12, 12);
    btn.center = point;
    [self addSubview:btn];
    btn.tag = index + kBtnTag;
    btn.backgroundColor = [UIColor clearColor];
    btn.layer.borderWidth = 3.f;
    btn.layer.borderColor = RGB(142, 221, 234).CGColor;
    btn.layer.cornerRadius = 6.0f;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(circleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

//标记x轴label
- (void)addXLabel:(CGPoint)point andIndex:(NSInteger)index {
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, chartLineTheXAxisSpan, 20)];
    label.center = CGPointMake(point.x, self.lineH * chartMaxNum + kTopSpace+15);
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:10.f];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = _xValues[index];
    [self addSubview:label];
}

//标记y轴label
- (void)addYLabel {
    for (NSInteger i = 0; i <= chartMaxNum; i++) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.lineH * i + kTopSpace-5, chartLineStartX - 5, 10)];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:10.f];
        label.textAlignment = NSTextAlignmentRight;
        [self addSubview:label];
        if (i == chartMaxNum) {
            label.text = [NSString stringWithFormat:@""];
        } else {
            label.text = [NSString stringWithFormat:@"%.0f",_yMax - i];
        }
    }
}
//圆圈点击事件
- (void)circleButtonClick:(UIButton *)btn {
    CGFloat x = btn.frame.origin.x;
    CGFloat y = btn.frame.origin.y;
    NSString * content = _yValues[btn.tag - kBtnTag] ;
    CGSize size = [content sizeWithAttributes:@{NSFontAttributeName:kBulldesFont}];
    if (size.width < 25.f) {
        size.width = 25.f;
    }
    [self addBulldesView];
    _bulldesImageView.frame = CGRectMake(x, y - 20.f, size.width, 20);
    _bulldesLabel.frame = CGRectMake(0, 1, _bulldesImageView.frame.size.width, 10);
    _bulldesLabel.text = content;
}

- (void)addBulldesView {
    
    if (!_bulldesImageView) {
        _bulldesImageView = [[UIImageView alloc] init];
        [self addSubview:_bulldesImageView];
        UIImage * image = [UIImage imageNamed:@"气泡"];
        UIImage * resizableImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 5, 0) resizingMode:UIImageResizingModeStretch];
        _bulldesImageView.image = resizableImage;
    }
    if (!_bulldesLabel) {
        _bulldesLabel = [[UILabel alloc] init];
        _bulldesLabel.textColor = [UIColor whiteColor];
        _bulldesLabel.font = kBulldesFont;
        _bulldesLabel.textAlignment = NSTextAlignmentCenter;
        [_bulldesImageView addSubview:_bulldesLabel];
    }

}

@end
