//
//  MyViewController.h
//  WorkFrameDemo
//
//  Created by admin on 2017/11/13.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "ListViewController.h"

@interface MyViewController : ListViewController

@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)NSString *imgStr; //头像
@property(nonatomic,strong)UILabel *userLabel;
@property(nonatomic,strong)NSString *userName; //用户名
@property(nonatomic,strong)NSString *phoneNum; //手机号

@end
