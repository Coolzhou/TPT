//
//  MCFirstPageVIewController.m
//  LeftSlide
//
//  Created by apple on 16/4/29.
//  Copyright © 2016年 machao. All rights reserved.
//

#import "MCFirstPageVIewController.h"

#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyBluetooth.h"
#import "PeripheralInfo.h"
#import "XPQRotateDials.h"
#import "SNChart.h"
#import "MJAudioTool.h"

//记录温度数据
#import "WBCacheTool.h"
#import "TPTStateCacheTool.h"
#import "WBTemperature.h"


@interface MCFirstPageVIewController ()<SNChartDataSource>{
    BabyBluetooth *baby;
}

@property (strong, nonatomic)XPQRotateDials *rotateDials;

@property (nonatomic,strong)SNChart * chart;  //折线图
@property (nonatomic,strong)NSMutableArray *valueArray; //温度数组
@property (nonatomic,strong)NSMutableArray *timeArray;  //时间数组

@property (nonatomic,strong)NSString *staticTemp;//默认正常状态

@property (nonatomic,strong)UIImageView *titleImageView;

@end

@implementation MCFirstPageVIewController

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"viewDidAppear");
    [super viewDidAppear:animated];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.rotateDials) {
        self.rotateDials.refresh =@"1";
    }
    if (self.chart) {
        self.chart.refresh = @"1";
    }
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = self.titleImageView;
    self.staticTemp = @"0";
    
    baby = [AppDelegate shareDelegate].baby;
    [self deleteNotCurrentMonthData];//删除非当月数据
    
    [self addNavigationItem]; //分享按钮
    [self addRotateDials]; //增加转盘
    [self addchartLineView];//增加折线图
    
//    self.chart.valueArray = [NSMutableArray arrayWithObjects:@"35.82",@"40.56",@"25.12", nil];
//    self.chart.timeArray = [NSMutableArray arrayWithObjects:@"10:29:38",@"10:29:45",@"10:29:45", nil];
//    self.rotateDials.value = [NSString stringWithFormat:@"48.3"];
    
}
#pragma mark 删除非当月数据
-(void)deleteNotCurrentMonthData{
    
    int firstMonth = [TPTool datecurrentMonthFirestDayTime];
    [WBCacheTool deleteTemp:firstMonth];
    [TPTStateCacheTool deleteTemp:firstMonth];
    NSLog(@"firstMonth = %d",firstMonth);
    
}

#pragma mark 增加 折线图
-(void)addchartLineView{
    self.chart = [[SNChart alloc] initWithFrame:CGRectMake(15,kScreenHeight-kScreenHeight*0.35-20, self.view.frame.size.width-30, kScreenHeight*0.35) withDataSource:self andChatStyle:SNChartStyleLine];
    [self.chart showInView:self.view];
    
}
- (NSArray *)chatConfigYValue:(SNChart *)chart {
    return @[@"36",@"38"];
}

- (NSArray *)chatConfigXValue:(SNChart *)chart {
    return @[@"1",@"2",];
}

#pragma mark rightBarButtonItem
-(void)addNavigationItem{
    [self.navbackButton setImage:[UIImage imageNamed:@"navigation_left"] forState:UIControlStateNormal];
}

#pragma mark 打开左视图
-(void)clickLeftBarButtonItem{
    //打开左视图
    [[MCLeftSliderManager sharedInstance].LeftSlideVC openLeftView];
    
//    [baby cancelAllPeripheralsConnection];
//    baby.scanForPeripherals().begin();
}

#pragma mark 转盘
-(void)addRotateDials{
    
    self.rotateDials = [[XPQRotateDials alloc]initWithFrame:CGRectMake(0,64, kScreenWidth,kScreenHeight *0.65-84)];
    [self.view addSubview:self.rotateDials];
    
}

//订阅一个值
-(void)setNotifiy:(CBCharacteristic *)characteristic{
    
    __weak typeof(self) weakSelf = self;
    
    if(self.currPeripheral.state != CBPeripheralStateConnected) {
        
        NSLog(@"peripheral已经断开连接，请重新连接");
        //        [SVProgressHUD showErrorWithStatus:@"peripheral已经断开连接，请重新连接"];
        return;
    }
    if (characteristic.properties & CBCharacteristicPropertyNotify ||  characteristic.properties & CBCharacteristicPropertyIndicate) {
        
        if(characteristic.isNotifying) {
            [baby cancelNotify:self.currPeripheral characteristic:characteristic];
            NSLog(@"通知");
        }else{
            NSLog(@"取消通知 =%@ - %@",self.currPeripheral,characteristic);
            [self.currPeripheral setNotifyValue:YES forCharacteristic:characteristic];
            [baby notify:self.currPeripheral
          characteristic:characteristic
                   block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
                       NSLog(@"通知的值 new value %@",characteristics.value);
                       NSData * data = characteristic.value;
                       Byte * resultByte = (Byte *)[data bytes];
                       
                       NSString *currentElec =[NSString stringWithFormat:@"%u",resultByte[5]];
                       
                       if (![NSString isNull:currentElec]) {
                           UserModel.temp_currentElec = currentElec;
                       }
                       //温度
                       NSString *aa =[NSString stringWithFormat:@"%u.%u",resultByte[3],resultByte[4]];
                       
                       CGFloat tempfloats = [aa floatValue] + [UserModel.temp_check floatValue];
                       NSLog(@"teeee=%f",tempfloats);
                       self.rotateDials.value = [NSString stringWithFormat:@"%.1f",tempfloats];
                       [self.valueArray addObject:aa];
                       
                       [weakSelf showAlarm:tempfloats];
                       
                       NSString *timeStr =[TPTool getCurrentDate];
                       int tempTimeInt = [TPTool getCurrentTimeIntDate];
                       [self.timeArray addObject:timeStr];
                       
                       if (self.valueArray.count>chartMaxNum) {
                           //默认为正序遍历
                           [self.valueArray removeObjectAtIndex:0];
                       }
                       if (self.timeArray.count>chartMaxNum) {
                           //默认为正序遍历
                           [self.timeArray removeObjectAtIndex:0];
                       }
                       self.chart.valueArray = self.valueArray;
                       self.chart.timeArray = self.timeArray;
                       //记录所有数据
                       WBTemperature *temp = [[WBTemperature alloc] init];
                       temp.create_time = tempTimeInt;
                       temp.temp = [aa floatValue];
                       [WBCacheTool addTemperature:temp];
                       
                       //记录提醒数据
                       NSString *getTemp = [TPTool getCurrentTempState:aa];
                       if (![getTemp isEqualToString:@"-1"]) {
                           if (![self.staticTemp isEqualToString:getTemp]) {
                               WBTemperature *temp = [[WBTemperature alloc] init];
                               temp.create_time = tempTimeInt;
                               temp.temp = aa.floatValue;
                               temp.temp_state = getTemp;
                               [TPTStateCacheTool addTemperature:temp];
                               self.staticTemp = getTemp;
                           }
                       }
                       
                   }];
        }
    }
    else{
        [SVProgressHUD showErrorWithStatus:@"这个characteristic没有nofity的权限"];
        return;
    }
}

#pragma mark 警报
-(void)showAlarm:(CGFloat)temp{
    //播放警报
    [TPTool palyAlartTempFloat:temp andVC:self];
}

#pragma mark 蓝牙
- (IBAction)clickBluetoothSender:(UIButton *)sender {
    
    if (self.currPeripheral) {
        
        for(CBService *service in self.currPeripheral.services)
        {
            if([service.UUID isEqual:[CBUUID UUIDWithString:kServiceUUID]])
            {
                for(CBCharacteristic *characteristic in service.characteristics)
                {
                    if([characteristic.UUID isEqual:[CBUUID UUIDWithString:kCharacteristicWriteUUID]])
                    {
                        [self writeValue:characteristic];
                    }
                }
            }
        }
    }
}

//写一个值
-(void)writeValue:(CBCharacteristic *)characteristic{
    
    Byte dataArray[] = {0xFC,0x02,0x00,0x02,0xED};
    NSData *data = [NSData dataWithBytes:dataArray length:sizeof(dataArray)/sizeof(dataArray[0])];
    NSLog(@"data3333 = %@",data);
    
//    if (characteristic) {
        [self.currPeripheral writeValue:data forCharacteristic:self.writeCBCharacteristic type:CBCharacteristicWriteWithResponse];
//    }
    NSLog(@"写入值 charact = %@ ,current = %@",self.writeCBCharacteristic,characteristic);
    
}



-(NSMutableArray *)valueArray{
    if (!_valueArray) {
        _valueArray = [[NSMutableArray alloc]init];
    }
    return _valueArray;
}

-(NSMutableArray *)timeArray{
    if (!_timeArray) {
        _timeArray = [[NSMutableArray alloc]init];
    }
    return _timeArray;
}

-(UIImageView *)titleImageView{
    if (!_titleImageView) {
        _titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,208,25)];
        _titleImageView.image = [UIImage imageNamed:@"main_titleImg"];
    }
    return _titleImageView;
}


@end
