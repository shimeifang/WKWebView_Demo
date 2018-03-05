//
//  MyViewController.m
//  WorkFrameDemo
//
//  Created by admin on 2017/11/13.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "MyViewController.h"


#import "MySetViewController.h"
#import "LoginViewController.h"
//#import "MessageViewController.h"
#import "ModifyPersonViewController.h"



#define KDiscoverTitle @"KDisCoverTitle"
#define KDiscoverImageName @"KDiscoverImageName"

@interface MyViewController ()<sendHeadDataDelegate>

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationItem.title = @"个人中心";
//    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
//    [rightBtn setTitle:@"开发-总公司" forState:UIControlStateNormal];
//    [rightBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
//    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
//    self.navigationItem.rightBarButtonItem = btnItem;
    
    
    
}
- (void)configUI{
    [super configUI];
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, KStatusBarHeight, KScreenWidth, 200+KStatusBarHeight)];
    headView.backgroundColor = KColorTitle;
    [self.view addSubview:headView];

    
    //设置头像
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth/2-40, 30, 80, 80)];
    [headView addSubview:_imageView];
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.cornerRadius = 40;
    _imageView.layer.borderWidth = 3.0f;
    _imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    NSString *base64Image = [MFTool getStringWithKey:KUserImg];
    if (KIsBlankString(base64Image)) {
        _imageView.image = [UIImage imageNamed:KMyHeadImg];
    } else {
        _imageView.image = [MFTool getImageWithBase64:base64Image];
    }
    _imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBtn:)];
    [_imageView addGestureRecognizer:tap];
    NSLog(@"%@,%@",[MFTool getStringWithKey:KUserName],[MFTool getStringWithKey:KLoginPhone]);
    //设置用户名
    if (KIsBlankString([MFTool getStringWithKey:KUserName])) {
        _userName = @"";
    } else {
        _userName = [MFTool getStringWithKey:KUserName];
    }

    _userLabel = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth/2-100, 120, 200, 20)];
    _userLabel.text = [NSString stringWithFormat:@"Hi,%@",_userName];
    _userLabel.textColor = [UIColor whiteColor];
    _userLabel.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:_userLabel];
    UITapGestureRecognizer *tapuserLabel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBtn:)];
    [_userLabel addGestureRecognizer:tapuserLabel];
    
    UIImageView *imagView = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth/2-150, 150, 300, 1)];
    imagView.image = [UIImage imageNamed:@"transverse_line"];
    [headView addSubview:imagView];
    
    //电话号码
    if (KIsBlankString([MFTool getStringWithKey:KLoginPhone])) {
        _phoneNum = @"";
    } else {
        _phoneNum = [MFTool getStringWithKey:KLoginPhone];
    }
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth/2-100, 160, 200, 20)];
    phoneLabel.text = _phoneNum;
    phoneLabel.textColor = [UIColor whiteColor];
    phoneLabel.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:phoneLabel];
    
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 200+KStatusBarHeight, KScreenWidth, KScreenHeight-200-49-20-KStatusBarHeight) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePersonInfo:) name:@"personInfo" object:nil];
    
}
- (void)changePersonInfo:(NSNotification*)notification{
    NSLog(@"%@",notification.userInfo);
    //@{@"headImage":self.imageStr,@"userName":self.username};
    NSString *imageHead = notification.userInfo[@"headImage"];
    NSString *userName = notification.userInfo[@"userName"];
    self.imgStr = imageHead;
    if (KIsBlankString(imageHead)) {
        
    } else {
        NSData *_decodedImageData   = [[NSData alloc] initWithBase64EncodedString:self.imgStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
        _imageView.image = [UIImage imageWithData:_decodedImageData];
    }
    
    _userName = userName;
    _userLabel.text = _userName;

}
#pragma mark -- 更换头像
- (void)tapBtn:(UITapGestureRecognizer*)tap{
    NSLog(@"您点击了头像");
    ModifyPersonViewController *vc = [ModifyPersonViewController new];
    vc.delegate = self;
    //在push的时候隐藏底部tabbar
    vc.hidesBottomBarWhenPushed=YES;
//    [self.navigationController pushViewController:vc animated:YES];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
    
}

#pragma mark -- 加载数据源
- (void)loadData{
    [super loadData];
    /*
     @{KDiscoverImageName:@"Update_cache",
     KDiscoverTitle:@"更新缓存"},
     @{KDiscoverImageName:@"px",
     KDiscoverTitle:@"功能管理"},@{KDiscoverImageName:@"fj",
     KDiscoverTitle:@"派送区域查询"},
     
     */
    NSArray *array=@[@{KDiscoverImageName:@"sz",KDiscoverTitle:@"设置"}];
    NSArray *array2=@[@"退出登录"];
    
    [_dataArray addObject:array];
    [_dataArray addObject:array2];
    
    [_tableView reloadData];
    
    
    
}

- (void)leftClick:(UIButton *)btn{
    
}

- (void)rightBtnClick:(UIButton *)btn{
    NSLog(@"%s",__func__);
}
#pragma mark tableView的代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return [_dataArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section<_dataArray.count-1) {
        static NSString *cellId = @"cell";
        JLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[JLTableViewCell alloc]initWithStyle:JLTableViewCellStyleValue1 reuseIdentifier:cellId];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        NSDictionary *dic = _dataArray[indexPath.section][indexPath.row];
        cell.leftImageView.image = [UIImage imageNamed:dic[KDiscoverImageName]];
        cell.leftLabel.text = dic[KDiscoverTitle];
        
        return cell;
        
    }else{
        static NSString *cellId = @"cell2";
        JLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[JLTableViewCell alloc]initWithStyle:JLTableViewCellStyleValue3 reuseIdentifier:cellId];
            
        }
        cell.middLabel.text = _dataArray[indexPath.section][indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section<_dataArray.count-1) {
        NSString *titile=_dataArray[indexPath.section][indexPath.row][KDiscoverTitle];
        
//        if ([titile isEqualToString:@"消息"]) {
//            MessageViewController *vc=[MessageViewController new];
//            vc.title=titile;
//            //在push的时候隐藏底部tabbar
//            vc.hidesBottomBarWhenPushed=YES;
//            UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:vc];
////            [navVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
//            [self presentViewController:navVC animated:YES completion:nil];
////            [self.navigationController pushViewController:vc animated:YES];
////            [self presentViewController:vc animated:YES completion:nil];
//        }
       
        if ([titile isEqualToString:@"设置"]) {
            MySetViewController *vc=[MySetViewController new];
            vc.title=titile;
            //在push的时候隐藏底部tabbar
            vc.hidesBottomBarWhenPushed=YES;
            UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:vc];
//             [navVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [self presentViewController:navVC animated:YES completion:nil];
//            [self.navigationController pushViewController:vc animated:YES];
//             [self presentViewController:vc animated:YES completion:nil];
        }
       
        
    }else {
        NSString *titile=_dataArray[indexPath.section][indexPath.row];
        if ([titile isEqualToString:@"退出登录"]) {
            [self alertTile:@"" contentMesg:@"是否退出登录？"];
        }
    }
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)alertTile:(NSString*)Titlestr contentMesg:(NSString*)message{
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:Titlestr message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }];
    [alertControl addAction:ok];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertControl addAction:cancel];
    
    [self presentViewController:alertControl animated:YES completion:nil];
}
#pragma mark -- 头像、用户名代理
- (void)sendDataImage:(NSString *)imageHead sendUserName:(NSString *)userName{
    NSLog(@"1111111111111111111111------%@,%@",userName,imageHead);
    self.imgStr = imageHead;
    if (KIsBlankString(imageHead)) {
        
    } else {
        NSData *_decodedImageData   = [[NSData alloc] initWithBase64EncodedString:self.imgStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
        _imageView.image = [UIImage imageWithData:_decodedImageData];
    }
   
    _userName = userName;
    _userLabel.text = _userName;

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
