//
//  TPMainViewController.m
//  tpt
//
//  Created by apple on 16/7/21.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import "TPMainViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyBluetooth.h"
#import "PeripheralInfo.h"

#define channelOnPeropheralView @"peripheralView"
#define channelOnCharacteristicView @"CharacteristicView"

#define kPeripheralName         @"360qws Electric Bike Service"         //外围设备名称
#define kServiceUUID            @"8A0DFFD0-B80C-4335-8E5F-630031415354" //服务的UUID
#define kCharacteristicWriteUUID     @"8A0DFFD1-B80C-4335-8E5F-630031415354" //读写特征的UUID
#define kCharacteristicReadUUID     @"8A0DFFD2-B80C-4335-8E5F-630031415354" //读通知特征的UUID

@interface TPMainViewController()

@property __block NSMutableArray *services; // service 数组
@property(strong,nonatomic)CBPeripheral *currPeripheral;

@end

@implementation TPMainViewController{

    BabyBluetooth *baby;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //app 进入后台调用
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appEnterBackGround) name:@"backBabyBlue" object:nil];

    [SVProgressHUD showInfoWithStatus:@"准备打开设备"];

    self.services = [[NSMutableArray alloc]init];
    //初始化BabyBluetooth 蓝牙库
    baby = [BabyBluetooth shareBabyBluetooth];
    //设置蓝牙委托
    [self babyDelegate];



    //启动一个定时任务
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerTask) userInfo:nil repeats:YES];
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
    [self.currPeripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
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

                       for(int i=0;i<[data length];i++)
                           printf("testByteFF04[%d] = %d\n",i,resultByte[i]);

                       if (resultByte[3]) {
                           // 温度整数部分
                           NSLog(@"设置111 = %hhu",resultByte[3]);
                       }else if (resultByte[4]) {
                           // 温度小数部分
                           NSLog(@"设置222 = %hhu",resultByte[4]);
                       }else if (resultByte[5]) {
                           // 电量百分比
                           NSLog(@"设置333 = %hhu",resultByte[5]);
                       }
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
- (IBAction)clickShareSender:(UIButton *)sender {

}
#pragma mark 折线图
- (IBAction)clickLineSender:(id)sender {

}

-(void)timerTask{

}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"viewDidAppear");

    //停止之前的连接
    [baby cancelAllPeripheralsConnection];
    //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态。
    baby.scanForPeripherals().begin();

}

-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"viewWillDisappear");
}






@end
