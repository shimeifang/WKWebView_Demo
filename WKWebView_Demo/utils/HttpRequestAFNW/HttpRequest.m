//
//  HttpRequest.m
//  基于AFNetWorking的再封装
//
//  Created by 吴红星 on 16/1/2.
//  Copyright © 2016年 wuhongxing. All rights reserved.
//

#import "HttpRequest.h"
#import "UploadParam.h"
#import "MBProgressHUD+Add.h"

@implementation HttpRequest

static id _instance = nil;
+ (instancetype)sharedInstance {
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (instancetype)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
        AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
        [manager startMonitoring];
        [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                {
                    // 位置网络
                    NSLog(@"位置网络");
                }
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                {
                    // 无法联网
                    NSLog(@"无法联网");
                }
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                {
                    // 手机自带网络
                    NSLog(@"当前使用的是2G/3G/4G网络");
                }
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                {
                    // WIFI
                    NSLog(@"当前在WIFI网络下");
                }
            }
        }];
    });
    return _instance;
}

#pragma mark -- GET请求 --
- (void)getWithURLString:(NSString *)URLString
              parameters:(id)parameters
                 success:(void (^)(id))success
                 failure:(void (^)(NSError *))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    /**
     *  可以接受的类型
     */
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    /**
     *  请求队列的最大并发数
     */
//    manager.operationQueue.maxConcurrentOperationCount = 5;
    /**
     *  请求超时的时间
     */
    manager.requestSerializer.timeoutInterval = 30;
    [manager GET:URLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark -- POST请求 --application/json
//网络请求接口
- (void)postWithURLString:(NSString *)URLString requestName:(NSString *)ServiceName
               parameters:(id)parameters
                  success:(void (^)(id))success
                  failure:(void (^)(NSError *))failure showHUD:(UIView *)showView{
    
    /**
     *  请求的时候给一个转圈的状态
     */
    dispatch_async(dispatch_get_main_queue(), ^{
        if (showView) {
            [MBProgressHUD showProgress:showView];
        }
    });
    
   
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //     manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/html",nil];
    
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMddhhmmss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
//    NSLog(@"dateString:%@",dateString);
    
    NSString *SignedStr = [NSString stringWithFormat:@"%@bubu100",dateString];
    NSString *Signed = [self md5:SignedStr];
//    NSLog(@"Signed====%@",Signed);
    
    
    
    
    
    NSDictionary *pulicDic = @{@"TimeStamp":dateString,@"ClientCode":@"CSYJ",@"Sign":Signed,@"SysType":@"CSYJ",@"Data":parameters,@"ServiceName":ServiceName};
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:pulicDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString * jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];

    NSLog(@"请求串jsonStr=====%@",jsonStr);
    
    [manager POST:URLString parameters:pulicDic progress:^(NSProgress * _Nonnull uploadProgress) {

        //         NSLog(@"uploadProgress:====%f",1.0 * uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
//        NSInteger progress = 1.0 * uploadProgress.completedUnitCount/uploadProgress.totalUnitCount;
//        dispatch_async(dispatch_get_main_queue(), ^{
//        
//            if (showView) {
//                [MBProgressHUD hideHUDForView:showView];
//            }
//            
//        });

        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            if (showView) {
                [MBProgressHUD hideHUDForView:showView];
            }
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            if (showView) {
                
                [MBProgressHUD hideHUDForView:showView];
            }
            
            failure(error);
        }
    }];
    

}

#pragma mark -- 上传头像
- (void)postWithURLString:(NSString *)URLString requestName:(NSString *)ServiceName superView:(UIView*)view
               parameters:(id)parameters
                  success:(void (^)(id))success
                  failure:(void (^)(NSError *))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //     manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/html",nil];
    
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMddhhmmss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSLog(@"dateString:%@",dateString);
    
    NSString *SignedStr = [NSString stringWithFormat:@"%@bubu100",dateString];
    NSString *Signed = [self md5:SignedStr];
    NSLog(@"Signed====%@",Signed);
    
    
    
    
    
    NSDictionary *pulicDic = @{@"TimeStamp":dateString,@"ClientCode":@"CSYJ",@"Sign":Signed,@"SysType":@"CSYJ",@"Data":parameters,@"ServiceName":ServiceName};
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:pulicDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString * jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    //
    NSLog(@"jsonStr=====%@",jsonStr);
    
    [manager POST:URLString parameters:pulicDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"uploadProgress:====%f",1.0 * uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
        NSInteger progress = 1.0 * uploadProgress.completedUnitCount/uploadProgress.totalUnitCount;
        dispatch_async(dispatch_get_main_queue(), ^{
            // 声明一个 UILabel 对象
            UILabel * tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 225, 120, 30)];
            // 设置提示内容
            [tipLabel setText:@"正在上传头像"];
            tipLabel.backgroundColor = [UIColor blackColor];
            tipLabel.layer.cornerRadius = 5;
            tipLabel.layer.masksToBounds = YES;
            tipLabel.textAlignment = NSTextAlignmentCenter;
            tipLabel.textColor = [UIColor whiteColor];
            [view addSubview:tipLabel];
            // 设置时间和动画效果
            [UIView animateWithDuration:4.0 animations:^{
                tipLabel.alpha = 1.0-progress;
                if (tipLabel.alpha==0) {
                    [tipLabel setText:@"上传头像完成"];
                }
            } completion:^(BOOL finished) {
                
                // 动画完毕从父视图移除
                [tipLabel removeFromSuperview];
            }];
        });
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
 }

#pragma mark -- POST/GET网络请求 --
- (void)requestWithURLString:(NSString *)URLString 
                  parameters:(id)parameters
                        type:(HttpRequestType)type
                     success:(void (^)(id))success
                     failure:(void (^)(NSError *))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    switch (type) {
        case HttpRequestTypeGet:
        {
            [manager GET:URLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
        }
            break;
        case HttpRequestTypePost:
        {
            [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
        }
            break;
    }
}

//文件上传
- (void)uploadWithURLString:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success
                    failure:(void (^)(NSError *))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        UIImage *image = [UIImage imageNamed:@"dp.png"];
        NSData *imageData = UIImagePNGRepresentation(image);
       
//        NSURL *filePath = [[NSBundle mainBundle]URLForResource:fullPath withExtension:nil];
        
//        [formData appendPartWithFileURL:filePath name:@"file" fileName:@"fileName" mimeType:@"" error:nil];
        
                [formData appendPartWithFileData:imageData name:@"dp" fileName:@"dp" mimeType:@"image/png"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)uploadWithURLString:(NSString *)URLString requestName:(NSString *)ServiceName parameters:(id)parameters uploadParam:(NSArray<UploadParam *> *)uploadParams success:(void (^)())success failure:(void (^)(NSError *))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
     manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMddhhmmss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSLog(@"dateString:%@",dateString);
    
    NSString *SignedStr = [NSString stringWithFormat:@"%@bubu100",dateString];
    NSString *Signed = [self md5:SignedStr];
    NSLog(@"Signed====%@",Signed);
    
    
    
    
    
    NSDictionary *pulicDic = @{@"TimeStamp":dateString,@"ClientCode":@"CSYJ",@"Sign":Signed,@"SysType":@"CSYJ",@"Data":parameters,@"ServiceName":ServiceName};
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:pulicDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString * jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    //
    NSLog(@"jsonStr=====%@",jsonStr);

    
    [manager POST:URLString parameters:pulicDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (UploadParam *uploadParam in uploadParams) {
            [formData appendPartWithFileData:uploadParam.data name:uploadParam.name fileName:uploadParam.filename mimeType:uploadParam.mimeType];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark - 下载数据
- (void)downLoadWithURLString:(NSString *)URLString parameters:(id)parameters progerss:(void (^)())progress success:(void (^)())success failure:(void (^)(NSError *))failure {
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    NSURLSessionDownloadTask *downLoadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress();
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return targetPath;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (failure) {
            failure(error);
        }
    }];
    [downLoadTask resume];
}


#pragma mark -- md5加密
//md5加密
- (NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  [output uppercaseString];
}


// - (NSString *) md5:(NSString *) input {
//     const char *cStr = [input UTF8String];
//     unsigned char digest[CC_MD5_DIGEST_LENGTH];
//     CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
//
//     NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
//
//     for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
//         [output appendFormat:@"%02x", digest[i]];
//
//      return  [output uppercaseString];
// }

@end
