//
//  SetPasswordViewController.m
//  WorkFrameDemo
//
//  Created by admin on 2017/10/31.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "SetPasswordViewController.h"
#import "LoginViewController.h"

@interface SetPasswordViewController ()<UITextFieldDelegate>
{
    UIButton *regBtn;
    BOOL result; //输入框是否有值
    BOOL isAgree;//两次输入密码是否一致
    BOOL isOld;//原密码是否正确
    
    NSString *oldPass;
}
@end

@implementation SetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = KColorBacground;
    self.navigationItem.title = @"修改密码";
    dispatch_async(dispatch_get_main_queue(), ^{
        [self createView];
    });
    
    NSUserDefaults *userDefaults =  [NSUserDefaults standardUserDefaults];
    oldPass = [userDefaults objectForKey:@"password"];
    NSLog(@"oldPass====%@",oldPass);
    
}

- (void)createView{
    UIView *bgView = [[UIView alloc]init];
    [self.view addSubview:bgView];
    //旧密码
    self.oldPWTextField = [[MFTextField alloc]init];
    self.oldPWTextField.placeholder = @"请输入原密码";
    self.oldPWTextField.layer.cornerRadius = 3.0;
    self.oldPWTextField.background = [UIImage imageNamed:@"box_white"];
    [self setLeftViewWithTextField:_oldPWTextField imageName:@"password" setFrame:CGRectMake(0, 0, 20, 20)];//设置左视图
    self.oldPWTextField.font = [UIFont systemFontOfSize:14];
    self.oldPWTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.oldPWTextField.delegate = self;
    [bgView addSubview:self.oldPWTextField];
    
    //新密码
    self.PWNewTextField = [[MFTextField alloc]init];
    self.PWNewTextField.placeholder = @"请输入新密码";
    self.PWNewTextField.layer.cornerRadius = 3.0;
    self.PWNewTextField.background = [UIImage imageNamed:@"box_white"];
    [self setLeftViewWithTextField:_PWNewTextField imageName:@"password" setFrame:CGRectMake(0, 0, 20, 20)];//设置左视图
    self.PWNewTextField.font = [UIFont systemFontOfSize:14];
    self.PWNewTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.PWNewTextField.delegate =self;
    [bgView addSubview:self.PWNewTextField];
    
    //确认输入新密码
    self.aginNewTextField = [[MFTextField alloc]init];
    self.aginNewTextField.placeholder = @"请确认新密码";
    self.aginNewTextField.layer.cornerRadius = 3.0;
    self.aginNewTextField.background = [UIImage imageNamed:@"box_white"];
    [self setLeftViewWithTextField:_aginNewTextField imageName:@"password" setFrame:CGRectMake(0, 0, 20, 20)];//设置左视图
    self.aginNewTextField.font = [UIFont systemFontOfSize:14];
    self.aginNewTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.aginNewTextField.delegate =self;
    [bgView addSubview:self.aginNewTextField];
    
    //注册按钮
    regBtn = [[UIButton alloc]init];
    regBtn.backgroundColor = KColorBtn;
    regBtn.layer.cornerRadius = 5.0;
    [regBtn setTitle:@"确认修改" forState:UIControlStateNormal];
    [regBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [regBtn addTarget:self action:@selector(sureBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:regBtn];
    
    KWS(ws);
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view).offset(10);
        make.left.right.equalTo(ws.view).offset(0);
        make.height.mas_equalTo(160);
    }];
    
    [self.oldPWTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).offset(10);
        make.left.equalTo(bgView.mas_left).offset(10);
        make.right.equalTo(bgView.mas_right).offset(-10);
        make.height.mas_equalTo(40);
    }];
    
    [self.PWNewTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_oldPWTextField.mas_bottom).offset(10);
        make.left.equalTo(bgView.mas_left).offset(10);
        make.right.equalTo(bgView.mas_right).offset(-10);
        make.height.mas_equalTo(40);
    }];
    
    [self.aginNewTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_PWNewTextField.mas_bottom).offset(10);
        make.left.equalTo(bgView.mas_left).offset(10);
        make.right.equalTo(bgView.mas_right).offset(-10);
        make.height.mas_equalTo(40);
    }];
    
    [regBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_bottom).offset(30);
        make.left.equalTo(ws.view.mas_left).offset(10);
        make.right.equalTo(ws.view.mas_right).offset(-10);
        make.height.mas_equalTo(40);
    }];
    
}
-(void)setLeftViewWithTextField:(UITextField *)textField imageName:(NSString *)imageName setFrame:(CGRect)frame{
    
    UIImageView *leftView = [[UIImageView alloc]initWithFrame:frame];
    leftView.image = [UIImage imageNamed:imageName];
    leftView.contentMode = UIControlContentVerticalAlignmentCenter;
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
}
- (void)sureBtn:(UIButton *)btn{
    NSUserDefaults *userDefaults =  [NSUserDefaults standardUserDefaults];
    NSString *userPhone = [userDefaults objectForKey:KLoginPhone];
    //     NSString *userPassword = [userDefaults objectForKey:@"password"];
    NSLog(@"userPhone==========%@",userPhone);
    
    NSString *requestName = @"RequestUpdatePassWord";
    
    NSString *requestUrl = KLoginRequestUrl;
    NSLog(@"requestUrl=====%@",requestUrl);
    
    
    NSString *oldPW = [self md5:self.oldPWTextField.text];
    NSString *newPW = [self md5:self.PWNewTextField.text];
    NSString *pwdType = @"0";
    
    NSLog(@"加密后密码串：=====%@,%@",oldPW,newPW);
    
    //密码是否为空
    if ([self.oldPWTextField.text isEqualToString:@""] || [self.PWNewTextField.text isEqualToString:@""] || [self.aginNewTextField.text isEqualToString:@""]) {
        result = NO;
    }else{
        result = YES;
        if ([self.PWNewTextField.text length]>=6) {
            //原密码是否有误
            if ([self.oldPWTextField.text isEqualToString:oldPass]) {
                isOld = YES;
                
                //两次输入密码是否一致
                if ([self.PWNewTextField.text isEqualToString:self.aginNewTextField.text] ){
                    isAgree = YES;
                }else{
                    isAgree = NO;
                }
                
            } else {
                isOld = NO;
            }
            
        } else {
            NSLog(@"密码要大于6位数");
            [self alertTile:@"密码要大于6位数" contentMesg:@""];
        }
        
        
        
        
        
        
    }
    
    if (result) {
        
        if (isOld) {
            
            if (isAgree) {
                
                
                NSDictionary *dicData =@{@"LoginPhone":userPhone,@"PwdType":pwdType,@"OldPassword":self.oldPWTextField.text,@"NewPassword":self.PWNewTextField.text};
                NSLog(@"requestUrl=====%@",dicData);
                //GZIP的压缩
                NSString *postStr = [LFCGzipUtility gzipDicData:dicData];
                NSLog(@"GZIP的压缩postStr=====%@",postStr);

                [[HttpRequest sharedInstance]postWithURLString:requestUrl requestName:requestName parameters:postStr success:^(id responseObject) {
                    
                    NSDictionary *dictionary =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                    //后台返回的gzip压缩的字符串
                    NSString *original = [dictionary objectForKey:@"GZipStr"];
                    NSLog(@"后台返回的gzip压缩的字符串==%@",original);
                    
                    //GZip解压
                    NSDictionary *json = [LFCGzipUtility uncompressZippedStr:original];
                    NSLog(@"backdic--------------------%@",json);
                    
//                    id json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
//                    NSLog(@"--------------------%@",json);
                    NSString *msg = [json objectForKey:@"Rtn_Msg"];
                    NSLog(@"---------请求是否成功-----------%@",msg);
                    if ([[json objectForKey:@"Rtn_Code"] isEqualToString:@"0"]){
                        LoginViewController *login = [[LoginViewController alloc]init];
                        login.passwordTF.text = self.oldPWTextField.text;
                        [self presentViewController:login animated:YES completion:nil];
                        
                        NSLog(@"----%@,%@",self.oldPWTextField.text,login.passwordTF.text);
                        
                        NSUserDefaults *userDefaults =  [NSUserDefaults standardUserDefaults];
                        [userDefaults removeObjectForKey:@"password"];
                        [userDefaults synchronize];
                        
                    }else{
                        [self alertTile:@"" contentMesg:msg];
                    }
                    
                    
                } failure:^(NSError *error) {
                    NSLog(@"--------------------请求失败");
                } showHUD:self.view];
                
            } else {
                [self alertTile:@"新密码不一致" contentMesg:@"请重新输入"];
                
            }
            
            
            
        } else {
            [self alertTile:@"原密码错误" contentMesg:@"请重新输入"];
            
        }
        
        
        
    }else{
        [self alertTile:@"密码不能为空" contentMesg:@"请重新输入"];
        
    }
    
}
- (void)alertTile:(NSString*)Titlestr contentMesg:(NSString*)message{
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:Titlestr message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:nil];
    [alertControl addAction:ok];
    
    [self presentViewController:alertControl animated:YES completion:nil];
}

/**
 * 功能： 判断长度大于6位小于20位并是否同时包含且只有数字和字母
 */
-(BOOL)judgePassWordLegal:(NSString *)text{
    
    BOOL result = false;
    if ([text length] >= 6){
        
        NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:text];
    }
    return result;
}

#pragma mark -- md5加密
- (NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%01x", digest[i]];
    
    return  [output uppercaseString];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
