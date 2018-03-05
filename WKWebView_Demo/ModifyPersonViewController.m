//
//  ModifyPersonViewController.m
//  WorkFrameDemo
//
//  Created by admin on 2017/4/17.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "ModifyPersonViewController.h"

#import "HeadViewController.h"
//#import "UserNameViewController.h"


@interface ModifyPersonViewController ()<sendImageDataDelegate>
{
    NSString *_imageDataStr;
    NSString *_userName;
    UIImage *_decodedImage;
    
}
@end

@implementation ModifyPersonViewController

- (void)viewWillAppear:(BOOL)animated{

   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self addBtnWithTitle:nil withBgImageName:@"buttonbar_back" withLocation:KLeftNavBar];
    self.navigationItem.title = @"个人信息";
    [self createUI];
    [self loadData];
    
    
    NSLog(@"%@",self.username);
    //头像
    NSString *base64Image = [MFTool getStringWithKey:KUserImg];
    if (KIsBlankString(base64Image)) {
        _decodedImage = [UIImage imageNamed:KMyHeadImg];
    } else {
        _decodedImage = [MFTool getImageWithBase64:base64Image];
    }
   
    //设置用户名
    if (KIsBlankString([MFTool getStringWithKey:KUserName])) {
        _userName = @"";
    } else {
        _userName = [MFTool getStringWithKey:KUserName];
    }
    
    self.headImage = _decodedImage;
    self.username = _userName;
    
    NSNotificationCenter *notiCent = [NSNotificationCenter defaultCenter];
    [notiCent addObserver:self selector:@selector(sendUserName:) name:self.username object:nil];
}

- (void)createUI{
    self.automaticallyAdjustsScrollViewInsets=NO;
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-49) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
}
-(void)addBtnWithTitle:(NSString *)title withBgImageName:(NSString *)bgName withLocation:(NSString *)location{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    UIImage *image = [UIImage imageNamed:bgName];
    btn.frame=CGRectMake(0, 0, image.size.width, image.size.height);
    //    btn.frame=CGRectMake(0, 10, 24, 24);
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
  //  NSLog(@"%@,%@",self.imageStr,self.username);
   //点击头像传值
    if ([self.delegate respondsToSelector:@selector(sendDataImage:sendUserName:)]) {
        [self.delegate sendDataImage:self.imageStr sendUserName:self.username];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    //设置到个人信息中返回传值
    if (!KIsBlankString(self.imageStr)&&!KIsBlankString(self.username)) {
        NSDictionary *dic = @{@"headImage":self.imageStr,@"userName":self.username};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"personInfo" object:nil userInfo:dic];
    }
    if (!KIsBlankString(self.imageStr)) {
        NSDictionary *dic = @{@"headImage":self.imageStr};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"personInfo" object:nil userInfo:dic];
    }
    if (!KIsBlankString(self.username)) {
         NSDictionary *dic = @{@"userName":self.username};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"personInfo" object:nil userInfo:dic];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)rightClick:(UIButton*)btn{
    NSLog(@"点击右导航栏按钮");
    
}
- (void)loadData{
    //    [_dataArray removeAllObjects];
    _dataArray = [[NSMutableArray alloc]init];
    
    NSArray *array1=@[@"头像",@"昵称"];
    
    [_dataArray addObject:array1];
    
    [_tableView reloadData];
    
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
    if (indexPath.row==0 ) {
        return 60;
    } else {
        return 45;
    }
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    JLTableViewCellStyleValue2,//左边一个label，右边一个label
    //    JLTableViewCellStyleSubtitle//左边一个label，右边一个imageView
    static NSString *cellId = @"cell";
    JLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (indexPath.row==0) {
        cell = [[JLTableViewCell alloc]initWithStyle:JLTableViewCellStyleSubtitle reuseIdentifier:cellId];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.leftLabel.text = _dataArray[indexPath.section][indexPath.row];
        
        cell.rightImageView.image = _decodedImage;
        
    } else {
        cell = [[JLTableViewCell alloc]initWithStyle:JLTableViewCellStyleValue2 reuseIdentifier:cellId];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.leftLabel.text = _dataArray[indexPath.section][indexPath.row];
        //            cell.rightLabel.text = _userName;
        cell.rightLabel.text = self.username;
        
    }
    
    //    if (!cell) {
    //        if (indexPath.row==0) {
    //            cell = [[JLTableViewCell alloc]initWithStyle:JLTableViewCellStyleSubtitle reuseIdentifier:cellId];
    //            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //            cell.leftLabel.text = _dataArray[indexPath.section][indexPath.row];
    //
    //
    ////            NSData *_decodedImageData   = [[NSData alloc] initWithBase64Encoding:_imageDataStr];
    ////            _decodedImage      = [UIImage imageWithData:_decodedImageData];
    ////
    ////            NSLog(@"===Decoded image size: %@", NSStringFromCGSize(_decodedImage.size));
    //
    //            cell.rightImageView.image = self.headImage;
    //
    //        } else {
    //            cell = [[JLTableViewCell alloc]initWithStyle:JLTableViewCellStyleValue2 reuseIdentifier:cellId];
    //            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //            cell.leftLabel.text = _dataArray[indexPath.section][indexPath.row];
    ////            cell.rightLabel.text = _userName;
    //            cell.rightLabel.text = self.username;
    //
    //        }
    //
    //    }
    
    return cell;
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld,%ld",(long)indexPath.section,(long)indexPath.row);
    
    
    NSString *titile=_dataArray[indexPath.section][indexPath.row];
    
    if ([titile isEqualToString:@"头像"]) {
        HeadViewController *vc=[HeadViewController new];
        vc.title=titile;
        vc.imgStr = _decodedImage;
        vc.delegate = self;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([titile isEqualToString:@"昵称"]) {

//        UserNameViewController *vc = [UserNameViewController new];
//        vc.title=titile;
//        vc.userName = self.username;
//        NSLog(@"1====%@",self.username);
//        vc.delegate = self;
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
        [self alertTile:@"" contentMesg:@"该昵称不能被修改"];


    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (void)alertTile:(NSString*)Titlestr contentMesg:(NSString*)message{
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:Titlestr message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:nil];
    [alertControl addAction:ok];
    
    [self presentViewController:alertControl animated:YES completion:nil];
}
#pragma mark -- 代理传值
- (void)sendDataImage:(NSString *)imageHead{
    KNSLogFun
    self.imageStr = imageHead;
    NSData *_decodedImageData   = [[NSData alloc] initWithBase64EncodedString:self.imageStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
    _decodedImage      = [UIImage imageWithData:_decodedImageData];
  
//    NSLog(@"===Decoded image size: %@", NSStringFromCGSize(_decodedImage.size));
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self loadData];
        
    });
}

- (void)sendUserName:(NSString *)userName{
    self.username = userName;
    NSLog(@"2-1用户名====%@",self.username);
    //    [self loadData];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self loadData];
        
    });
    
}

- (UIImage *) dataURL2Image: (NSString *) imgSrc
{
    NSURL *url = [NSURL URLWithString: imgSrc];
    NSData *data = [NSData dataWithContentsOfURL: url];
    UIImage *image = [UIImage imageWithData: data];
    
    return image;
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
