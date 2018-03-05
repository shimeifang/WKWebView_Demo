//
//  QRCodeVC.h
//  shikeApp
//
//  Created by 淘发现4 on 16/1/7.
//  Copyright © 2016年 淘发现1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
@protocol sendDataDelegate <NSObject>

- (void)sendOrders:(NSArray*)arr;

- (void)sendOrder:(NSString*)order;

@end

@interface QRCodeVC : UIViewController


@property (nonatomic) BOOL lastResut; //表示是否是第一次扫描成功

@property (nonatomic) BOOL repeatScan; //表示是否连扫

@property(nonatomic)BOOL isnull;//判断扫描结果是否有最新值

@property(nonatomic,assign)id<sendDataDelegate> delegate;

@property(nonatomic,strong)NSString *agrso;//参数1连扫还是单扫

@property(nonatomic,strong)NSString *agrst;

@property(nonatomic,strong)NSString *agrisnot;//新增 判断运单号不存在是否添加进入

@property(nonatomic,strong)NSDictionary *dicstr;

@property(nonatomic,strong)NSString *Rtn_Code;

@property(nonatomic,strong)NSString *ip;
@property(nonatomic,strong)NSString *port;
@property(nonatomic,strong)NSString *OrgId;
@property(nonatomic,strong)NSString *OrgCode;
@property(nonatomic,strong)NSString *phone;
@property(nonatomic,strong)NSString *passsword;


@end
