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
}

@property (nonatomic,strong)NSMutableArray *valueArray; //温度数组
@property (nonatomic,strong)NSMutableArray *timeArray;  //时间数组
@property (nonatomic,strong)NSString *staticTemp;//默认正常状态
@property (nonatomic,strong)NSTimer *timer;     //定时器
@property (nonatomic,strong)NSTimer *backtimer;     //定时器
@end

@implementation TPBaseViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setInViewWillAppear];
    
    if (!self.currPeripheral) {
         [AppDelegate shareDelegate].baby.scanForPeripherals().begin();
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"backBabyBlue" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"foregroundBabyBlue" object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //    //停止之前的连接
    //    [baby cancelAllPeripheralsConnection];
    //    //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态。
//    [AppDelegate shareDelegate].baby.scanForPeripherals().begin();
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
    
//    [self createTimer];//创建定时器
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
        [shareParams SSDKSetupShareParamsByText:NSLocalizedString(@"app_share_name",@"")
                                         images:imageArray
                                            url:[NSURL URLWithString:@"http://h5.m.taobao.com/awp/core/detail.htm?id=551592826586"]
                                          title:NSLocalizedString(@"app_share_name",@"")
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
        NSLog(@"image2222 === %@",image);
        if (!image)
        {
            //如果无法取得屏幕截图则使用默认图片
            image = [[SSDKImage alloc] initWithImage:[UIImage imageNamed:@"shareImg.png"] format:SSDKImageFormatJpeg settings:nil];
        }
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@""
                                         images:@[image]
                                            url:[NSURL URLWithString:@"http://h5.m.taobao.com/awp/core/detail.htm?id=551592826586"]
                                          title:NSLocalizedString(@"app_share_name",@"")
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
        
//        [image getNativeImage:^(UIImage *image) {            
//            image = [image thumbnailWithImageWithoutScale:image size:self.view.bounds.size];
//            NSArray *picArray = [NSArray arrayWithObject:image];
//            NSLog(@"image111 === %@",image);
//            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//            
//            
//           
//        
//        }];
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
}

#pragma mark 蓝牙
-(void)loadBabayBluetooth{
    
    //app 进入后台调用
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appEnterBackGround) name:@"backBabyBlue" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appEnterForegroundGround) name:@"foregroundBabyBlue" object:nil];
    
    //初始化BabyBluetooth 蓝牙库
    baby = [AppDelegate shareDelegate].baby;
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
        
        [weakSelf performSelector:@selector(loadData) withObject:nil afterDelay:3];
//        [weakSelf loadData]; //连接设备
    }];
    //设置设备连接成功的委托,同一个baby对象，使用不同的channel切换委托回调
    [baby setBlockOnConnectedAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral) {
        NSLog(@"设备：%@--连接成功",peripheral.name);
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.navBluetoothView.hidden = NO;
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"device_connected", @"")];
            
        });
    }];
    
    //设置设备连接失败的委托
    [baby setBlockOnFailToConnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--连接失败",peripheral.name);
        if ([weakSelf.timer isValid]) {
            [weakSelf.timer invalidate];
            weakSelf.timer = nil;
        }
    }];
    
    //断开已经连接设备
    [baby setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"as ========");
        NSLog(@"设备22：%@--断开连接",peripheral.name);
        if ([weakSelf.timer isValid]) {
            [weakSelf.timer invalidate];
            weakSelf.timer = nil;
        }
        weakSelf.navBluetoothView.hidden = YES;
        [TPTool deviceCutUpalyAlart:weakSelf]; //设备断开警报
        
        if (self.readCBCharacteristic.properties & CBCharacteristicPropertyNotify ||  self.readCBCharacteristic.properties & CBCharacteristicPropertyIndicate) {
            
            if(weakSelf.readCBCharacteristic.isNotifying) {
                [weakbaby cancelNotify:weakSelf.currPeripheral characteristic:weakSelf.readCBCharacteristic];
                NSLog(@"通知1------------");
            }
        }
        weakSelf.writeCBCharacteristic = nil;
        weakSelf.readCBCharacteristic = nil;
        weakSelf.currPeripheral= nil;
        
//        [weakbaby cancelAllPeripheralsConnection];
        weakbaby.scanForPeripherals().begin();
    }];
    //设置设备断开连接的委托
    [baby setBlockOnDisconnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        
        NSLog(@"设备11：%@--断开连接",peripheral.name);
        if ([weakSelf.timer isValid]) {
            [weakSelf.timer invalidate];
            weakSelf.timer = nil;
        }
        
        if (self.readCBCharacteristic.properties & CBCharacteristicPropertyNotify ||  self.readCBCharacteristic.properties & CBCharacteristicPropertyIndicate) {
            
            if(weakSelf.readCBCharacteristic.isNotifying) {
                [weakbaby cancelNotify:weakSelf.currPeripheral characteristic:weakSelf.readCBCharacteristic];
                NSLog(@"通知1------------");
            }
        }
        weakSelf.writeCBCharacteristic = nil;
        weakSelf.readCBCharacteristic = nil;
        weakSelf.currPeripheral= nil;
        weakSelf.navBluetoothView.hidden = YES;
        
        [TPTool deviceCutUpalyAlart:weakSelf]; //设备断开警报
//        [weakbaby cancelAllPeripheralsConnection];
        weakbaby.scanForPeripherals().begin();
        
//        [weakbaby AutoReconnect:weakSelf.currPeripheral];
    }];
    
    //设置发现设备的Services的委托
    [baby setBlockOnDiscoverServicesAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, NSError *error) {        
        NSLog(@"service.char = %@",peripheral.services);
        [rhythm beats];
    }];
    //设置发现设service的Characteristics的委托
    [baby setBlockOnDiscoverCharacteristicsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBService *service, NSError *error) {

    }];
    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristicAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        
        if ([characteristics.UUID isEqual:[CBUUID UUIDWithString:kCharacteristicWriteUUID]]) {
            NSLog(@"写入一个值 = %@",characteristics.UUID);
            weakSelf.writeCBCharacteristic = characteristics;
            [weakSelf createTimer];//创建定时器
        }
        if ([characteristics.UUID isEqual:[CBUUID UUIDWithString:kCharacteristicReadUUID]]) {
            NSLog(@"订阅一个值 = %@",characteristics.UUID);
            weakSelf.readCBCharacteristic = characteristics;
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
    [baby setBlockOnDidWriteValueForCharacteristicAtChannel:channelOnPeropheralView block:^(CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"setBlockOnDidWriteValueForCharacteristicAtChannel characteristic:%@ and new value:%@",characteristic.UUID, characteristic.value);
    }];
    
    //设置通知状态改变的block
    [baby setBlockOnDidUpdateNotificationStateForCharacteristicAtChannel:channelOnPeropheralView block:^(CBCharacteristic *characteristic, NSError *error) {
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
}
//订阅一个值
-(void)setNotifiy:(CBCharacteristic *)characteristic{
}

#pragma mark 警报
-(void)showAlarm:(CGFloat)temp{
    //播放警报
    [TPTool palyAlartTempFloat:temp andVC:self];
}

#pragma mark app 进入后台
- (void)appEnterBackGround{
    NSLog(@"蓝牙进入后台调用");
    
    self.backtimer=[NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(writData) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.backtimer forMode:NSDefaultRunLoopMode];
    
//    for(CBService *service in self.currPeripheral.services)
//    {
//        if([service.UUID isEqual:[CBUUID UUIDWithString:kServiceUUID]])
//        {
//            for(CBCharacteristic *characteristic in service.characteristics)
//            {
//                if([characteristic.UUID isEqual:[CBUUID UUIDWithString:kCharacteristicWriteUUID]])
//                {
//                    Byte dataArray[] = {0xFC,0x04,0x01,0x01,0x02,0xED};
//                    NSData *data = [NSData dataWithBytes:dataArray length:sizeof(dataArray)/sizeof(dataArray[0])];
//                    NSLog(@"111data11 = %@",data);
//                    [self.currPeripheral writeValue:data forCharacteristic:self.writeCBCharacteristic type:CBCharacteristicWriteWithResponse];
//                }
//            }
//        }
//    }
}

-(void)writData{
    NSLog(@"111data11 = ");
    Byte dataArray[] = {0xFC,0x04,0x01,0x01,0x02,0xED};
    NSData *data = [NSData dataWithBytes:dataArray length:sizeof(dataArray)/sizeof(dataArray[0])];
    NSLog(@"111data11 = %@",data);
    if (self.writeCBCharacteristic) {
        [self.currPeripheral writeValue:data forCharacteristic:self.writeCBCharacteristic type:CBCharacteristicWriteWithResponse];
    }
}

#pragma mark 返回前台
- (void)appEnterForegroundGround{
    NSLog(@"返回前台");
    if ([self.backtimer isValid]) {
        [self.backtimer invalidate];
        self.backtimer = nil;
    }
    
    if (!self.currPeripheral) {
        [AppDelegate shareDelegate].baby.scanForPeripherals().begin();
    }
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
