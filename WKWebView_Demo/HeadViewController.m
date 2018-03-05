//
//  HeadViewController.m
//  WorkFrameDemo
//
//  Created by admin on 2017/4/17.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "HeadViewController.h"

@interface HeadViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation HeadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"选择" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16 weight:5];
    btn.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    UIImage *image = [UIImage imageNamed:@""];
    //    btn.frame=CGRectMake(0, 0, image.size.width, image.size.height);
    btn.frame=CGRectMake(0, 0, 44, 44);
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    
    UIBarButtonItem *bbt = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    [btn addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = bbt;
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 80, KScreenWidth, 300)];
    
    self.imageView.image = self.imgStr;
    
    [self.view addSubview:self.imageView];
    
    
}

- (void)rightClick:(UIButton*)btn{
    [self uploadImage];
}

- (void)uploadImage{
    // 创建并弹出警示框, 选择获取图片的方式(相册和通过相机拍照)
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"" message:@"请选择获取头像方式" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self readImageFormCamera];
        
    }];
    UIAlertAction *formPhonePhoto = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self readImageFormAlbum];
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertControl addAction:takePhoto];
    [alertControl addAction:formPhonePhoto];
    [alertControl addAction:cancel];
    
    [self presentViewController:alertControl animated:YES completion:nil];
}

//从相册中读取照片
- (void)readImageFormAlbum{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //相册类型
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

//拍照
- (void)readImageFormCamera{
    //    判断选择的模式是否为相机模式，如果没有则弹窗警告
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    } else {
        
        //        未检测到摄像头弹出窗口
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"警告" message:@"未检测到摄像头" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertControl addAction:confirm];
        [self presentViewController:alertControl animated:YES completion:nil];
        
    }
}

#pragma mark <UIImagePickerControllerDelegate>

//点击取消按钮调用的方法，picker就是当前被呈现的picker
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    //注意：当写了这个代理方法，我们需要手动在代理方法里面让picker dismiss
    [picker dismissViewControllerAnimated:YES completion:nil];
}


// 图片编辑完成之后触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    if ([info[UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerEditedImage];
        self.imageView.image = image;
        
        [self saveImage:image WithName:KUserImg];
        
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
//保存图片
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    //UIImage -> Base64图片
    NSData *imageData = UIImageJPEGRepresentation(tempImage, 0.6);
    NSString *dataStr = [imageData base64EncodedStringWithOptions:0];
    
    
    //上传服务器
    //网络请求接口
    NSString *requestName = @"RequestUpdateUserInfo";
    
    NSString *requestUrl = KLoginRequestUrl;
    NSLog(@"requestUrl=====%@",requestUrl);
    NSDictionary *dataDic = [MFTool getDicWithKey:KDataCacheName];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userPhone = [userDefaults objectForKey:KLoginPhone];
    NSString *userName = dataDic[@"RoleName"];
    NSLog(@"userPhone:===%@,userName:===%@",userPhone,userName);
    
    NSDictionary *dicData =@{@"LoginPhone":userPhone,@"UserName":userName,@"UserImg":dataStr,@"IsEnablePushMes":@"0"};

    //GZIP的压缩
    NSString *postStr = [LFCGzipUtility gzipDicData:dicData];
    NSLog(@"GZIP的压缩postStr=====%@",postStr);
    [[HttpRequest sharedInstance]postWithURLString:requestUrl requestName:requestName superView:self.view parameters:postStr success:^(id responseObject) {
        
        NSDictionary *dictionary =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        //后台返回的gzip压缩的字符串
        NSString *original = [dictionary objectForKey:@"GZipStr"];
        NSLog(@"后台返回的gzip压缩的字符串==%@",original);
        
        //GZip解压
        NSDictionary *json = [LFCGzipUtility uncompressZippedStr:original];
        NSLog(@"backdic--------------------%@",json);
        
        NSString *msg = [json objectForKey:@"Rtn_Msg"];
        NSLog(@"---------请求是否成功-----------%@",msg);
        if ([[json objectForKey:@"Rtn_Code"] isEqualToString:@"0"]){
            
            NSString *userImgUrl = [json objectForKey:@"Rtn_Data"][@"UserImgUrl"];
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:userImgUrl]];
            NSString *base64Encoded = [data base64EncodedStringWithOptions:0];
            [userDefaults removeObjectForKey:KUserImg];
            [userDefaults setObject:base64Encoded forKey:KUserImg];

            [self.delegate sendDataImage:dataStr];
            [self.navigationController popViewControllerAnimated:YES];

            [userDefaults synchronize];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"--------------------请求失败");
    }];
    
}
- (void)alertTile:(NSString*)Titlestr contentMesg:(NSString*)message{
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:Titlestr message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:nil];
    [alertControl addAction:ok];
    
    [self presentViewController:alertControl animated:YES completion:nil];
}


@end
