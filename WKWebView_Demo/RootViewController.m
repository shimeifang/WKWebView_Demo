//
//  RootViewController.m
//  Frame721
//
//  Created by admin on 17/1/5.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    [self configUI];
   
    
}

-(void)configUI{
     NSLog(@"子类需要重写configUI");
}

-(void)loadData{
    NSLog(@"子类需要重写loadData");
}

-(void)addTitle:(NSString *)title{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    label.textAlignment=NSTextAlignmentCenter;
    label.text=title;
    label.textColor=KColorTitle;
    label.font=[UIFont boldSystemFontOfSize:17];
    self.navigationItem.titleView=label;
}

-(void)addBtnWithTitle:(NSString *)title withBgImageName:(NSString *)bgName withLocation:(NSString *)location{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    UIImage *image = [UIImage imageNamed:bgName];
    btn.frame=CGRectMake(0, 0, image.size.width, image.size.height);
//    btn.frame=CGRectMake(0, 0, 44, 44);
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

- (void)addBtnWithTitles:(NSArray *)titles withBgImageNames:(NSArray *)bgNames withLocation:(NSString *)location{
    
}

-(void)leftClick:(UIButton *)btn{
    NSLog(@"子类需要重写leftClick");
}

-(void)rightClick:(UIButton *)btn{
     NSLog(@"子类需要重写rightClick");
}


@end
