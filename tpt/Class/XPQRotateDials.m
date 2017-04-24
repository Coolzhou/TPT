//
//  XPQRotateDials.m
//  XPQRotateDials
//
//  Created by RHC on 15/7/24.
//  Copyright (c) 2015年 com.launch. All rights reserved.
//

#import "XPQRotateDials.h"

#define marge 15
#define dashW (SCREEN_WIDTH-2*marge)

@interface XPQRotateDials () {
    CGFloat _radii;
    CGPoint _dialCenter;
    CGFloat _rulingWidth;
    CGSize _size;


}

@property (nonatomic) CGFloat needleAngle;

/// 指针移动动画时间，默认0.5
@property (nonatomic) IBInspectable CGFloat animationTime;

@property (nonatomic, strong) UIImageView *needleView;

@property (nonatomic, strong) UIImageView *titleImageView;

@property (nonatomic, strong) UILabel *infoLable;

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

    _animationTime = 0.5;
    _size = self.bounds.size;
    self.value = @"0.0";
    [self configParam];
}

-(void)configParam {
    // 初始值

//    self.backgroundColor =[UIColor orangeColor];

    tachLayer = [CALayer layer];
    tachLayer.bounds = CGRectMake(marge, 0,dashW, dashW/2);
    tachLayer.position = CGPointMake(kScreenWidth/2, dashW/4);

    if ([TPTool getPreferredLanguage]) {
        tachLayer.contents = (id)[UIImage imageNamed:@"main_dash_en"].CGImage;
    }else{
        tachLayer.contents = (id)[UIImage imageNamed:@"main_dash"].CGImage;
    }
    [self.layer addSublayer:tachLayer];
    
    // Create the layer for the pin
    self.needleView =[[UIImageView alloc]init];
    self.needleView.frame = CGRectMake(marge,dashW/2-dashW/8,dashW/2, dashW/4);

    self.needleView.image = [UIImage imageNamed:@"main_needle"];
    self.needleView.layer.anchorPoint = CGPointMake(0.95, 0.5);
    self.needleView.layer.position = CGPointMake(marge+dashW/2, 0.5*dashW/4+dashW/2-dashW/8);
    [self addSubview:self.needleView];

    [self addSubview:self.valueLabel];
    [self addSubview:self.infoLable];
    CGFloat needleViewH = CGRectGetHeight(self.needleView.frame);
    CGFloat needleViewY = CGRectGetMaxY(self.needleView.frame);
    
    if ((self.bounds.size.height - needleViewY)>70) {

        [self.infoLable makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.needleView.bottom).with.offset(0);
            make.left.equalTo (self.left).with.offset(35);
            make.height.mas_equalTo(25);
            make.width.mas_equalTo(200);
        }];

        [self.valueLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.infoLable.bottom).with.offset(0);
            make.bottom.equalTo(self.bottom).with.offset(0);
            make.left.equalTo (self.left).with.offset(0);
            make.right.equalTo (self.right).with.offset(0);
        }];

    }else{

        [self.valueLabel makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bottom).with.offset(0);
            make.left.equalTo (self.left).with.offset(0);
            make.right.equalTo (self.right).with.offset(0);
            make.height.mas_equalTo(50);
        }];
        [self.infoLable makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.needleView.bottom).with.offset(-needleViewH/2+15);
            make.left.equalTo (self.left).with.offset(35);
            make.bottom.equalTo(self.valueLabel.top).with.offset(0);
            make.width.mas_equalTo(200);
        }];
    }
}

#pragma mark  设置角度
-(void)setValue:(NSString *)value{
    _value = value;

    

    if (UserModel.temp_unit) {
        self.valueLabel.text = [NSString stringWithFormat:@"%.1f℉", [TPTool getUnitCurrentTemp:_value]];
    }else{
        self.valueLabel.text = [NSString stringWithFormat:@"%.1f℃", [TPTool getUnitCurrentTemp:_value]];
    }
    CGFloat tempValue = [value floatValue];
    
    NSLog(@"value ==== %f",tempValue);
    self.needleAngle = [self angleWithValue:tempValue];
}

-(void)setRefresh:(NSString *)refresh{

    _refresh = refresh;

    if (UserModel.temp_unit) {
        self.valueLabel.text = [NSString stringWithFormat:@"%.1f℉", [TPTool getUnitCurrentTemp:_value]];
    }else{
        self.valueLabel.text = [NSString stringWithFormat:@"%.1f℃", [TPTool getUnitCurrentTemp:_value]];
    }
}


#pragma mark 设置值
-(void)setNeedleAngle:(CGFloat)needleAngle {

//    NSLog(@"old = %f 走着 needAng = %f",_needleAngle,needleAngle);

    // 因为指针指向上，所以要偏90度
    CGFloat oldAngle = _needleAngle;
    _needleAngle = needleAngle;
    //    needleAngle += 90;

    [self rotateAnimationWithAngle:oldAngle toAngle:needleAngle];
}

#pragma mark -动画
-(void)rotateAnimationWithAngle:(CGFloat)oldAngle toAngle:(CGFloat)newAngle {
    CGFloat stepAngle = fabs(newAngle - oldAngle);
//    NSLog(@"sepAngle = %f",stepAngle);
    if (stepAngle < 180) {
        [UIView beginAnimations:@"rotation" context:NULL];
        [UIView setAnimationDuration:self.animationTime];
        self.needleView.transform = CGAffineTransformMakeRotation(newAngle * M_PI / 180);
        [UIView commitAnimations];
    }
    else {
        // UIView的旋转动画会自动选择小角度旋转，所以大于180度角的分两段执行
        CGFloat anlge1 = newAngle < oldAngle ? 180.1 : 179.9;
        CGFloat time1 = anlge1 / stepAngle * self.animationTime;
        [UIView beginAnimations:@"rotation1" context:NULL];
        [UIView setAnimationDuration:time1];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        self.needleView.transform = CGAffineTransformMakeRotation((oldAngle + anlge1) * M_PI / 180);
        [UIView commitAnimations];


        [UIView beginAnimations:@"rotation2" context:NULL];
        [UIView setAnimationDelay:time1];
        [UIView setAnimationDuration:self.animationTime - time1];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.needleView.transform = CGAffineTransformMakeRotation(newAngle * M_PI / 180);
        [UIView commitAnimations];
    }
}

#pragma mark - 数值转换函数
// 值转成角度
-(CGFloat)angleWithValue:(CGFloat)value {

    CGFloat low = 30.0;
    CGFloat high  = 55.0;

    CGFloat tem_low = UserModel.max_tem_low.floatValue;
    CGFloat tem_middle = UserModel.max_tem_middle.floatValue;
    CGFloat tem_high =UserModel.max_tem_high.floatValue;
    CGFloat tem_supper_high = UserModel.max_tem_supper_high.floatValue;

    if (value <low) {
        value = low;
    }else if(value>45){
        value = high;
    }
    
    if (value < tem_low) {
        return  (value-low)/(tem_low-low)*45;
    }else if (value >= tem_low && value < tem_middle) {
        return 45+ (value-tem_low)/(tem_middle-tem_low)*30;
    } else if (value >= tem_middle && value < tem_high) {
        return  45+30+(value-tem_middle)/(tem_high-tem_middle)*35;
    } else if (value >= tem_high && value < tem_supper_high) {
        return 45+30+35+ (value-tem_high)/(tem_supper_high-tem_high)*35;
    } else {
        return 45+30+35+35+ (value-tem_supper_high)/(high-tem_supper_high)*35;
    }
}


-(UILabel *)valueLabel{
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth, 50)];
        _valueLabel.textAlignment = NSTextAlignmentCenter;
        _valueLabel.textColor = MainTitleColor;
        _valueLabel.font = [UIFont boldSystemFontOfSize:50];
    }
    return _valueLabel;
}

-(UILabel *)infoLable{
    if (!_infoLable) {
        _infoLable = [[UILabel alloc]init];
        _infoLable.text = NSLocalizedString(@"cur_temperature",@"");
        _infoLable.font = [UIFont systemFontOfSize:14];
//        _infoLable.textColor = MainContentColor;
    }
    return _infoLable;
}

@end
