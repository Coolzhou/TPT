//
//  CustomAlertView.m
//  CustomAlertView
//
//  Created by 丁宗凯 on 16/6/22.
//  Copyright © 2016年 dzk. All rights reserved.
//

#import "CustomAlertView.h"
#define MAINSCREENwidth   [UIScreen mainScreen].bounds.size.width
#define MAINSCREENheight  [UIScreen mainScreen].bounds.size.height
#define WINDOWFirst [[UIApplication sharedApplication] keyWindow]
#define RGBa(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]


//#define AlertViewHeight 248
#define AlertViewJianGe 25

#define AlertViewMarge 150         // 加、减 按钮间隔
#define AlertViewOtherMarge 80    //保存、关闭 按钮间隔

@interface CustomAlertView()

@property (nonatomic,strong)UILabel *tempLable;  //温度lable
@property (nonatomic,strong)UILabel *infoLable;  //提醒lable

@property (nonatomic,strong)NSString *tempValue; //温度值

@property (nonatomic,assign)NSInteger currentButTag; //当前按钮tag

@end

@implementation CustomAlertView


-(instancetype)initWithAlertViewType:(CustomAlertViewType) type andTag:(NSInteger)tag
{
    self=[super init];

    if (self) {
        CGFloat AlertViewHeight = 350;
        if (self.bGView==nil) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREENwidth, MAINSCREENheight)];
            view.backgroundColor = [UIColor blackColor];
            view.alpha = 0.5;
            [WINDOWFirst addSubview:view];
            self.bGView =view;
        }
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;

        self.currentButTag = tag;

        [self getTempValue:tag]; //得到tempValue;
        
        self.center = CGPointMake(MAINSCREENwidth/2, MAINSCREENheight/2);
        self.bounds = CGRectMake(0, 0, MAINSCREENwidth - 2*AlertViewJianGe, AlertViewHeight);
        [WINDOWFirst addSubview:self];

        //总长
        CGFloat alertW = self.bounds.size.width;
        self.backgroundColor = RGB(203, 206, 201);

        //title
        UILabel *lab = [[UILabel alloc] init];
        lab.frame = CGRectMake(0, 0,alertW, 60);
        lab.text = NSLocalizedString(@"max_tem",@"");
        lab.font = [UIFont systemFontOfSize:21];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = MainTitleColor;
        [self addSubview:lab];
        self.titleLabel =lab;

        //加减
        CGFloat centerY = CGRectGetMaxY(lab.frame);
        UIView *centerView = [[UIView alloc]initWithFrame:CGRectMake(0, centerY, alertW, 120)];
        [self addSubview:centerView];

        //加
        CGFloat btnWidth = (alertW -2*AlertViewJianGe-AlertViewMarge)/2;
        CGFloat btnHeight = centerView.frame.size.height;
        UIButton *addButton = [[UIButton alloc]init];
        addButton.frame = CGRectMake(AlertViewJianGe,0, btnWidth, btnHeight);
        [addButton setTitle:@"+" forState:0];
        addButton.titleLabel.font = [UIFont systemFontOfSize:50];
        addButton.tag =0;
        [addButton setTitleColor:[UIColor blackColor] forState:0];
        [addButton addTarget:self action:@selector(addTempValueButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [centerView addSubview:addButton];


        self.tempLable.frame = CGRectMake(addButton.frame.origin.x+btnWidth,0,AlertViewMarge, btnHeight);


        self.tempLable.text =[NSString stringWithFormat:@"%.1f",self.tempValue.floatValue];
        self.tempLable.font = [UIFont boldSystemFontOfSize:55];
        self.tempLable.textAlignment = NSTextAlignmentCenter;
        [centerView addSubview:self.tempLable];

        //减
        UIButton *reduceButton = [[UIButton alloc]init];
        reduceButton.frame = CGRectMake(addButton.frame.origin.x+btnWidth+AlertViewMarge,0, btnWidth, btnHeight);
        [reduceButton setTitle:@"-" forState:0];
        reduceButton.titleLabel.font = addButton.titleLabel.font;
        [reduceButton setTitleColor:[UIColor blackColor] forState:0];
        [reduceButton addTarget:self action:@selector(reduceTempValueButtonClick) forControlEvents:UIControlEventTouchUpInside];
        reduceButton.tag =1;
        [centerView addSubview:reduceButton];

        //提醒lable
        CGFloat infoT = CGRectGetMaxY(centerView.frame);

        self.infoLable.frame = CGRectMake(AlertViewJianGe,infoT,alertW- 2*AlertViewJianGe, 54);

        self.infoLable.font = [UIFont systemFontOfSize:16];
        self.infoLable.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.infoLable];


        //保存
        CGFloat otherWidth = (alertW -2*AlertViewJianGe-AlertViewOtherMarge)/2;
        CGFloat ButtonY = CGRectGetMaxY(self.infoLable.frame)+15;
        CGFloat otherButHeight = 44;
        UIButton *cancelButton = [[UIButton alloc]init];
        cancelButton.frame = CGRectMake(AlertViewJianGe,ButtonY, otherWidth, otherButHeight);
        cancelButton.layer.cornerRadius = 5;
        cancelButton.layer.masksToBounds = YES;

        
        [cancelButton setTitle:NSLocalizedString(@"max_save",@"") forState:0];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        cancelButton.tag =0;
        [cancelButton setTitleColor:[UIColor whiteColor] forState:0];
        [cancelButton setBackgroundColor:RGB(217, 52, 85)];
        [cancelButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];

        //关闭
        UIButton *qRButton = [[UIButton alloc]init];
        qRButton.frame = CGRectMake(cancelButton.frame.origin.x+otherWidth+AlertViewOtherMarge,ButtonY, otherWidth, otherButHeight);
        qRButton.layer.cornerRadius = 5;
        qRButton.layer.masksToBounds = YES;
        [qRButton setTitle:NSLocalizedString(@"max_cancel",@"") forState:0];
        qRButton.titleLabel.font = cancelButton.titleLabel.font;
        [qRButton setTitleColor:[UIColor whiteColor] forState:0];
        [qRButton setBackgroundColor:RGB(85, 162, 30)
         ];
        [qRButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];

        qRButton.tag =1;
        [self addSubview:qRButton];

        NSString *suggestStr = NSLocalizedString(@"max_suggest",@"");
        NSString *temp;
        if (tag ==10) {
            temp = @"37.5";
        }else if (tag ==11){
            temp = @"38.1";
        }else if (tag ==12){
            temp = @"39.1";
        }else{
            temp = @"41";
        }
        if (UserModel.temp_unit) {
            self.infoLable.text = [NSString stringWithFormat:@"%@ %.1f℉",suggestStr,[TPTool getUnitCurrentTemp:temp]];
        }else{
            self.infoLable.text = [NSString stringWithFormat:@"%@ %.1f℃",suggestStr,[TPTool getUnitCurrentTemp:temp]];
        }
        [self show:YES];
    }
    return self;
}

//得到value
-(void)getTempValue:(NSInteger)tag{

    NSLog(@"buttonTagqian = %ld",(long)tag);

    if (UserModel.temp_unit == NO) {
        //摄氏度
        if (tag ==10) {
            self.tempValue = UserModel.max_tem_low;
        }else if (tag ==11){
            self.tempValue = UserModel.max_tem_middle;
        }else if (tag ==12){
            self.tempValue = UserModel.max_tem_high;
        }else{
            self.tempValue = UserModel.max_tem_supper_high;
        }
    }else{
        NSString *temp =@"";
        if (tag ==10) {
            temp = UserModel.max_tem_low;
        }else if (tag ==11){
            temp = UserModel.max_tem_middle;
        }else if (tag ==12){
            temp = UserModel.max_tem_high;
        }else{
            temp = UserModel.max_tem_supper_high;
        }
       self.tempValue = [NSString stringWithFormat:@"%.1f",[TPTool getUnitCurrentTemp:temp]];
    }
}

-(void)saveTempValue{

    NSString *tempC = @"";

    if (UserModel.temp_unit == NO) {
        //摄氏度
        tempC = self.tempValue;
    }else{
        tempC = [NSString stringWithFormat:@"%.1f",[TPTool getFahrenheitDegrrTempFloat:self.tempValue]];
    }

    if (_currentButTag ==10) {
        if (![UserModel.max_tem_low isEqualToString:tempC]) {
            UserModel.max_tem_low = tempC;
            if (self.ButtonClick) {
                self.ButtonClick(_currentButTag);
            }
        }
    }else if (_currentButTag ==11){
        if (![UserModel.max_tem_middle isEqualToString:tempC]) {
            UserModel.max_tem_middle = tempC;
            if (self.ButtonClick) {
                self.ButtonClick(_currentButTag);
            }
        }
    }else if (_currentButTag ==12){

        if (![UserModel.max_tem_high isEqualToString:tempC]) {
            UserModel.max_tem_high = tempC;
            if (self.ButtonClick) {
                self.ButtonClick(_currentButTag);
            }
        }

    }else{
        if (![UserModel.max_tem_supper_high isEqualToString:tempC]) {
            UserModel.max_tem_supper_high = tempC;
            if (self.ButtonClick) {
                self.ButtonClick(_currentButTag);
            }
        }
    }
}

#pragma mark 加、减

-(void)addTempValueButtonClick{

    CGFloat maxTemp = 0;

    if (UserModel.temp_unit == NO) {
        //摄氏度
        if (_currentButTag ==10) {
            maxTemp = UserModel.max_tem_middle.floatValue-0.15;
        }else if (_currentButTag ==11){
            maxTemp = UserModel.max_tem_high.floatValue-0.15;
        }else if (_currentButTag ==12){
            maxTemp = UserModel.max_tem_supper_high.floatValue-0.15;
        }else{
            maxTemp = 45.0;
        }
    }else{
        if (_currentButTag ==10) {
            maxTemp =[TPTool getUnitCurrentTemp:UserModel.max_tem_middle]-0.15;
        }else if (_currentButTag ==11){
            maxTemp =[TPTool getUnitCurrentTemp:UserModel.max_tem_high]-0.15;
        }else if (_currentButTag ==12){
            maxTemp =[TPTool getUnitCurrentTemp:UserModel.max_tem_supper_high]-0.15;
        }else{
            maxTemp = [TPTool getUnitCurrentTempFloat:45];
        }
    }

    CGFloat temp = self.tempValue.floatValue;

    NSLog(@"temp =%f,maxTemop= %f",temp,maxTemp);
    if (temp<maxTemp) {
        temp = temp +0.1;
        self.tempValue = [NSString stringWithFormat:@"%f",temp];
        self.tempLable.text = [NSString stringWithFormat:@"%.1f",temp];
    }
}

#pragma mark 减
-(void)reduceTempValueButtonClick{

    CGFloat minTemp = 0;


    if (UserModel.temp_unit == NO) {
        //摄氏度
        if (_currentButTag ==10) {
            minTemp = 35.0;
        }else if (_currentButTag ==11){
            minTemp = UserModel.max_tem_low.floatValue+0.15;
        }else if (_currentButTag ==12){
            minTemp = UserModel.max_tem_middle.floatValue+0.15;
        }else{
            minTemp = UserModel.max_tem_high.floatValue+0.15;
        }
    }else{
        if (_currentButTag ==10) {
            minTemp =[TPTool getUnitCurrentTempFloat:35.0];
        }else if (_currentButTag ==11){
            minTemp =[TPTool getUnitCurrentTemp:UserModel.max_tem_low]+0.15;
        }else if (_currentButTag ==12){
            minTemp =[TPTool getUnitCurrentTemp:UserModel.max_tem_middle]+0.15;
        }else{
            minTemp = [TPTool getUnitCurrentTemp:UserModel.max_tem_high]+0.15;
        }
    }
    CGFloat temp = self.tempValue.floatValue;

    NSLog(@"temp =%f,minTemop= %f",temp,minTemp);
    if (temp > minTemp) {
        temp = temp - 0.1;
        self.tempValue = [NSString stringWithFormat:@"%f",temp];
        self.tempLable.text = [NSString stringWithFormat:@"%.1f",temp];
    }
}

#pragma mark 点击保存
-(void)saveButtonClick{
    [self hide:YES];
    [self saveTempValue]; //保存
}

#pragma mark 点击关闭
-(void)buttonClick
{
    [self hide:YES];
}
- (void)show:(BOOL)animated
{
    if (animated)
    {
        self.transform = CGAffineTransformScale(self.transform,0,0);
        __weak CustomAlertView *weakSelf = self;
        [UIView animateWithDuration:.3 animations:^{
            weakSelf.transform = CGAffineTransformScale(weakSelf.transform,1.2,1.2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.3 animations:^{
                weakSelf.transform = CGAffineTransformIdentity;
            }];
        }];
    }
}

- (void)hide:(BOOL)animated
{
    [self endEditing:YES];
    if (self.bGView != nil) {
        __weak CustomAlertView *weakSelf = self;
        
        [UIView animateWithDuration:animated ?0.3: 0 animations:^{
            weakSelf.transform = CGAffineTransformScale(weakSelf.transform,1,1);
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration: animated ?0.3: 0 animations:^{
                weakSelf.transform = CGAffineTransformScale(weakSelf.transform,0.01,0.01);
            } completion:^(BOOL finished) {
                [weakSelf.bGView removeFromSuperview];
                [weakSelf removeFromSuperview];
                weakSelf.bGView=nil;
            }];
        }];
    }
}

-(UILabel *)tempLable{
    if (!_tempLable) {
        _tempLable = [[UILabel  alloc]init];
        _tempLable.font = [UIFont systemFontOfSize:25];
        _tempLable.textColor = MainTitleColor;
        _tempLable.textAlignment = NSTextAlignmentCenter;
    }
    return _tempLable;
}

-(UILabel *)infoLable{
    if (!_infoLable) {
        _infoLable = [[UILabel alloc]init];
        _infoLable.textColor = MainContentColor;
        _infoLable.font = [UIFont systemFontOfSize:17];
        _infoLable.numberOfLines = 0;
        _infoLable.textAlignment = NSTextAlignmentLeft;
    }
    return _infoLable;
}



@end
