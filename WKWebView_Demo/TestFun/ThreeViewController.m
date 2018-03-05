//
//  ThreeViewController.m
//  WKWebView
//
//  Created by admin on 2018/1/4.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "ThreeViewController.h"
#define KPlayVoice @"playVoice"

#define KPlayVoice @"playVoice"
#define SetLocalStorage @"setLocalStorage"
#define GetLocalStorage @"getLocalStorage"
#define RemoveLocalStorage @"removeLocalStorage"
#define KAFNetWorking @"AFNetWorking"
#define KScan @"scan"
#define KOpenContact @"openContact"
#define KAMapLocation @"getLocation"
//图片预览
#define KViewPictrue @"viewPictrue"
//相机拍照
#define KCamera  @"camera"

@interface ThreeViewController ()

@end

@implementation ThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initWKWebView:@"wktwo"];
}

- (void)initWKWebView:(NSString *)html{
    [super initWKWebView:html];
//    [self HeadImageLocalStorge];//获取头像
//    [self loginLocalStorge];//获取登入返回的缓存值
    
  
//     [self.config.userContentController addScriptMessageHandler:[WeakScriptMessageDelegate scriptWithDelegate:self] name:KOpenContact];
//    [self.config.userContentController addScriptMessageHandler:[WeakScriptMessageDelegate scriptWithDelegate:self] name:SetLocalStorage];
//    [self.config.userContentController addScriptMessageHandler:[WeakScriptMessageDelegate scriptWithDelegate:self] name:GetLocalStorage];
//    [self.config.userContentController addScriptMessageHandler:[WeakScriptMessageDelegate scriptWithDelegate:self] name:RemoveLocalStorage];
//    [self.config.userContentController addScriptMessageHandler:[WeakScriptMessageDelegate scriptWithDelegate:self] name:KAFNetWorking];
//    [self.config.userContentController addScriptMessageHandler:[WeakScriptMessageDelegate scriptWithDelegate:self] name:KPlayVoice];
//     [self.config.userContentController addScriptMessageHandler:[WeakScriptMessageDelegate scriptWithDelegate:self] name:KAMapLocation];
     [self.config.userContentController addScriptMessageHandler:[WeakScriptMessageDelegate scriptWithDelegate:self] name:KViewPictrue];
     [self.config.userContentController addScriptMessageHandler:[WeakScriptMessageDelegate scriptWithDelegate:self] name:KCamera];
}

//https://www.jianshu.com/p/6ba2507445e4

//需要注意的是addScriptMessageHandler很容易引起循环引用，导致控制器无法被释放，所以需要加入以下这段：
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.config.userContentController removeScriptMessageHandlerForName:SetLocalStorage];
    [self.config.userContentController removeScriptMessageHandlerForName:GetLocalStorage];
    [self.config.userContentController removeScriptMessageHandlerForName:RemoveLocalStorage];
    [self.config.userContentController removeScriptMessageHandlerForName:KAFNetWorking];
    [self.config.userContentController removeScriptMessageHandlerForName:KPlayVoice];
     [self.config.userContentController removeScriptMessageHandlerForName:KAMapLocation];
//    [self.config.userContentController removeScriptMessageHandlerForName:KViewPictrue];
//     [self.config.userContentController removeScriptMessageHandlerForName:KCamera];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)HeadImageLocalStorge{
    [super HeadImageLocalStorge];
}
- (void)loginLocalStorge{
    [super loginLocalStorge];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
