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

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

#import "XPQRotateDials.h"
#import "SNChart.h"
#import "TPTool.h"

//记录温度数据
#import "WBCacheTool.h"
#import "TPTStateCacheTool.h"
#import "WBTemperature.h"
#define channelOnPeropheralView @"peripheralView"
#define channelOnCharacteristicView @"CharacteristicView"
#define kPeripheralName         @"360qws Electric Bike Service"         //外围设备名称
#define kServiceUUID            @"8A0DFFD0-B80C-4335-8E5F-630031415354" //服务的UUID
#define kCharacteristicWriteUUID     @"8A0DFFD1-B80C-4335-8E5F-630031415354" //读写特征的UUID
#define kCharacteristicReadUUID     @"8A0DFFD2-B80C-4335-8E5F-630031415354" //读通知特征的UUID

@interface MCFirstPageVIewController ()<SNChartDataSource>{
    BabyBluetooth *baby;
    NSTimer *_timer;     //定时器
}
@property __block NSMutableArray *services; // service 数组
@property(strong,nonatomic)CBPeripheral *currPeripheral;
@property(strong,nonatomic)CBCharacteristic *writeCBCharacteristic; //写服务
@property (strong, nonatomic)XPQRotateDials *rotateDials;

@property (nonatomic,strong)SNChart * chart;  //折线图
@property (nonatomic,strong)NSMutableArray *valueArray; //温度数组
@property (nonatomic,strong)NSMutableArray *timeArray;  //时间数组

@property (nonatomic,strong)NSString *staticTemp;//默认正常状态

@end

@implementation MCFirstPageVIewController

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"viewDidAppear");
    
    //停止之前的连接
    [baby cancelAllPeripheralsConnection];
    //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态。
    baby.scanForPeripherals().begin();
    
}

-(void)viewDidLoad{
    [super viewDidLoad];
    // 设置黑夜效果

    self.view.backgroundColor = [UIColor whiteColor];
    self.bgimageView.image = [UIImage imageNamed:@"main_first_bg"];
    self.staticTemp = @"0";
    [self loadBabayBluetooth]; //蓝牙
    [self createTimer];

    [self addNavigationItem]; //分享按钮
    [self addRotateDials]; //增加转盘

    [self addchartLineView];//增加折线图

}

-(void)addchartLineView{
    self.chart = [[SNChart alloc] initWithFrame:CGRectMake(15,kScreenHeight-280, self.view.frame.size.width-30, 260) withDataSource:self andChatStyle:SNChartStyleLine];
    [self.chart showInView:self.view];
}
- (NSArray *)chatConfigYValue:(SNChart *)chart {
    return @[@"36",@"38"];
}

- (NSArray *)chatConfigXValue:(SNChart *)chart {
    return @[@"1",@"2",];
}

- (void)createTimer
{
    _timer=[NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(dealTimer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSDefaultRunLoopMode];
}

-(void)dealTimer{
    if (self.writeCBCharacteristic) {
        [self writeValue:self.writeCBCharacteristic];
    }

    NSString *tempStr =[NSString stringWithFormat:@"%f",arc4random()%7+35+0.46];
    [self.valueArray addObject:tempStr];

    NSString *timeStr =[TPTool getCurrentDate];
    NSString *tempTimeStr = [TPTool getTempCurrentDate];
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
    temp.create_time = timeStr;
    temp.temp = tempStr.floatValue;
    [WBCacheTool addTemperature:temp];

    //记录提醒数据
    NSString *getTemp = [TPTool getCurrentTempState:tempStr];
    if (![getTemp isEqualToString:@"-1"]) {
        if (![self.staticTemp isEqualToString:getTemp]) {
            WBTemperature *temp = [[WBTemperature alloc] init];
            temp.create_time = tempTimeStr;
            temp.temp = tempStr.floatValue;
            temp.temp_state = getTemp;
            [TPTStateCacheTool addTemperature:temp];
            self.staticTemp = getTemp;
        }
    }
}

#pragma mark rightBarButtonItem
-(void)addNavigationItem{
    [self.navbackButton setImage:[UIImage imageNamed:@"navigation_left"] forState:UIControlStateNormal];
}
-(void)clickLeftBarButtonItem{
    //打开左视图
    [[MCLeftSliderManager sharedInstance].LeftSlideVC openLeftView];
}

#pragma mark 转盘
-(void)addRotateDials{
    
    self.rotateDials = [[XPQRotateDials alloc]initWithFrame:CGRectMake(0, 110, kScreenWidth, 400)];
    [self.view addSubview:self.rotateDials];

}

#pragma mark 蓝牙
-(void)loadBabayBluetooth{

    //app 进入后台调用
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appEnterBackGround) name:@"backBabyBlue" object:nil];

    self.services = [[NSMutableArray alloc]init];
    //初始化BabyBluetooth 蓝牙库
    baby = [BabyBluetooth shareBabyBluetooth];
    //设置蓝牙委托
    [self babyDelegate];
}

-(void)loadData{
    [SVProgressHUD showInfoWithStatus:@"开始连接设备"];
    baby.having(self.currPeripheral).and.channel(channelOnPeropheralView).then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
}


//蓝牙网关初始化和委托方法设置
-(void)babyDelegate{

    __weak typeof(self) weakSelf = self;
    __weak BabyBluetooth  *weakbaby = baby;

    BabyRhythm *rhythm = [[BabyRhythm alloc]init];

    [baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBCentralManagerStatePoweredOn) {
            [SVProgressHUD showInfoWithStatus:@"设备打开成功，开始扫描设备"];
        }
    }];
    //设置扫描到设备的委托
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"搜索到了设备:%@",peripheral.name);
        weakSelf.currPeripheral = peripheral;
        [weakSelf loadData]; //连接设备
    }];
    //设置设备连接成功的委托,同一个baby对象，使用不同的channel切换委托回调
    [baby setBlockOnConnectedAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral) {
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--连接成功",peripheral.name]];
    }];

    //设置设备连接失败的委托
    [baby setBlockOnFailToConnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--连接失败",peripheral.name);
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--连接失败",peripheral.name]];
    }];

    //设置设备断开连接的委托
    [baby setBlockOnDisconnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--断开连接",peripheral.name);
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--断开失败",peripheral.name]];
        [weakSelf loadData];
    }];

    //设置发现设备的Services的委托
    [baby setBlockOnDiscoverServicesAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, NSError *error) {
        CBService *service = peripheral.services.firstObject;
        PeripheralInfo *info = [[PeripheralInfo alloc]init];
        [info setServiceUUID:service.UUID];
        [info setCharacteristics:(NSMutableArray *)service.characteristics];

        NSLog(@"info.chat = %@",info.characteristics);
        for (int i=0; i<info.characteristics.count; i++) {
            CBCharacteristic *characteristic = info.characteristics[i];
            weakbaby.channel(channelOnCharacteristicView).characteristicDetails(weakSelf.currPeripheral,characteristic);
        }
        [rhythm beats];
    }];
    //设置发现设service的Characteristics的委托
    [baby setBlockOnDiscoverCharacteristicsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"===service name:%@",service.UUID);

    }];
    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristicAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);

        if ([characteristics.UUID isEqual:[CBUUID UUIDWithString:kCharacteristicWriteUUID]]) {
            weakSelf.writeCBCharacteristic = characteristics;
            [weakSelf writeValue:characteristics];  //开始写入命令
        }
        if ([characteristics.UUID isEqual:[CBUUID UUIDWithString:kCharacteristicReadUUID]]) {
            [weakSelf setNotifiy:characteristics];  //订阅一个值
        }
    }];
    //设置查找设备的过滤器
    [baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {

        //最常用的场景是查找某一个前缀开头的设备
        if ([peripheralName hasPrefix:@"Jin"] ) {
            [weakbaby cancelScan];
            //停止扫描
            return YES;
        }
        return NO;
    }];

    [baby setBlockOnCancelAllPeripheralsConnectionBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelAllPeripheralsConnectionBlock");
    }];

    //设置写数据成功的block
    [baby setBlockOnDidWriteValueForCharacteristicAtChannel:channelOnCharacteristicView block:^(CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"setBlockOnDidWriteValueForCharacteristicAtChannel characteristic:%@ and new value:%@",characteristic.UUID, characteristic.value);
    }];

    //设置通知状态改变的block
    [baby setBlockOnDidUpdateNotificationStateForCharacteristicAtChannel:channelOnCharacteristicView block:^(CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"uid:%@,isNotifying:%@",characteristic.UUID,characteristic.isNotifying?@"on":@"off");
    }];

    [baby setBlockOnCancelScanBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelScanBlock");
    }];

    //示例:
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件

    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    NSDictionary *connectOptions = @{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES,
                                     CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES,
                                     CBConnectPeripheralOptionNotifyOnNotificationKey:@YES};

    [baby setBabyOptionsAtChannel:channelOnPeropheralView scanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:connectOptions scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
}


//写一个值
-(void)writeValue:(CBCharacteristic *)characteristic{

    Byte dataArray[] = {0xFC,0x02,0x00,0x02,0xED};
    NSData *data = [NSData dataWithBytes:dataArray length:sizeof(dataArray)/sizeof(dataArray[0])];
    NSLog(@"data = %@",data);

    if (characteristic) {
        [self.currPeripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }
    NSLog(@"charact = %@ ,current = %@",characteristic.UUID,self.currPeripheral.name);
}
//订阅一个值
-(void)setNotifiy:(CBCharacteristic *)characteristic{

    __weak typeof(self)weakSelf = self;
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
            [weakSelf.currPeripheral setNotifyValue:YES forCharacteristic:characteristic];
            NSLog(@"取消通知");
            [baby notify:self.currPeripheral
          characteristic:characteristic
                   block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
                       NSLog(@"通知的值 new value %@",characteristics.value);
                       NSData * data = characteristic.value;
                       Byte * resultByte = (Byte *)[data bytes];

////                       if (resultByte[3]) {
////                           // 温度整数部分
//                           NSLog(@"设置111 = %hhu",resultByte[3]);
////                       }else if (resultByte[4]) {
////                           // 温度小数部分
//                           NSLog(@"设置222 = %hhu",resultByte[4]);
////                       }else if (resultByte[5]) {
//                           // 电量百分比
//                           NSLog(@"设置333 = %hhu",resultByte[5]);
////                       }

                       NSString *currentElec =[NSString stringWithFormat:@"%u",resultByte[5]];
                       if (![NSString isNull:currentElec]) {
                           [[NSUserDefaults standardUserDefaults]setObject:currentElec forKey:@"currentElec"];
                       }
                       NSString *aa =[NSString stringWithFormat:@"%f",arc4random()%7+35+0.46];
//                       NSString *aa =[NSString stringWithFormat:@"%u.%u",resultByte[3],resultByte[4]];
//                       NSLog(@"aaaaaa =%@",aa);
                       [self.valueArray addObject:aa];

                       NSString *bb =[TPTool getCurrentDate];
                       [self.timeArray addObject:bb];

                       if (self.valueArray.count>7) {
                           //默认为正序遍历
                           [self.valueArray removeObjectAtIndex:0];
                       }
                       if (self.timeArray.count>7) {
                           //默认为正序遍历
                           [self.timeArray removeObjectAtIndex:0];
                       }
                       self.chart.valueArray = self.valueArray;
                       self.chart.timeArray = self.timeArray;
                   }];
        }
    }
    else{
        [SVProgressHUD showErrorWithStatus:@"这个characteristic没有nofity的权限"];
        return;
    }
}

#pragma mark app 进入后台
- (void)appEnterBackGround{

    for(CBService *service in self.currPeripheral.services)
    {
        if([service.UUID isEqual:[CBUUID UUIDWithString:kServiceUUID]])
        {
            for(CBCharacteristic *characteristic in service.characteristics)
            {
                if([characteristic.UUID isEqual:[CBUUID UUIDWithString:kCharacteristicWriteUUID]])
                {
                    Byte dataArray[] = {0xFC,0x04,0x01,0x01,0x02,0xED};
                    NSData *data = [NSData dataWithBytes:dataArray length:sizeof(dataArray)/sizeof(dataArray[0])];
                    NSLog(@"data = %@",data);
                    [self.currPeripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
                }
            }
        }
    }
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


#pragma mark 分享
-(void)shareReftList{

    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"shareImg.png"]];
    //    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {

        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                         images:imageArray
                                            url:[NSURL URLWithString:@"http://mob.com"]
                                          title:@"分享标题"
                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:@[@(SSDKPlatformSubTypeWechatSession),
                                         @(SSDKPlatformSubTypeWechatTimeline),
                                         @(SSDKPlatformTypeQQ),
                                         @(SSDKPlatformTypeSinaWeibo),
                                         @(SSDKPlatformTypeFacebook),
                                         @(SSDKPlatformTypeTwitter),
                                         @(SSDKPlatformTypeGooglePlus),
                                         @(SSDKPlatformTypeLine),
                                         @(SSDKPlatformTypeWhatsApp)]
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {

                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];

                               NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"backBabyBlue" object:nil];
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


@end
