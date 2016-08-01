//
//  XPQRotateDials.m
//  XPQRotateDials
//
//  Created by RHC on 15/7/24.
//  Copyright (c) 2015年 com.launch. All rights reserved.
//

#import "XPQRotateDials.h"

#define marge 15
#define dashW (kScreenWidth-2 *marge)

@interface XPQRotateDials () {
    CGFloat _radii;
    CGPoint _dialCenter;
    CGFloat _rulingWidth;
}

@property (nonatomic) CGFloat needleAngle;

@property (nonatomic, weak) UIImageView *needleView;
@property (nonatomic, weak) UILabel *valueLabel;
@property (nonatomic, weak) UIImageView *titleImageView;
@end

@implementation XPQRotateDials

-(instancetype)init {
    self = [super init];
    if (self) {
        [self configSelf];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configSelf];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configSelf];
    }
    return self;
}

- (void)configSelf {
    [self configParam];
}

-(void)configParam {
    // 初始值
    
    tachLayer = [CALayer layer];
    tachLayer.bounds = CGRectMake(marge, 0,dashW, dashW/2.126);
    tachLayer.position = CGPointMake(kScreenWidth/2, dashW/2.126/2);
    tachLayer.contents = (id)[UIImage imageNamed:@"main_dash"].CGImage;
    [self.layer addSublayer:tachLayer];
    
    // Create the layer for the pin
    pinLayer = [CALayer layer];
    pinLayer.bounds = CGRectMake(0, 0, dashW/5, dashW/2.5);
    pinLayer.contents = (id)[UIImage imageNamed:@"main_needle"].CGImage;
    pinLayer.position = CGPointMake(kScreenWidth/2, dashW/2.126);
    pinLayer.anchorPoint = CGPointMake(1.0, 1.0);
    // Rotate to the left 50 degrees so it lines up with the 0 position on the gauge
    pinLayer.transform = CATransform3DRotate(pinLayer.transform, DEGREES_TO_RADIANS(-50), 0, 0, 1);
    [tachLayer addSublayer:pinLayer];
    
}

- (void)go:(id)sender {
    
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:(DEGREES_TO_RADIANS(160))];
    rotationAnimation.duration = 1.0f;
    rotationAnimation.autoreverses = YES; // Very convenient CA feature for an animation like this
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [pinLayer addAnimation:rotationAnimation forKey:@"revItUpAnimation"];
}

-(UILabel *)valueLabel{
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,200, 50)];
    }
    return _valueLabel;
}

@end
