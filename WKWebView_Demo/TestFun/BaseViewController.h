//
//  WKTwoViewController.h
//  WKWebView
//
//  Created by admin on 2017/12/29.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeakScriptMessageDelegate.h" //代理
//网络请求
#import "LFCGzipUtility.h"
#import "HttpRequest.h"
//扫描
#import "QRCodeVC.h"
//语音读报
#import <AVFoundation/AVFoundation.h>
#import <Speech/Speech.h>
//高德定位
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
@interface BaseViewController : UIViewController

/** 是否显示Nav */
@property (nonatomic,assign) BOOL isNavHidden;
//高德定位
@property (nonatomic, strong) AMapLocationManager *locationManager;
/**
 设置持续定位开启地址描述返回：
 注意：在海外地区是没有地址描述返回的，地址描述只在中国国内返回。
 
 *  持续定位是否返回逆地理信息，默认NO。
 
 */
@property (nonatomic, assign) BOOL locatingWithReGeocode;

@property(nonatomic,strong)WKWebViewConfiguration *config;
- (void)initWKWebView:(NSString *)html;

@property(nonatomic,strong)NSString *order;//扫描单号
- (void)HeadImageLocalStorge;
- (void)loginLocalStorge;


@end
