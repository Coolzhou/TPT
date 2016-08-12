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
    CGSize _size;
}

@property (nonatomic) CGFloat needleAngle;

@property (nonatomic, strong) UIImageView *needleView;

@property (nonatomic, strong) UIImageView *titleImageView;

@property (nonatomic, strong) UILabel *valueLabel;

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

    _size = self.bounds.size;
    [self configParam];
}

-(void)configParam {
    // 初始值

//    self.backgroundColor =[UIColor orangeColor];

    tachLayer = [CALayer layer];
    tachLayer.bounds = CGRectMake(marge, 0,dashW, dashW/2.126);
    tachLayer.position = CGPointMake(kScreenWidth/2, dashW/2.126/2);
    tachLayer.contents = (id)[UIImage imageNamed:@"main_dash"].CGImage;
    [self.layer addSublayer:tachLayer];
    
    // Create the layer for the pin


    self.needleView =[[UIImageView alloc]init];
    self.needleView.frame = CGRectMake((kScreenWidth/2-dashW/10),dashW/4, dashW/5, dashW/2.5);

//    self.needleView.frame = CGRectMake(0,dashW/2, dashW/2, dashW/2.5);
    self.needleView.image = [UIImage imageNamed:@"main_needle"];
//    self.needleView.center = CGPointMake(dashW/2, dashW/2.126/2);
    self.needleView.layer.anchorPoint = CGPointMake(1, 1.0);

    self.needleView.transform = CGAffineTransformMakeRotation(M_PI_2 * -0.5);

//    self.needleView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.needleView];

    [self needletransform];

//    pinLayer = [CALayer layer];
//    pinLayer.bounds = CGRectMake(0, 0, dashW/5, dashW/2.5);
//    pinLayer.contents = (id)[UIImage imageNamed:@"main_needle"].CGImage;
//    pinLayer.position = CGPointMake(kScreenWidth/2, dashW/2.126);
//    pinLayer.anchorPoint = CGPointMake(1.0, 1.0);
////    pinLayer.transform = CATransform3DRotate(pinLayer.transform, DEGREES_TO_RADIANS(-50), 0, 0, 1);
//    [tachLayer addSublayer:pinLayer];

}

-(void)setValue:(NSString *)value{
    _value = value;

    if (value.floatValue>=37.5 && value.floatValue<38) {
        //低热
    }else if (value.floatValue>=38 && value.floatValue<39){
        //中度热
    }else if (value.floatValue>=39){
        //高热
    }else{
        //正常体温
    }

}

-(void)needletransform{

    [UIView animateWithDuration:2 animations:^{
        self.needleView.transform = CGAffineTransformMakeRotation(M_PI * 0.57);
    }];
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
