//
//  LoginViewController.h
//  DrivePP
//
//  Created by admin on 2017/12/18.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property(nonatomic,strong)UIView *bottomView;
@property (strong, nonatomic) UITextField *userNameTF; //手机号账号
@property (strong, nonatomic) UITextField *passwordTF; //密码
@property (strong, nonatomic) UIButton *isPasswordBtn; //是否记住密码
@property (strong, nonatomic) UILabel *companyNameLabel; //公司名称
@property (strong, nonatomic) UILabel *versionLabel; //版本号

@end
