//
//  Define.h
//  LoveLimit
//
//  Created by  on 17/3/3.
//  Copyright (c) 2017年 . All rights reserved.
//

#ifndef LoveLimit_Define_h
#define LoveLimit_Define_h

#pragma mark --------------------------- 自定义通用配置
#define KNSLogFun NSLog(@"%s",__func__);
//启动页轮播图片设置
#define KPictureName @[@"ad1",@"ad2",@"ad3"]
//登入首页中公司名称的设置
#define KCompanyName @"上海步步亿佰科技有限公司"
//机构设置的显示与隐藏 YES/NO
#define KIstructHide YES
//注册忘记密码的显示与隐藏 YES/NO
#define KRegLoginHide NO
//标签栏上的图片和标题设置
#define KTabBarImages @[@"01@2x.png",@"02@2x.png"]
#define KTabBarTitles @[@"业务",@"我的"]
//标签栏上导航栏上的标题设置
#define KMainNavigationTitle @"业务操作"
#define KMyNavigationTitle @"个人中心"
//技术支持页
#define KTECHuRL @"http://www.bubu100.com"
#pragma mark --------------------------- 接口相关
//公钥（客户编号）
#define KClientCode @"CSYJ"
//APP类型
#define KSysType @"CSYJ"
//api接口
#define KLoginUrl @"http://106.14.143.199:9080/Receive.aspx"
//新用户注册的时候是否需要隐藏角色：YES/NO
#define KIsHideRole NO

#pragma mark ----------------- 系统相关
#define KWS(ws) __weak typeof(&*self) ws=self
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height
#define kH_Height KScreenHeight/19
#define SPACE_X KScreenHeight/35
#define KRate (KScreenWidth/320.0)
#define KLeftNavBar @"left_nav_bar"
#define KRightNavBar @"right_nav_bar"

#pragma mark -------------------- 颜色相关
#define KColorRGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define KColorRGB(r,g,b) KColorRGBA(r,g,b,1)
//灰色label的颜色
#define KColorGrayLabel KColorRGB(115,115,115)
//设置导航栏背景的颜色
//#define KColorTitle KColorRGB(0,0,0)
#define KColorTitle KColorRGB(55,61,65)
//蓝色按钮
#define KColorBtn KColorRGB(3,162,245)

#define KColorBacground KColorRGB(239,238,244)


#pragma mark ---------------------------  我的通用键值
//缓存的登入业务参数
#define KDataCacheName @"Rtn_Data"
//缓存菜单业务参数
#define KMenuList @"MenuList"
//缓存机构对象
#define KInstrcutCompany @"instrctURLKey"
//请求接口网址
//#define KLoginRequestUrl @"loginRequestUrl"
#define KLoginRequestUrl @"http://106.14.143.199:9080/Receive.aspx"
//用户个人信息相关缓存键值
#define KLoginCount @"loginCount"
#define KLoginPhone @"loginPhone"
#define KUserName @"userName"
#define KPassword @"password"
#define KUserImg @"userImage"
#define KDeviceToken @"deviceToken"
//默认用户头像
#define KMyHeadImg @"head2.jpg"

//判断一个字符串是否为空
#define KIsBlankString(str)  [MFTool isBlankString:str]

//获取状态栏高度
#define KStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
//适配iPhone x 底栏高度,标签栏高度
#define KTabbarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)

#define IS_iOS9 [[UIDevice currentDevice].systemVersion floatValue] >= 9.0f

#endif

