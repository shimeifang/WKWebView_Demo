//
//  MainViewController.m
//  DrivePP
//
//  Created by admin on 2017/12/18.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "MainViewController.h"
#import "QRCodeVC.h"
//#import "MFCacheTool.h"
#import "WeakScriptMessageDelegate.h"

#import "LFCGzipUtility.h"

#define SetLocalStorage @"setLocalStorage"
#define GetLocalStorage @"getLocalStorage"
#define RemoveLocalStorage @"removeLocalStorage"
#define KAFNetWorking @"AFNetWorking"
#define KScan @"scan"
@interface MainViewController ()<UIWebViewDelegate,WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler,sendDataDelegate>
{
    
}
@property(nonatomic,strong) WKWebView *webView;
@end

@implementation MainViewController

- (void)loadView{
    [super loadView];
    NSLog(@"%s",__func__);
   
}

- (void)wkwebview{
        NSDictionary *dic = @{@"aa":@"a",@"bb":@"b"};
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSDictionary *dic = [defaults objectForKey:@"Rtn_Data"];
//    NSLog(@"Rtn_Data==%@",dic);
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonStr);
    /*https://www.cnblogs.com/sucksuck/p/6039345.html
     用localStorage.setItem()正确存储JSON对象方法是：
     存储前先用JSON.stringify()方法将json对象转换成字符串形式
     JSON.stringify() 方法可以将任意的 JavaScript 值序列化成 JSON 字符串
     */
    NSString *sendToken = [NSString stringWithFormat:@"sessionStorage.setItem(\"Rtn_Data\",JSON.stringify(%@));",jsonStr];
    /*
     WKUserScriptInjectionTimeAtDocumentStart:JS加载前执行
     WKUserScriptInjectionTimeAtDocumentEnd：JS加载后执行
     forMainFrameOnly:NO(全局窗口)，YES(只限主窗口)
     */
    // injectionTime 配置不要写错
    WKUserScript *wkuScript = [[WKUserScript alloc]initWithSource:sendToken injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    //配置JS（这个很重要，不配置的话，下面注入的JS是不起作用的）
   
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
    //注入JS
    [config.userContentController addUserScript:wkuScript];
    
    // WeakScriptMessageDelegate 这个类避免循环引用的
//    [config.userContentController addScriptMessageHandler:[WeakScriptMessageDelegate scriptWithDelegate:self] name:SetLocalStorage];
//    [config.userContentController addScriptMessageHandler:[WeakScriptMessageDelegate scriptWithDelegate:self] name:GetLocalStorage];
//    [config.userContentController addScriptMessageHandler:[WeakScriptMessageDelegate scriptWithDelegate:self] name:RemoveLocalStorage];
//    [config.userContentController addScriptMessageHandler:[WeakScriptMessageDelegate scriptWithDelegate:self] name:KAFNetWorking];
     [config.userContentController addScriptMessageHandler:[WeakScriptMessageDelegate scriptWithDelegate:self] name:KScan];
   
    
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, KStatusBarHeight, KScreenWidth, KScreenHeight-KStatusBarHeight-KTabbarHeight) configuration:config];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    NSString *htmlPath = [[NSBundle mainBundle]pathForResource:@"CityExpressApp/app/WaybillInfoTrack" ofType:@"html"];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:htmlPath]]];
    _webView.allowsBackForwardNavigationGestures = true;
    [self.view addSubview:_webView];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KColorTitle;
    
    self.navigationItem.title = KMainNavigationTitle;
  
    
    [self wkwebview];
   
    
}
#pragma mark - WKNavigationDelegate
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    NSLog(@"JS 调用了 %@ 方法，传回参数 %@",message.name,message.body);
    if(![MFTool isBlankData:message.body]){
        
        if ([message.name isEqualToString:SetLocalStorage]) {
            NSLog(@"SetLocalStorage:%@",message.body);
            
            [self setLocalStorage:message.body[0] value:message.body[1]];
            
        }
        if ([message.name isEqualToString:GetLocalStorage]) {
            NSLog(@"GetLocalStorage:%@",message.body);
            [self getLocalStorage:message.body];
        }
        if ([message.name isEqualToString:RemoveLocalStorage]) {
            NSLog(@"RemoveLocalStorage:%@",message.body);
            [self removeLocalStorage:message.body];
        }
        if ([message.name isEqualToString:KAFNetWorking]) {
            NSLog(@"AFNetWorking");
            [self getNetInterfaceCall:message.body];
        }
        if ([message.name isEqualToString:KScan]) {
            NSLog(@"scan");
            [self addScan:message.body];
        }
    }
    
}

#pragma mark -- 数据缓存 读、取、移除
- (void)setLocalStorage:(NSString *)key value:(id)value{
    NSLog(@"%s",__func__);
    NSLog(@"key:%@ ,value:%@",key,value);
    NSAssert(value, @"数据不能为空");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
    
}

- (id)getLocalStorage:(NSString *)key{
    NSLog(@"%s",__func__);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}


- (void)removeLocalStorage:(NSString *)key{
    NSLog(@"%s",__func__);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}
#pragma mark -- 网络请求接口
- (void)getNetInterfaceCall:(NSDictionary*)dict
{
    NSLog(@"%s",__func__);
    __weak typeof(self) ws = self;
    
    
    //        NSArray *args = [JSContext currentArguments];
    //        //        NSLog(@"---------args----------%@",args);
    //        NSDictionary *dict = [args[0] toDictionary];
    NSLog(@"---------content----------%@",dict);//业务请求参数
    NSDictionary *dicData = dict[@"Data"];
    
    NSString *postStr = [LFCGzipUtility gzipDicData:dicData];//GZIP的压缩
    //        NSLog(@"GZIP的压缩postStr=====%@",postStr);
    [[HttpRequest sharedInstance]postWithURLString:KLoginUrl requestName:dict[@"ServiceName"] parameters:postStr success:^(id responseObject) {
        
        
        NSDictionary *dictionary =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        //后台返回的gzip压缩的字符串
        NSString *original = [dictionary objectForKey:@"GZipStr"];
        //            NSLog(@"后台返回的gzip压缩的字符串==%@",original);
        
        //GZip解压
        NSDictionary *json = [LFCGzipUtility uncompressZippedStr:original];
        NSLog(@"backdic--------------------%@",json);
        
        if ([[json objectForKey:@"Rtn_Code"] isEqualToString:@"0"]) {
            NSString *msg = [json objectForKey:@"Rtn_Msg"];
            NSDictionary *callBackDic = [json objectForKey:@"Rtn_Data"];
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:callBackDic options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            //设置JS
            NSString *inputValueJS = [NSString stringWithFormat: @"netCallBack(%@)",jsonStr];
            
            //执行JS
            [self.webView evaluateJavaScript:inputValueJS completionHandler:^(id _Nullable response, NSError * _Nullable error) {
                
                if (!error)
                {
                    NSLog(@"OC调 JS成功");
                }
                else
                {
                    NSLog(@"OC调 JS 失败");
                }
            }];
            NSLog(@"--------------------%@",msg);
        } else {
            // 成功回调js的方法Callback
            
            
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"--------------------请求失败");
    } showHUD:ws.view];
    
    
}


#pragma mark - WKUIDelegate
// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"%s",__func__);
    
    NSLog(@"提示信息：%@",message);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"%s",__func__);
    
    //开始加载的时候，让加载进度条显示
//    self.progressView.hidden = NO;
    
}


#pragma mark -- 二维码、条码扫描
- (void)addScan:(NSDictionary*)dic
{
    NSLog(@"%s",__func__);
    
  
        NSLog(@"扫一扫啦");

    NSString *agrOne = dic[@"isRepeat"];
        NSLog(@"---------agrOne----------%@",agrOne);
        
        QRCodeVC *scanVC = [[QRCodeVC alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:scanVC];
        scanVC.delegate = self;
        scanVC.agrso = agrOne;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self presentViewController:nav animated:YES completion:nil];
            
        });
        
        //        [self.navigationController pushViewController:scanVC animated:YES];
        
   
}
//单扫时传值
- (void)sendOrder:(NSString *)order{
    self.order = order;
    NSLog(@"=======order=============%@",self.order);
    // 将结果返回给js
    NSString *jsStr = [NSString stringWithFormat:@"callBackScanOrder('%@')",self.order];
  
    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        if (!error)
        {
            NSLog(@"OC调 JS成功");
        }
        else
        {
            NSLog(@"OC调 JS 失败");
        }
    }];
    
}
//连扫时返回参数
- (void)sendOrders:(NSArray *)arr{
    // NSLog(@"============arr============%@",arr);
    
    NSLog(@"%s",__func__);
    NSLog(@"----------======%@",arr);
    // NSLog(@"%@",[NSString stringWithFormat:@"callBackScanOrder(%@)",arr]);
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setValue:arr forKey:@"orders"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    // NSLog(@"jsonStr==%@",jsonStr);
    
    // 将结果返回给js
    NSString *jsStr = [NSString stringWithFormat:@"callBackScanOrder(%@)",jsonStr];
    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        if (!error)
        {
            NSLog(@"OC调 JS成功");
        }
        else
        {
            NSLog(@"OC调 JS 失败");
        }
    }];
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
