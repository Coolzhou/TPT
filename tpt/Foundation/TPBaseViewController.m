//
//  TPBaseViewController.m
//  tpt
//
//  Created by Yi luqi on 16/7/30.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import "TPBaseViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKExtension/SSEShareHelper.h>

#import "PeripheralInfo.h"
#import "WBCacheTool.h"
#import "WBTemperature.h"
#import "TPTStateCacheTool.h"
#import "TPTool.h"

@interface TPBaseViewController (){
    BabyBluetooth *baby;
    NSTimer *_timer;     //定时器
}
@property (nonatomic,strong)NSMutableArray *valueArray; //温度数组
@property (nonatomic,strong)NSMutableArray *timeArray;  //时间数组
@property (nonatomic,strong)NSString *staticTemp;//默认正常状态

@end

@implementation TPBaseViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setInViewWillAppear];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    //停止之前的连接
//    [baby cancelAllPeripheralsConnection];
//    //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态。
    baby.scanForPeripherals().begin();
}

-(void)viewDidLoad{
    [super viewDidLoad];

    //背景图片
    [self.view addSubview:self.bgimageView];

    UIBarButtonItem *left_navigationItem = [[UIBarButtonItem alloc]initWithCustomView:self.navbackButton];
    
    UIBarButtonItem *right_navigationItem = [[UIBarButtonItem alloc]initWithCustomView:self.navrightButton];
    UIBarButtonItem *right_navigationbluetoothItem = [[UIBarButtonItem alloc]initWithCustomView:self.navBluetoothView];
    
    self.navigationItem.leftBarButtonItem = left_navigationItem;
    self.navigationItem.rightBarButtonItems = @[right_navigationItem,right_navigationbluetoothItem];
    self.navigationItem.titleView = self.navTitleLable;

    self.staticTemp = @"0";
    [self loadBabayBluetooth]; //蓝牙
    [self createTimer];

}

-(void)clickLeftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickRightBarButtonItem{

    NSLog(@"分享到相册");

    [self screenShare];
}


#pragma mark 分享
-(void)shareReftList{

    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"shareImg.png"]];
    //    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {

        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"宝宝手环很好用"
                                         images:imageArray
                                            url:[NSURL URLWithString:@"http://13686095026876.gw.1688.com"]
                                          title:@"宝宝手环"
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
         ];

    }
}

/**
 *  屏幕截图分享
 */
- (void)screenShare
{
    /**
     * 使用ShareSDKExtension插件可以实现屏幕截图分享，对于原生界面和OpenGL的游戏界面同样适用
     * 通过使用SSEShareHelper可以调用屏幕截图分享方法，在方法的第一个参数里面可以取得截图图片和分享处理入口，只要构造分享内容后，将要分享的内容和平台传入分享处理入口即可。
     *
     * 小技巧：
     * 当取得屏幕截图后，如果shareHandler入口不满足分享需求（如截取屏幕后需要弹出分享菜单而不是直接分享），可以不调用shareHandler进行分享，而是在block中写入自定义的分享操作。
     * 这样的话截屏分享接口实质只充当获取屏幕截图的功能。
     **/

    __weak TPBaseViewController *theController = self;
    [SSEShareHelper screenCaptureShare:^(SSDKImage *image, SSEShareHandler shareHandler) {

        if (!image)
        {
            //如果无法取得屏幕截图则使用默认图片
            image = [[SSDKImage alloc] initWithImage:[UIImage imageNamed:@"shareImg.png"] format:SSDKImageFormatJpeg settings:nil];
        }

       [image getNativeImage:^(UIImage *image) {
           NSLog(@"image === %@",image);

           image = [image thumbnailWithImageWithoutScale:image size:self.view.bounds.size];

           NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
           [shareParams SSDKSetupShareParamsByText:@"宝宝手环很好用"
                                            images:@[image]
                                               url:[NSURL URLWithString:@"http://13686095026876.gw.1688.com"]
                                             title:@"宝宝手环"
                                              type:SSDKContentTypeAuto];
           //2、分享（可以弹出我们的分享菜单和编辑界面）
           [ShareSDK showShareActionSheet:theController.view //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
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
            
            ];
       }];
            } onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
    }];
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
    //    NSString *tempStr =[NSString stringWithFormat:@"%f",arc4random()%7+35+0.46];
    //    self.rotateDials.value = tempStr;
    //    [self.valueArray addObject:tempStr];
    //
    //    [self showAlarm:[tempStr floatValue]];
    //
    //    NSString *timeStr =[TPTool getCurrentDate];
    //    int tempTimeInt = [TPTool getCurrentTimeIntDate];
    //    [self.timeArray addObject:timeStr];
    //
    //    if (self.valueArray.count>chartMaxNum) {
    //        //默认为正序遍历
    //        [self.valueArray removeObjectAtIndex:0];
    //    }
    //    if (self.timeArray.count>chartMaxNum) {
    //        //默认为正序遍历
    //        [self.timeArray removeObjectAtIndex:0];
    //    }
    //    self.chart.valueArray = self.valueArray;
    //    self.chart.timeArray = self.timeArray;
    //
    //    //记录所有数据
    //    WBTemperature *temp = [[WBTemperature alloc] init];
    //    temp.create_time = tempTimeInt;
    //    temp.temp = tempStr.floatValue;
    //    [WBCacheTool addTemperature:temp];
    //
    //    //记录提醒数据
    //    NSString *getTemp = [TPTool getCurrentTempState:tempStr];
    //    if (![getTemp isEqualToString:@"-1"]) {
    //        if (![self.staticTemp isEqualToString:getTemp]) {
    //            WBTemperature *temp = [[WBTemperature alloc] init];
    //            temp.create_time = tempTimeInt;
    //            temp.temp = tempStr.floatValue;
    //            temp.temp_state = getTemp;
    //            [TPTStateCacheTool addTemperature:temp];
    //            self.staticTemp = getTemp;
    //        }
    //    }
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

    baby.having(self.currPeripheral).and.channel(channelOnPeropheralView).then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
}


//蓝牙网关初始化和委托方法设置
-(void)babyDelegate{

    __weak typeof(self) weakSelf = self;
    __weak BabyBluetooth  *weakbaby = baby;

    BabyRhythm *rhythm = [[BabyRhythm alloc]init];

    [baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBCentralManagerStatePoweredOn) {
            NSLog(@"设备打开成功，开始扫描设备");
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
        NSLog(@"设备：%@--连接成功",peripheral);
        [SVProgressHUD showInfoWithStatus:@"设备连接成功"];
        weakSelf.navBluetoothView.hidden = NO;
    }];

    //设置设备连接失败的委托
    [baby setBlockOnFailToConnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--连接失败",peripheral.name);
         [weakbaby AutoReconnect:peripheral];
    }];

    [baby setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--断开连接",peripheral.name);
        weakSelf.navBluetoothView.hidden = YES;
        [SVProgressHUD showErrorWithStatus:@"设备已断开连接"];
         [weakbaby AutoReconnect:peripheral];
        [TPTool deviceCutUpalyAlart]; //设备断开警报
//        [weakSelf loadData];
    }];

//    //设置设备断开连接的委托
//    [baby setBlockOnDisconnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
//        NSLog(@"设备：%@--断开连接",peripheral.name);
//        weakSelf.navBluetoothView.hidden = YES;
//        [SVProgressHUD showErrorWithStatus:@"设备已断开连接"];
//         [weakbaby AutoReconnect:peripheral];
//        [TPTool deviceCutUpalyAlart]; //设备断开警报
//        [weakSelf loadData];
//    }];

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
            NSLog(@"订阅一个值");
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

//    Byte dataArray[] = {0xFC,0x02,0x00,0x02,0xED};
//    NSData *data = [NSData dataWithBytes:dataArray length:sizeof(dataArray)/sizeof(dataArray[0])];
//    NSLog(@"data = %@",data);
//
//    if (characteristic) {
//        [self.currPeripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
//    }
//    NSLog(@"charact = %@ ,current = %@",characteristic.UUID,self.currPeripheral.name);
}
//订阅一个值
-(void)setNotifiy:(CBCharacteristic *)characteristic{

//    __weak typeof(self)weakSelf = self;
//    if(self.currPeripheral.state != CBPeripheralStateConnected) {
//
//        NSLog(@"peripheral已经断开连接，请重新连接");
//        //        [SVProgressHUD showErrorWithStatus:@"peripheral已经断开连接，请重新连接"];
//        return;
//    }
//    if (characteristic.properties & CBCharacteristicPropertyNotify ||  characteristic.properties & CBCharacteristicPropertyIndicate) {
//
//        if(characteristic.isNotifying) {
//            [baby cancelNotify:self.currPeripheral characteristic:characteristic];
//            NSLog(@"通知");
//        }else{
//            [weakSelf.currPeripheral setNotifyValue:YES forCharacteristic:characteristic];
//            NSLog(@"取消通知");
//            [baby notify:self.currPeripheral
//          characteristic:characteristic
//                   block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
//                       NSLog(@"通知的值 new value %@",characteristics.value);
//                       NSData * data = characteristic.value;
//                       Byte * resultByte = (Byte *)[data bytes];
//
//                       NSString *currentElec =[NSString stringWithFormat:@"%u",resultByte[5]];
//
//                       if (![NSString isNull:currentElec]) {
//                           UserModel.temp_currentElec = currentElec;
//                       }
//                       //温度
//                       NSString *aa =[NSString stringWithFormat:@"%u.%u",resultByte[3],resultByte[4]];
//
//                       CGFloat tempfloats = [aa floatValue] + [UserModel.temp_check floatValue];
//
//                       self.rotateDials.value = [NSString stringWithFormat:@"%.1f",tempfloats];
//                       [self.valueArray addObject:aa];
//
//                       [weakSelf showAlarm:tempfloats];
//
//                       NSString *timeStr =[TPTool getCurrentDate];
//                       int tempTimeInt = [TPTool getCurrentTimeIntDate];
//                       [self.timeArray addObject:timeStr];
//
//                       if (self.valueArray.count>chartMaxNum) {
//                           //默认为正序遍历
//                           [self.valueArray removeObjectAtIndex:0];
//                       }
//                       if (self.timeArray.count>chartMaxNum) {
//                           //默认为正序遍历
//                           [self.timeArray removeObjectAtIndex:0];
//                       }
//                       self.chart.valueArray = self.valueArray;
//                       self.chart.timeArray = self.timeArray;
//                       //记录所有数据
//                       WBTemperature *temp = [[WBTemperature alloc] init];
//                       temp.create_time = tempTimeInt;
//                       temp.temp = [aa floatValue];
//                       [WBCacheTool addTemperature:temp];
//
//                       //记录提醒数据
//                       NSString *getTemp = [TPTool getCurrentTempState:aa];
//                       if (![getTemp isEqualToString:@"-1"]) {
//                           if (![self.staticTemp isEqualToString:getTemp]) {
//                               WBTemperature *temp = [[WBTemperature alloc] init];
//                               temp.create_time = tempTimeInt;
//                               temp.temp = aa.floatValue;
//                               temp.temp_state = getTemp;
//                               [TPTStateCacheTool addTemperature:temp];
//                               self.staticTemp = getTemp;
//                           }
//                       }
//
//                   }];
//        }
//    }
//    else{
//        [SVProgressHUD showErrorWithStatus:@"这个characteristic没有nofity的权限"];
//        return;
//    }
}

#pragma mark 警报
-(void)showAlarm:(CGFloat)temp{

    //播放警报
    [TPTool palyAlartTempFloat:temp];
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
                    NSLog(@"data11 = %@",data);
                    [self.currPeripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
                }
            }
        }
    }
}


#pragma mark 蓝牙
- (IBAction)clickBluetoothSender:(UIButton *)sender {

//    if (self.currPeripheral) {
//
//        for(CBService *service in self.currPeripheral.services)
//        {
//            if([service.UUID isEqual:[CBUUID UUIDWithString:kServiceUUID]])
//            {
//                for(CBCharacteristic *characteristic in service.characteristics)
//                {
//                    if([characteristic.UUID isEqual:[CBUUID UUIDWithString:kCharacteristicWriteUUID]])
//                    {
//                        [self writeValue:characteristic];
//                    }
//                }
//            }
//        }
//    }
}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"backBabyBlue" object:nil];
}

-(UIImageView *)bgimageView{
    if (!_bgimageView) {
        _bgimageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _bgimageView.image = [UIImage imageNamed:@"main_bg"];
        
    }
    return _bgimageView;
}

-(UIButton *)navbackButton{
    if (!_navbackButton) {
        _navbackButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        [_navbackButton setImage:[UIImage imageNamed:@"navigation_back"] forState:UIControlStateNormal];
        [_navbackButton addTarget:self action:@selector(clickLeftBarButtonItem) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navbackButton;
}

-(UIButton *)navrightButton{
    if (!_navrightButton) {
        _navrightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        [_navrightButton setImage:[UIImage imageNamed:@"navigation_share"] forState:UIControlStateNormal];
        [_navrightButton addTarget:self action:@selector(clickRightBarButtonItem) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navrightButton;
}

-(UIImageView *)navBluetoothView{
    if (!_navBluetoothView) {
        _navBluetoothView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        _navBluetoothView.image = [UIImage imageNamed:@"navigation_bluetooth"];
        _navBluetoothView.hidden = YES;
    }
    return _navBluetoothView;
}



-(UILabel *)navTitleLable{
    if (!_navTitleLable) {
        _navTitleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,120, 44)];
        _navTitleLable.textAlignment = NSTextAlignmentCenter;
        _navTitleLable.textColor = MainTitleColor;
        _navTitleLable.font = [UIFont systemFontOfSize:17];
    }
    return _navTitleLable;
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
