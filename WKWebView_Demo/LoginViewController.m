//
//  LoginViewController.m
//  DrivePP
//
//  Created by admin on 2017/12/18.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "LoginViewController.h"
#import "TabBarViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
    BOOL result;
    NSString *_identifierForVendor;
    NSString *requestUrl;
    NSString *workingId;
    NSString *workingName;
    
    NSString *_name;
    NSString *_password;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KLoginPhone];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self createView];
    });
    
    [self setStatusBarBackgroundColor:KColorTitle];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoNotification:) name:@"userInfoNotification" object:nil];

    NSUserDefaults *userDefaults =  [NSUserDefaults standardUserDefaults];
    NSLog(@"KLoginCount===%@",[userDefaults objectForKey:KLoginCount]);
    NSLog(@"passwordTF====%@,缓存中登入密码：%@",self.passwordTF.text,[userDefaults objectForKey:KPassword]);
    NSLog(@"state==%ld",[[userDefaults objectForKey:@"state"] integerValue]);
    NSLog(@"_isPasswordBtn.currentImage 1==%@",_isPasswordBtn.currentImage);

    if (![[userDefaults objectForKey:KLoginCount] isEqualToString:@""] || ![[userDefaults objectForKey:KPassword] isEqualToString:@""]) {

        _name = [userDefaults objectForKey:KLoginCount];
        _password = [userDefaults objectForKey:KPassword];

    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.userNameTF.text = _name;
        self.passwordTF.text = _password;
    });
    [self getIdentifierForVendor];
}
//获取identifierForVendor 手机唯一标识
- (void)getIdentifierForVendor{
    _identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    NSLog(@"identifierForVendor == %@",_identifierForVendor);//identifierForVendor == C3CD4312-884B-464A-96F8-A713F6B86612
}
//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}
- (void)createView{
    
    UIView *navigationView = [[UIView alloc]init];
    navigationView.backgroundColor = KColorTitle;
    [self.view addSubview:navigationView];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"登 录";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:20 weight:5];
    titleLabel.textColor = [UIColor whiteColor];
    [navigationView addSubview:titleLabel];
    

    
    UIView *headView = [[UIView alloc]init];
    [self.view addSubview:headView];
    
    self.bottomView = [[UIView alloc]init];
    [self.view addSubview:self.bottomView];
    
    //手机号
    UILabel *phoneLabel = [[UILabel alloc]init];
    phoneLabel.text = @"手机号:";
    phoneLabel.font = [UIFont systemFontOfSize:16];
    phoneLabel.textColor = [UIColor blackColor];
    phoneLabel.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:phoneLabel];
    
    self.userNameTF = [[UITextField alloc]init];
    self.userNameTF.placeholder = @"请输入手机号";
    self.userNameTF.font = [UIFont systemFontOfSize:14];
    self.userNameTF.delegate = self;
    self.userNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [headView addSubview:self.userNameTF];
    
    UIView *lineViewOne = [[UIView alloc]init];
    lineViewOne.backgroundColor = [UIColor grayColor];
    lineViewOne.alpha = 0.5;
    [headView addSubview:lineViewOne];
    
    
    //密码
    UILabel *passwordLabel = [[UILabel alloc]init];
    passwordLabel.text = @"密 码:";
    passwordLabel.font = [UIFont systemFontOfSize:16];
    passwordLabel.textColor = [UIColor blackColor];
    passwordLabel.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:passwordLabel];
    
    self.passwordTF = [[UITextField alloc]init];
    self.passwordTF.placeholder = @"请输入密码";
    self.passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTF.font = [UIFont systemFontOfSize:14];
    self.passwordTF.delegate = self;
    [headView addSubview:self.passwordTF];
    
    UIView *lineViewTwo = [[UIView alloc]init];
    lineViewTwo.backgroundColor = [UIColor grayColor];
    lineViewTwo.alpha = 0.5;
    [headView addSubview:lineViewTwo];
    //    //密码是否可见
    //    UIButton *eyeBtn = [[UIButton alloc]init];
    //    [eyeBtn setImage:[UIImage imageNamed:@"ic_article_read_.png"] forState:UIControlStateNormal];
    //    [eyeBtn addTarget:self action:@selector(eyesBtn:) forControlEvents:UIControlEventTouchUpInside];
    //    [headView addSubview:eyeBtn];
#pragma mark -- 是否记住密码
    NSUserDefaults *userDefaults =  [NSUserDefaults standardUserDefaults];
    _isPasswordBtn = [[UIButton alloc]init];
    [_isPasswordBtn addTarget:self action:@selector(isPasswordBtnBtn:) forControlEvents:UIControlEventTouchUpInside];
    if ([[userDefaults objectForKey:@"state"] integerValue]==1) {
        NSLog(@"记住密码");
        _isPasswordBtn.selected = YES;
        [_isPasswordBtn setImage:[UIImage imageNamed:@"TICK.png"] forState:UIControlStateNormal];
        
        
    }else{
        
        NSLog(@"不记住密码");
        [_isPasswordBtn setImage:[UIImage imageNamed:@"TICK_.png"] forState:UIControlStateNormal];
        
    }
    [headView addSubview:_isPasswordBtn];
    NSLog(@"_isPasswordBtn.currentImage==%@",_isPasswordBtn.currentImage);

    
    UILabel *memberPWLabel = [[UILabel alloc]init];
    memberPWLabel.text = @"记住密码";
    memberPWLabel.font = [UIFont systemFontOfSize:13];
    memberPWLabel.textColor = [UIColor blackColor];
    memberPWLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(isPasswordTapBtn:)];
    [memberPWLabel addGestureRecognizer:tap];
    [headView addSubview:memberPWLabel];
    
#pragma mark -- 登入按钮
    UIButton *loginBtn = [[UIButton alloc]init];
    loginBtn.layer.cornerRadius = 5;
    [loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [loginBtn setBackgroundColor:KColorBtn];
    [loginBtn addTarget:self action:@selector(loginBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    //    [self.view insertSubview:loginBtn belowSubview:self.centerInstrctView];
    
    UILabel *companyNameLabel = [[UILabel alloc]init];
    companyNameLabel.textAlignment = NSTextAlignmentCenter;
    companyNameLabel.text = KCompanyName;
    companyNameLabel.font = [UIFont systemFontOfSize:14];
    companyNameLabel.textColor = [UIColor blackColor];
    [self.view addSubview:companyNameLabel];
    
    
    self.versionLabel = [[UILabel alloc]init];
    self.versionLabel.textAlignment = NSTextAlignmentCenter;
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.versionLabel.text = [NSString stringWithFormat:@"版本号：%@",app_Version];
    self.versionLabel.font = [UIFont systemFontOfSize:13];
    self.versionLabel.textColor = [UIColor blackColor];
    [self.view addSubview:self.versionLabel];
    
    
    KWS(ws);
    //导航栏
    [navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view).offset(KStatusBarHeight);
        make.left.equalTo(ws.view).offset(0);
        make.right.equalTo(ws.view).offset(0);
        make.height.mas_equalTo(44);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navigationView).offset(11);
        make.left.equalTo(navigationView).offset(100);
        make.right.equalTo(navigationView).offset(-100);
        make.height.mas_equalTo(20);
    }];
    
    //账号登入内容体
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view).offset(KStatusBarHeight+44+20);
        make.left.equalTo(ws.view).offset(10);
        make.right.equalTo(ws.view).offset(-10);
        make.height.mas_equalTo(135);
    }];
    
    
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_top).offset(10);
        make.left.equalTo(headView.mas_left).offset(10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
    
    [self.userNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_top).offset(10);
        make.left.equalTo(phoneLabel.mas_right).offset(10);
        make.right.equalTo(headView.mas_right).offset(-10);
        make.height.mas_equalTo(30);
    }];
    
    [lineViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneLabel.mas_bottom).offset(10);
        make.left.equalTo(headView.mas_left).offset(0);
        make.right.equalTo(headView.mas_right).offset(0);
        make.height.mas_equalTo(1);
        
    }];
    
    [passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineViewOne.mas_bottom).offset(10);
        make.left.equalTo(headView.mas_left).offset(10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
    
    [self.passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineViewOne.mas_bottom).offset(10);
        make.left.equalTo(passwordLabel.mas_right).offset(10);
        make.right.equalTo(headView.mas_right).offset(-10);
        make.height.mas_equalTo(30);
        
    }];
    
    [lineViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordLabel.mas_bottom).offset(10);
        make.left.equalTo(headView.mas_left).offset(0);
        make.right.equalTo(headView.mas_right).offset(0);
        make.height.mas_equalTo(1);
    }];
    
    [_isPasswordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineViewTwo.mas_bottom).offset(10);
        make.left.equalTo(headView).offset(0);
        make.height.width.mas_equalTo(15);
        
    }];
    
    [memberPWLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineViewTwo.mas_bottom).offset(8);
        make.left.equalTo(_isPasswordBtn.mas_right).offset(2);
        make.right.equalTo(headView.mas_right).offset(-2);
        make.height.width.mas_equalTo(20);
        
    }];

    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_bottom).offset(15);
        make.left.equalTo(ws.view).offset(10);
        make.right.equalTo(ws.view).offset(-10);
        make.height.mas_equalTo(40);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginBtn.mas_bottom).offset(15);
        make.left.equalTo(ws.view).offset(10);
        make.right.equalTo(ws.view).offset(-10);
        make.height.mas_equalTo(40);
    }];
    
  
    
    
    [companyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.versionLabel.mas_top).offset(-10);
        make.left.equalTo(ws.view).offset(50);
        make.right.equalTo(ws.view).offset(-50);
        make.height.mas_equalTo(15);
        
    }];
    
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.view.mas_bottom).offset(-20);
        make.left.equalTo(ws.view).offset(100);
        make.right.equalTo(ws.view).offset(-100);
        make.height.mas_equalTo(20);
        
    }];
    
    
   
}
//是否记住密码事件
- (void)isPasswordBtnBtn:(UIButton*)sender{
    
    sender.selected = !sender.selected;
    NSLog(@"%@",sender.selected?@"YES":@"NO");
    NSString *flag = sender.selected?@"YES":@"NO";
    
    NSUserDefaults *userDefaults =  [NSUserDefaults standardUserDefaults];
    
    if ([flag isEqualToString:@"YES"]) {
        //选中记住密码
        //        [_isPasswordBtn setImage:[UIImage imageNamed:@"TICK_.png"] forState:UIControlStateNormal];
        [_isPasswordBtn setImage:[UIImage imageNamed:@"TICK.png"] forState:UIControlStateSelected];
        
        [userDefaults setBool:_isPasswordBtn.selected forKey:@"state"];
        [userDefaults setObject:self.passwordTF.text forKey:KPassword];
        [userDefaults synchronize];
        
    }
    else {
        //选中不记住密码
        [_isPasswordBtn setImage:[UIImage imageNamed:@"TICK_.png"] forState:UIControlStateNormal];
        
        [userDefaults removeObjectForKey:@"state"];
        [userDefaults setBool:_isPasswordBtn.selected forKey:@"state"];
        [userDefaults removeObjectForKey:KPassword];
        [userDefaults synchronize];
        
    }
    
    NSLog(@"state===%@,KPassword==%@",[userDefaults objectForKey:@"state"],[userDefaults objectForKey:KPassword]);
    
}
//是否记住密码事件
- (void)isPasswordTapBtn:(UITapGestureRecognizer*)sender{
    
    _isPasswordBtn.selected = !_isPasswordBtn.selected;
    NSLog(@"%@",_isPasswordBtn.selected?@"YES":@"NO");
    NSString *flag = _isPasswordBtn.selected?@"YES":@"NO";
    
    NSUserDefaults *userDefaults =  [NSUserDefaults standardUserDefaults];
    
    if ([flag isEqualToString:@"YES"]) {
        //选中记住密码
        //        [_isPasswordBtn setImage:[UIImage imageNamed:@"TICK_.png"] forState:UIControlStateNormal];
        [_isPasswordBtn setImage:[UIImage imageNamed:@"TICK.png"] forState:UIControlStateSelected];
        
        [userDefaults setBool:_isPasswordBtn.selected forKey:@"state"];
        [userDefaults setObject:self.passwordTF.text forKey:KPassword];
        [userDefaults synchronize];
        
    }
    else {
        //选中不记住密码
        [_isPasswordBtn setImage:[UIImage imageNamed:@"TICK_.png"] forState:UIControlStateNormal];
        
        [userDefaults removeObjectForKey:@"state"];
        [userDefaults setBool:_isPasswordBtn.selected forKey:@"state"];
        [userDefaults removeObjectForKey:KPassword];
        [userDefaults synchronize];
        
    }
    
    NSLog(@"state===%@,KPassword==%@",[userDefaults objectForKey:@"state"],[userDefaults objectForKey:KPassword]);
    
}

#pragma mark -- 密码登入
//登入按钮功能
- (void)loginBtn:(id)sender{
    if ([self.userNameTF.text isEqualToString:@""] || [self.passwordTF.text isEqualToString:@""]) {
        result = NO;
        [self alertTile:@"" contentMesg:@"账号或密码不能为空"];
        
    } else{
        result = YES;
    }
    
    if (result) {
        
        NSUserDefaults *userDefaults =  [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:self.userNameTF.text forKey:KLoginCount];
        
        if ([[userDefaults objectForKey:@"state"] integerValue]==1) {
            NSLog(@"记住密码");
            _isPasswordBtn.selected = YES;
            [_isPasswordBtn setImage:[UIImage imageNamed:@"TICK.png"] forState:UIControlStateNormal];
            [userDefaults setObject:self.passwordTF.text forKey:KPassword];
            [userDefaults synchronize];
            
            
        } else {
            NSLog(@"不记住密码");
            [_isPasswordBtn setImage:[UIImage imageNamed:@"TICK_.png"] forState:UIControlStateNormal];
            [userDefaults removeObjectForKey:KPassword];
            [userDefaults synchronize];
        }

        requestUrl = @"http://106.14.143.199:9080/Receive.aspx";
        workingId = @"KJ";
        workingName = @"框架";
        NSString *loginType = @"0";
        NSLog(@"11--requestUrl=====%@,workingId:%@,workingName:%@",requestUrl,workingId,workingName);
        NSString *requestName = @"RequestLogin";
//        NSString *deviceToken = [[NSUserDefaults standardUserDefaults]objectForKey:KDeviceToken];
        /*
         //密码使用MD5加密
         NSString *pw = [self md5:self.passwordTF.text];
         NSLog(@"加密后的密码串：%@",pw);
         */
        //            NSDictionary *dicData =@{@"LoginPhone":self.userNameTF.text,@"Password":pw,@"GesturePwd":@"",@"PopedomVer":@"10",@"WorkingId":workingId,@"DeviceTokens":deviceToken};
        //TsPadID ：设备号deviceToken
        
        NSDictionary *dicData =@{@"LoginPhone":self.userNameTF.text,@"PassWord":self.passwordTF.text,@"GesturePwd":@"",@"PopedomVer":@"10",@"WorkingId":workingId,@"DeviceTokens":@"DH20170710001",@"LoginType":loginType,@"HRCode":@"",@"IMEI":_identifierForVendor};
        NSLog(@"dicData:=====%@",dicData);
        //GZIP的压缩
        NSString *postStr = [LFCGzipUtility gzipDicData:dicData];
        NSLog(@"GZIP的压缩postStr=====%@",postStr);
        
        [[HttpRequest sharedInstance]postWithURLString:requestUrl requestName:requestName parameters:postStr success:^(id responseObject)
         {
             
             
             NSDictionary *dictionary =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
             //后台返回的gzip压缩的字符串
             NSString *original = [dictionary objectForKey:@"GZipStr"];
             NSLog(@"后台返回的gzip压缩的字符串==%@",original);
             
             //GZip解压
             NSDictionary *json = [LFCGzipUtility uncompressZippedStr:original];
             NSLog(@"backdic--------------------%@",json);
             
             NSString *msg = [json objectForKey:@"Rtn_Msg"];
             NSLog(@"---------请求是否成功-----------%@",msg);
             if ([[json objectForKey:@"Rtn_Code"] isEqualToString:@"0"]) {
                 
                 NSDictionary *callBackData = [json objectForKey:@"Rtn_Data"];
                 NSMutableDictionary *mutDicBackData = [[NSMutableDictionary alloc]initWithDictionary:callBackData];
                 [userDefaults setObject:mutDicBackData forKey:@"Rtn_Data"];
                 [userDefaults synchronize];
                 
                 //缓存头像
                 NSString *userImgUrl = callBackData[@"FactorImg"];
                 if (!KIsBlankString(userImgUrl)) {
                     NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:userImgUrl]];
                     NSString *base64Encoded = [data base64EncodedStringWithOptions:0];
                     [MFTool setStringWithKey:KUserImg value:base64Encoded];
                 }
                 //缓存登入账号
                 NSString *loginCount = callBackData[@"HRCode"];
                 [MFTool setStringWithKey:KLoginCount value:loginCount];
                 NSLog(@"登入账号==%@",loginCount);
                 //缓存用户名
                 NSString *userName = callBackData[@"RoleName"];
                 [MFTool setStringWithKey:@"userName" value:userName];
                 //缓存手机号
                 NSString *mobilePhone = callBackData[@"MobilePhone"];
                 [MFTool setStringWithKey:KLoginPhone value:mobilePhone];
                 NSLog(@"手机号==%@",mobilePhone);
                 //跳转
                 TabBarViewController *tabBarVC = [[TabBarViewController alloc]init];
                 [self presentViewController:tabBarVC animated:YES completion:^{
                     
                 }];
//
                 
             } else {
                 [self alertTile:@"登入失败" contentMesg:msg];
                 
             }
             
             
             
             
         } failure:^(NSError *error) {
             NSLog(@"--------------------请求失败");
         } showHUD:self.view];
    }
        

}

- (void)alertTile:(NSString*)Titlestr contentMesg:(NSString*)message{
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:Titlestr message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:nil];
    [alertControl addAction:ok];
    
    [self presentViewController:alertControl animated:YES completion:nil];
}
    
@end
