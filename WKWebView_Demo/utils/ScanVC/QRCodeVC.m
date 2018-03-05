//
//  QRCodeVC.m
//  shikeApp
//
//  Created by 淘发现4 on 16/1/7.
//  Copyright © 2016年 淘发现1. All rights reserved.
//

#import "QRCodeVC.h"
#import <AVFoundation/AVFoundation.h>
#import "QRCodeAreaView.h"
#import "QRCodeBacgrouView.h"
#import "UIViewExt.h"

#import "LxxSoundPlay.h"
#import <AudioToolbox/AudioToolbox.h>

#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height

#define result_key @"results"
#define kNotificationChangeValu @"notificationName"

@interface QRCodeVC()<AVCaptureMetadataOutputObjectsDelegate,AVAudioPlayerDelegate>{
    AVCaptureSession * _session;//输入输出的中间桥梁
    QRCodeAreaView *_areaView;//扫描区域视图
    NSString *_newResult; //扫描到新结果
    NSMutableArray *_mutArr;//扫描结果
    NSMutableDictionary *_mutDic;//存放扫描结果
    NSString *_rtncode;
    
    UILabel *_resultCountLabel; //存放扫描个数
    UILabel *_resultLabel;//存放扫描的最后最新值
    
    NSURLSession *_urlSession;
    
    
    
}

@end

@implementation QRCodeVC

-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = @"扫描";
    [self addBtnWithTitle:@"" withBgImageName:@"buttonbar_back" withLocation:KLeftNavBar];
    
    self.repeatScan = NO;
    _lastResut = YES;
    _isnull = YES;
    _mutArr = [[NSMutableArray alloc]init];
    _mutDic = [[NSMutableDictionary alloc]init];
    [self createUI];
    
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized)
    {
        NSLog(@"允许状态");
        
        //设置代理 在主线程里刷新
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        //设置识别区域
        //深坑，这个值是按比例0~1设置，而且X、Y要调换位置，width、height调换位置
        output.rectOfInterest = CGRectMake(_areaView.y/screen_height, _areaView.x/screen_width, _areaView.height/screen_height, _areaView.width/screen_width);
        
        //初始化链接对象
        _session = [[AVCaptureSession alloc]init];
        //高质量采集率
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        
        [_session addInput:input];
        [_session addOutput:output];
        
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        //            要在addOutput之后，否则iOS10会崩溃
        AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
        layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
        layer.frame=self.view.layer.bounds;
        
        [self.view.layer insertSublayer:layer atIndex:0];
        
        //开始捕获
        [_session startRunning];
    }
    else if (authStatus == AVAuthorizationStatusDenied)
    {
        NSLog(@"不允许状态，可以弹出一个alertview提示用户在隐私设置中开启权限");
        
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"请在iPhone的“设置-隐私-相机”选项中，允许物流TT访问你的相机" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertControl addAction:ok];
        [self presentViewController:alertControl animated:YES completion:nil];
        
    }
    else if (authStatus == AVAuthorizationStatusNotDetermined)
    {
        NSLog(@"系统还未知是否访问，第一次开启相机时");
    }
    
    
}
-(void)addBtnWithTitle:(NSString *)title withBgImageName:(NSString *)bgName withLocation:(NSString *)location{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    btn.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    UIImage *image = [UIImage imageNamed:bgName];
    //    btn.frame=CGRectMake(0, 0, image.size.width, image.size.height);
    btn.frame=CGRectMake(0, 10, 24, 24);
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    
    UIBarButtonItem *bbt = [[UIBarButtonItem alloc]initWithCustomView:btn];
    if ([location isEqualToString:KLeftNavBar]) {
        [btn addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = bbt;
    }else if ([location isEqualToString:KRightNavBar]){
        [btn addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = bbt;
    }
}
- (void)leftClick:(UIButton*)btn{
    NSLog(@"点击左导航栏按钮");
     [_session stopRunning];//停止扫描
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)rightClick:(UIButton*)btn{
    NSLog(@"点击右导航栏按钮");
    
}
- (void)createUI{
    //扫描区域
    CGRect areaRect = CGRectMake((screen_width - 218)/2, (screen_height - 218-64-64)/2, 218, 218);
    
    //半透明背景
    QRCodeBacgrouView *bacgrouView = [[QRCodeBacgrouView alloc]initWithFrame:CGRectMake(0, 0-64, screen_width, screen_height)];
    bacgrouView.scanFrame = areaRect;
    [self.view addSubview:bacgrouView];
    
    //设置扫描区域
    _areaView = [[QRCodeAreaView alloc]initWithFrame:areaRect];
    [self.view addSubview:_areaView];
    
    //提示文字
    UILabel *label = [UILabel new];
    label.text = @"将二维码/条码放入框内中心区域开始扫描";
    label.textColor = [UIColor whiteColor];
    label.y = CGRectGetMaxY(_areaView.frame) + 20;
    [label sizeToFit];
    label.center = CGPointMake(_areaView.center.x, label.center.y);
    [self.view addSubview:label];
    
    //是否开启闪光灯
    
    UIButton *flashBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, screen_height-50-64, 100, 30)];
    [flashBtn setTitle:@"开启闪光灯" forState:UIControlStateNormal];
    [flashBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [flashBtn addTarget:self action:@selector(statrFlashing:) forControlEvents:UIControlEventTouchUpInside];
    flashBtn.tag = 0;
    [self.view addSubview:flashBtn];
    
    
    //完成扫描结果后返回
    UIButton *finishScanBtn = [[UIButton alloc]initWithFrame:CGRectMake(screen_width-110, screen_height-50-64, 100, 30)];
    [finishScanBtn setTitle:@"完成扫描" forState:UIControlStateNormal];
    [finishScanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [finishScanBtn addTarget:self action:@selector(overScanButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finishScanBtn];
    
    //返回键
//    UIButton *backbutton = [UIButton buttonWithType:UIButtonTypeCustom];
//    backbutton.frame = CGRectMake(5, 7, 30, 30);
//    [backbutton setBackgroundImage:[UIImage imageNamed:@"prev"] forState:UIControlStateNormal];
//    [backbutton addTarget:self action:@selector(clickBackButton) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc]initWithCustomView:backbutton];
//    self.navigationItem.leftBarButtonItem = btnItem;
    
}

//是否开启闪光灯
- (void)statrFlashing:(UIButton *)sender{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch]) { // 判断是否有闪光灯
            // 请求独占访问硬件设备
            [device lockForConfiguration:nil];
            if (sender.tag == 0) {
                
                sender.tag = 1;
                [device setTorchMode:AVCaptureTorchModeOn]; // 手电筒开
            }else{
                
                sender.tag = 0;
                [device setTorchMode:AVCaptureTorchModeOff]; // 手电筒关
            }
            // 请求解除独占访问硬件设备
            [device unlockForConfiguration];
        }
    }
}

#pragma mark 二维码扫描的回调
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    NSLog(@"%s",__func__);
    
    
    
    _rtncode = @"";
     NSLog(@"self.agrso====%@,self.agrst====%@,dic======%@,isnot=======%@",self.agrso,self.agrst,self.dicstr,self.agrisnot);
    
    if ([self.agrso isEqualToString:@"true"]) {
 #pragma mark -- 连扫
        [_session stopRunning];
        
        if (metadataObjects != nil && [metadataObjects count] > 0) {
            AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
            NSString *result = metadataObj.stringValue;
            BOOL flag = 0;
            //判断重复
            if ([result isEqualToString:self.agrst]) {
                flag = 1;
            }
            else{
                if (_mutArr.count!=0) {
                    for (NSString* order in [_mutArr copy]) {
                        
                        if ([result isEqualToString: order]) {
                            //单号重复
                            flag = 1;
                        }
                    }
                }
            }
            NSLog(@"flag====%d",flag);
            if (flag==1) {
                // 单号重复
                //震动模式
                LxxSoundPlay *playSound =[[LxxSoundPlay alloc]initForPlayingVibrate];
                [playSound play];
                
                [_session startRunning];
                
            }else{
                if ([self validateOrder:result]) {
                    [_mutArr addObject:result];
                    
                      //震动模式
                    LxxSoundPlay *playSound =[[LxxSoundPlay alloc]initForPlayingVibrate];
                    [playSound play];
                    
                    [_mutDic setValue:_mutArr forKey:result_key];
                }else{
                    NSLog(@"运单号格式不正确");
                }
                
                [_session startRunning];
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                    [self addResultToLabel:_mutArr.count result:[_mutArr lastObject]];
            });
           
            
        }
        
        
    } else if ([self.agrso isEqualToString:@"false"]) {
#pragma mark -- 单扫
        if (metadataObjects.count>0) {
            [_session stopRunning];//停止扫描
            [_areaView stopAnimaion];//暂停动画
            
            AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects lastObject];
            NSString *result = metadataObject.stringValue;
            if ([self validateOrder:result]) {
                [self.delegate sendOrder:result];
                
            }else{
                NSLog(@"运单号格式不正确");
            }
            [self clickBackButton];
        }
        
    }
   
    
    
    
}


#pragma mark 扫描结果添加到扫描界面
- (void)addResultToLabel:(NSInteger)count result:(NSString*)result{
   
    NSInteger newCount;
    NSString *newResult;
    if (_isnull && count!=0) {
        _resultCountLabel.text = @"";
        _resultLabel.text = @"";
        NSLog(@"扫描个数1=====%ld,扫描结果1=======%@",(long)count,result);
        //扫描个数
        _resultCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, screen_height-100-64, 80, 30)];
        _resultCountLabel.text = [NSString stringWithFormat:@"%ld",(long)count];
        _resultCountLabel.textAlignment = NSTextAlignmentCenter;
        _resultCountLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:_resultCountLabel];
        
        //扫描
        _resultLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, screen_height-100-64, screen_width-110, 30)];
        _resultLabel.text = result;
        _resultLabel.textAlignment = NSTextAlignmentCenter;
        _resultLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:_resultLabel];
        
        _isnull = NO;
    }else if(count!=0){
        
        _resultCountLabel.text = @"";
        _resultLabel.text = @"";
        
        newCount = count;
        newResult = result;
        NSLog(@"扫描个数2=====%ld,扫描结果2=====%@",(long)newCount,newResult);
        //扫描个数
        _resultCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, screen_height-100-64, 80, 30)];
        _resultCountLabel.text = [NSString stringWithFormat:@"%ld",(long)newCount];
        _resultCountLabel.textAlignment = NSTextAlignmentCenter;
        _resultCountLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:_resultCountLabel];
        
        
        //扫描
        _resultLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, screen_height-100-64, screen_width-110, 30)];
        _resultLabel.text = newResult;
        _resultLabel.textAlignment = NSTextAlignmentCenter;
        _resultLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:_resultLabel];
        
    }
    
    
    
}
//点击完成扫描返回按钮回调
-(void)overScanButton{
    [_session stopRunning];//停止扫描
   
    
    if ([self.delegate respondsToSelector:@selector(sendOrders:)]) {
        [self.delegate sendOrders:[_mutArr copy]];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  正则表达式验证单号
 *
 *  @param mobile 传入单号
 *
 *  @return
 */
- (BOOL)validateOrder:(NSString *)order
{
    
    NSString *orderRegex = @"^(?!-)[a-zA-Z0-9-*]{1,20}";
    NSPredicate *orderTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",orderRegex];
    return [orderTest evaluateWithObject:order];
}

//保存
- (void)savaLocal{
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    [userData setObject:_mutArr forKey:result_key];
    [userData synchronize];
    
}

//点击返回按钮回调
-(void)clickBackButton{
    [_session stopRunning];//停止扫描
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
  
    
}


@end
