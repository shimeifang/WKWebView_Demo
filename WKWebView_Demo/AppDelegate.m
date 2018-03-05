//
//  AppDelegate.m
//  DrivePP
//
//  Created by admin on 2017/12/18.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "TabBarViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self setTop];
//    LoginViewController *loginVC = [[LoginViewController alloc]init];
        TabBarViewController *loginVC = [[TabBarViewController alloc]init];
    self.window.rootViewController = loginVC;
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        NSLog(@"111");
    }];
    
    return YES;
}
-(void)setTop{
    //设置状态栏的字体颜色
    /*
     UIStatusBarStyleDefault 默认状态 字体是黑色 适用于背景是浅色调
     UIStatusBarStyleLightContent 字体是白色 适用于背景是深色调
     */
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    
    //只要出现UINavigationBar，自己不去修改的情况下就是下面设置的样式
    UINavigationBar *navigationBar=[UINavigationBar appearance];
    //设置navigationBar的颜色
    navigationBar.barTintColor=[UIColor colorWithRed:(55)/255.0 green:(61)/255.0 blue:(65)/255.0 alpha:1];
    /*
     当translucent = YES，controller中self.view的原点是从导航栏左上角开始计算
     当translucent = NO，controller中self.view的原点是从导航栏左下角开始计算
     */
    //导航半透明化会有一层白色的蒙层，所以我将代码修改，关闭了导航的半透明化
    navigationBar.translucent = NO;
    //设置navigationBar的渲染色
    navigationBar.tintColor=[UIColor whiteColor];
    /*设置navigationBar的title的属性
     NSForegroundColorAttributeName 设置字体颜色
     NSFontAttributeName 设置字体的font
     */
    navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
