//
//  MySetViewController.m
//  WorkFrameDemo
//
//  Created by admin on 17/3/1.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "MySetViewController.h"

#import "SetPasswordViewController.h"
#import "ModifyPersonViewController.h"

//测试
#import "ThreeViewController.h"

@interface MySetViewController ()

@end

@implementation MySetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"设置";
    [self addBtnWithTitle:@"" withBgImageName:@"buttonbar_back" withLocation:KLeftNavBar];
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
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (void)rightClick:(UIButton*)btn{
    NSLog(@"点击右导航栏按钮");

}
- (void)configUI{
    [super configUI];
    
}

- (void)loadData{
    [super loadData];
   
   
//    NSArray *array1=@[@"个人信息",@"手机号",@"手机通讯录",@"添加联系人电话",@"H5调原生功能",@"修改密码",@"关于我们",@"UIWebView",@"webNetRequest"];
 
    NSArray *array1=@[@"个人信息",@"修改密码",@"JS与OC互调"];
//    NSArray *array2=@[@"新消息通知"];
    [_dataArray addObject:array1];
//    [_dataArray addObject:array2];
   
   
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

        static NSString *cellId = @"cell";
        JLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[JLTableViewCell alloc]initWithStyle:JLTableViewCellStyleValue1 reuseIdentifier:cellId];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.leftLabel.text = _dataArray[indexPath.section][indexPath.row];
        return cell;


}

#pragma mark Switch
//
//- (void)tableSwitchPressed:(UISwitch*)sender
//{
//    //是否启用消息推送 0是，1否
//    NSString *onNum;
//    if (sender.on){
////        NSLog(@"tableSwitchPressed ON");
//        onNum = @"0";
//        _pushSwitch.on = YES;
//    }
//    else{
////        NSLog(@"tableSwitchPressed OFF");
//         onNum = @"1";
//        _pushSwitch.on = NO;
//    }
//
//
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    [userDefault removeObjectForKey:@"IsEnablePushMes"];
//    [userDefault setObject:onNum forKey:@"IsEnablePushMes"];
//    [userDefault synchronize];
//
//    //网络请求接口
//    NSString *requestName = @"RequestUpdateUserInfo";
//
//    NSString *requestUrl = KLoginRequestUrl;
//    NSLog(@"requestUrl=====%@",requestUrl);
//
//    NSUserDefaults *userDefaults =  [NSUserDefaults standardUserDefaults];
//    NSString *userPhone = [userDefaults objectForKey:KLoginPhone];
//    NSLog(@"userPhone==========%@",userPhone);
//    NSDictionary *dicData =@{@"LoginPhone":userPhone,@"UserName":@"",@"UserImg":@"",@"IsEnablePushMes":onNum};
//    NSLog(@"请求业务参数：=====%@",dicData);
//    //GZIP的压缩
//    NSString *postStr = [LFCGzipUtility gzipDicData:dicData];
//    NSLog(@"GZIP的压缩postStr=====%@",postStr);
//    [[HttpRequest sharedInstance]postWithURLString:requestUrl requestName:requestName parameters:postStr success:^(id responseObject) {
//
//        NSDictionary *dictionary =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//        //后台返回的gzip压缩的字符串
//        NSString *original = [dictionary objectForKey:@"GZipStr"];
//        NSLog(@"后台返回的gzip压缩的字符串==%@",original);
//
//        //GZip解压
//        NSDictionary *json = [LFCGzipUtility uncompressZippedStr:original];
//        NSLog(@"backdic--------------------%@",json);
//
//        NSString *msg = [json objectForKey:@"Rtn_Msg"];
//        NSLog(@"---------请求是否成功-----------%@",msg);
//        if ([[json objectForKey:@"Rtn_Code"] isEqualToString:@"0"]){
//
//            NSLog(@"请求成功");
//
//        }else{
//             NSLog(@"请求失败");
//
//        }
//
//    } failure:^(NSError *error) {
//        NSLog(@"--------------------请求失败");
//    } showHUD:self.view];
//
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   // NSLog(@"========%ld,%ld",(long)indexPath.section,(long)indexPath.row);
    NSString *titile=_dataArray[indexPath.section][indexPath.row];
    if ([titile isEqualToString:@"个人信息"]) {
        ModifyPersonViewController *vc=[ModifyPersonViewController new];
        vc.title=titile;
        UIBarButtonItem * bar = [[UIBarButtonItem alloc]initWithTitle:@""style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem = bar;
        [self.navigationController pushViewController:vc animated:YES];
    }
//    if ([titile isEqualToString:@"修改手机号"]) {
//        ModifyPhoneViewController *vc=[ModifyPhoneViewController new];
//        vc.title=titile;
//
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//    if ([titile isEqualToString:@"手势密码"]) {
//        //自定义通讯录
//        GesturesPasswordViewController *vc=[GesturesPasswordViewController new];
//
//        vc.hidesBottomBarWhenPushed = YES;
//         vc.title=titile;
//        [self.navigationController pushViewController:vc animated:YES];
//
//    }
//
    if ([titile isEqualToString:@"修改密码"]) {
        SetPasswordViewController *vc=[SetPasswordViewController new];
        vc.title=titile;

        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([titile isEqualToString:@"JS与OC互调"]) {
        ThreeViewController *vc=[ThreeViewController new];
        //vc.title=titile;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }
//    if ([titile isEqualToString:@"关于我们"]) {
//        AboutUsViewController *vc=[AboutUsViewController new];
//        //vc.title=titile;
//
//        [self.navigationController pushViewController:vc animated:YES];
//
//    }
//
//    if ([titile isEqualToString:@"UIWebView"]) {
//        H5LoadViewController *vc=[H5LoadViewController new];
//        //vc.title=titile;
//        //        [self presentViewController:vc animated:YES completion:nil];
//        [self.navigationController pushViewController:vc animated:YES];
//
//    }
//    if ([titile isEqualToString:@"webNetRequest"]) {
//        NetRequestViewController *vc=[NetRequestViewController new];
//        vc.title=titile;
//
//        [self.navigationController pushViewController:vc animated:YES];
//
//    }
//    if ([titile isEqualToString:@"SKViewController"]) {
//        SKViewController *vc=[SKViewController new];
//        vc.title=titile;
//
//        [self.navigationController pushViewController:vc animated:YES];
//
//    }
//    if ([titile isEqualToString:@"消息"]) {
//        MessageViewController *vc=[MessageViewController new];
//        vc.title=titile;
//
//        [self.navigationController pushViewController:vc animated:YES];
//    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark --ContactsUI CNContactPickerDelegate

#pragma mark --ContactsUI
//- (void)createContactUI{
//    
//    if (IS_iOS9) {
//        _contactPickerVC = [[CNContactPickerViewController alloc]init];
//        _contactPickerVC.delegate = self;
//        
//        [self presentViewController:_contactPickerVC animated:YES completion:nil];
//        
//    } else {
//        ABPeoplePickerNavigationController *peoplePickController = [[ABPeoplePickerNavigationController alloc] init];
//        peoplePickController.peoplePickerDelegate = self;
//        [self presentViewController:peoplePickController animated:YES completion:^{
//            
//        }];
//    }
//    
//}
//
//
//#pragma mark --ContactsUI CNContactPickerDelegate
////http://blog.csdn.net/mamong/article/details/49623051
//
//// 注意:如果实现该方法，上面那个方法就不能实现了，这两个方法只能实现一个
//- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty{
//    
//    [self printContactInfo:contactProperty.contact];
//}
//
//- (void)printContactInfo:(CNContact *)contact{
//    NSString *phoneStr;
//    NSString *givenName = contact.givenName;
//    NSString *familyName = contact.familyName;
//    NSLog(@"givenName=%@, familyName=%@", givenName, familyName);
//    //    NSString *name = [NSString stringWithFormat:@"%@%@",familyName,givenName];
//    NSArray *phoneNumbers = contact.phoneNumbers;
//    //     NSLog(@"====phoneNumbers=%@", phoneNumbers);
//    NSMutableArray *mutArr = [[NSMutableArray alloc]init];
//    
//    for (CNLabeledValue<CNPhoneNumber*> *phone in phoneNumbers) {
//        NSString *label = phone.label;
//        CNPhoneNumber *phonNumber = (CNPhoneNumber *)phone.value;
//        NSLog(@"label=%@, value=%@", label, phonNumber.stringValue);
//        phoneStr = phonNumber.stringValue;
//        
//        [mutArr addObject:phoneStr];
//        NSString *phone = [NSString stringWithFormat:@"tel:%@",phoneStr];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
//        
//    }
//    
//    
//}
//
//#pragma mark -- iOS 8 调用通讯录
//
////第一个只进入到列表。第二个可以进入到具体的属性页面。就是到这来点号码后会被调用 ;只能实现二选一
//- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier NS_AVAILABLE_IOS(8_0){
//    ABMultiValueRef valuesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
//    CFStringRef telValue = ABMultiValueCopyValueAtIndex(valuesRef,0);
//    NSString *phone = (__bridge NSString *)telValue;
//    NSLog(@"----iOS 8 调用通讯录-----%@",phone);
//    NSString *phoneNum = [NSString stringWithFormat:@"tel:%@",phone];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNum]];
//   }
//
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}




@end
