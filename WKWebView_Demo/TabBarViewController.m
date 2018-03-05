//
//  TabBarViewController.m
//  DrivePP
//
//  Created by admin on 2017/12/18.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "TabBarViewController.h"
#import "MainViewController.h"
#import "MyViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = KColorBacground;
    MainViewController * first = [[MainViewController alloc]init];

    MyViewController * my = [[MyViewController alloc]init];

    NSArray * views = @[first,my];
    NSMutableArray * navArr = [NSMutableArray array];
    NSArray * titleArr = KTabBarTitles; //标签栏上标题设置
   
    for (int i = 0; i < views.count; i++) {
        
        UITabBarItem * item = [[UITabBarItem alloc]initWithTitle:titleArr[i] image:[UIImage imageNamed:[NSString stringWithFormat:@"rgb%02d_normal",i+1]] tag:10+i];
        item.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"rgb%02d_selected",i+1]];
        UIViewController * view = views[i];
        view.tabBarItem = item;
        
        //        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:view];
        [navArr addObject:view];
    }
    self.viewControllers = navArr;
    self.tabBar.translucent = NO;
    
    //跳转到对应的页面
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *loginPhone = [userDefaults objectForKey:KDataCacheName][@"LoginPhone"];
    
  
    
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
