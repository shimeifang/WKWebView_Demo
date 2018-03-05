//
//  WKTwoViewController.m
//  WKWebView
//
//  Created by admin on 2017/12/29.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "BaseViewController.h"

//通讯录
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
//JS调原生的方法，一定要一致
#define KPlayVoice @"playVoice"
#define SetLocalStorage @"setLocalStorage"
#define GetLocalStorage @"getLocalStorage"
#define RemoveLocalStorage @"removeLocalStorage"
#define KAFNetWorking @"AFNetWorking"
#define KScan @"scan"
#define KOpenContact @"openContact"
//相机拍照
#define KCamera  @"camera"
//图片预览
#define KViewPictrue @"viewPictrue"

//高德定位
#define KAMapLocation @"getLocation"
#define APIKey @"c88b444c28a2362af5630c69664f7bce"
//api接口
#define KLoginUrl @"http://106.14.143.199:9080/Receive.aspx"

//获取状态栏高度
#define KStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
//适配iPhone x 底栏高度,标签栏高度
#define KTabbarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)

#define IS_iOS9 [[UIDevice currentDevice].systemVersion floatValue] >= 9.0f
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] <= 8.0)
static void *WkwebBrowserContext = &WkwebBrowserContext;

@interface BaseViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler,AVAudioPlayerDelegate,sendDataDelegate,CNContactPickerDelegate,ABPeoplePickerNavigationControllerDelegate,AMapLocationManagerDelegate,UIScrollViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    AVSpeechSynthesizer *_synth;//语音合成器
    AVSpeechUtterance *_utterance; //语音播报
    AVSpeechSynthesisVoice *_voice;//播报声音
    AVAudioPlayer *_avAudioPlay;//播放音频的类，播放本地音乐
    
     CNContactPickerViewController *_contactPickerVC; //通讯录类
    //图片预览
    CATransition *animation;//缩放动画效果
    CGFloat scaleNum;//图片放大倍数
    
    
}
@property(nonatomic,strong) WKWebView *webView;
//设置加载进度条
@property (nonatomic,strong) UIProgressView *progressView;
//图片预览
@property(nonatomic,strong)UIScrollView *scrollview;//用于捏合放大与缩小的scrollView
@property(nonatomic,strong)UIImageView *imgView;//显示图片的按钮

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAudioSession];//初始化音频
   
    //添加进度条
    [self.view addSubview:self.progressView];
    
}
/*
 *总的来说，要实现JS调用OC方法，重点就是三项：
 1.必须在html中预留接口，格式是固定的：window.webkit.messageHandlers.ActionName.postMessage('parameter');
 2.陪着WKWebViewConfiguration，并通过WKUserContentController注册html中预留的方法；
 3.实现WKScriptMessageHandler协议的- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message方法。
 链接：https://www.jianshu.com/p/9b4f7f6d47da
 */
- (void)initWKWebView:(NSString *)html{

    self.config = [[WKWebViewConfiguration alloc]init];
//    config.userContentController = [[WKUserContentController alloc]init];
   
    self.webView = [[WKWebView alloc]initWithFrame:self.view.frame configuration:self.config];
    
//    NSString *htmlPath = [[NSBundle mainBundle]pathForResource:@"test/test12.27" ofType:@"html"];
     NSString *htmlPath = [[NSBundle mainBundle]pathForResource:html ofType:@"html"];
    NSURL *htmlUrl = [NSURL fileURLWithPath:htmlPath];
    [self.webView loadRequest:[NSURLRequest requestWithURL:htmlUrl]];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    
   
    //kvo 添加进度监控
    [self.webView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:WkwebBrowserContext];
    /*
     【注意】：KVO一定要销毁：否则会在界面消失以后，造成程序崩溃
     */
    [self.view addSubview:self.webView];
    
}
- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

//+ (void)initialize{
//    JSHandler = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"jquery-2.1.4.min" withExtension:@"js"] encoding:NSUTF8StringEncoding error:nil];
//
//}

#pragma mark - WKNavigationDelegate
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"JS 调用了 %@ 方法，传回参数 %@",message.name,message.body);
   
    if(![self isBlankData:message.body]){
        
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
            NSLog(@"AFNetWorking:%@",message.body);
            [self getNetInterfaceCall:message.body];
        }
        if ([message.name isEqualToString:KPlayVoice]) {
            NSLog(@"PlayVoice:%@",message.body);
            [self avAudioPlayFuction:message.body];
        }
        if ([message.name isEqualToString:KScan]) {
            NSLog(@"scan:%@",message.body);
            [self addScan:message.body];
        }
        //图片预览
        if ([message.name isEqualToString:KViewPictrue]) {
            NSLog(@"viewPictrue:%@",message.body);
            [self viewPictrue:message.body];
        }
       
    }
      //相机拍照
    if ([message.name isEqualToString:KCamera]) {
        NSLog(@"相机拍照");
        [self takeCamera];
    }
    if ([message.name isEqualToString:KOpenContact]) {
        NSLog(@"openContact:%@",message.body);
        [self addContact];
    }
    if ([message.name isEqualToString:KAMapLocation]) {
        NSLog(@"AMapLocation:%@",message.body);
        // 获取位置信息
        
        [AMapServices sharedServices].apiKey = APIKey;
        [self initConnectLocation];
    }
   
}
/**/
#pragma mark --- 相机拍照
- (void)takeCamera{
    UIImagePickerController *pick = [[UIImagePickerController alloc]init];
    
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"" message:@"请选择相册或相机拍照" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        pick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:pick animated:YES completion:nil];
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        pick.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:pick animated:YES completion:nil];
        
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertControl addAction:action1];
    [alertControl addAction:action2];
    [alertControl addAction:cancel];
    
    [self presentViewController:alertControl animated:NO completion:nil];
    pick.allowsEditing = YES;
    pick.delegate = self;
//    UIImagePickerController *pickerControl = [[UIImagePickerController alloc]init];
//    pickerControl.sourceType = UIImagePickerControllerSourceTypeCamera;
//    pickerControl.allowsEditing = YES;
//    pickerControl.delegate = self;
//    [self presentViewController:pickerControl animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    NSLog(@"----------%@",info);
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        //如果是图片
        UIImage *pickedImage;
        if ([picker allowsEditing]) {
            pickedImage = info[UIImagePickerControllerEditedImage];
        }else{
            pickedImage = info[UIImagePickerControllerOriginalImage];
        }
   
        NSLog(@"图片是%@",pickedImage);
        NSData *imageData = UIImageJPEGRepresentation(pickedImage, 0.6);
        NSString *dataStr = [imageData base64EncodedStringWithOptions:0];
         NSString *callBack = [NSString stringWithFormat:@"callBackPhoto('%@')",dataStr];
        [self.webView evaluateJavaScript:callBack completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"oc调JS成功");
            } else {
                NSLog(@"oc调JS失败");
            }
        }];
       
        
        //保存图片至相册
        //UIImageWriteToSavedPhotosAlbum(pickedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        
    }
}
#pragma mark --- 图片预览
- (void)viewPictrue:(NSString *)imgStr{
    if ([[imgStr componentsSeparatedByString:@"."].lastObject isEqualToString:@"jpg"] || [[imgStr componentsSeparatedByString:@"."].lastObject isEqualToString:@"png"] ) {
        
        UIImage *img = [UIImage imageNamed:imgStr];
        self.imgView = [[UIImageView alloc]initWithImage:img];
    } else {
        //base64 -> 图片
         UIImage *img = [UIImage imageWithData:[[NSData alloc]initWithBase64EncodedString:imgStr options:NSDataBase64DecodingIgnoreUnknownCharacters]];
        self.imgView = [[UIImageView alloc]initWithImage:img];
    }

    scaleNum = 1;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0;
   
    
    //添加捏合手势，放大与缩小图片
    self.scrollview=[[UIScrollView alloc]initWithFrame:backgroundView.bounds];
    [self.scrollview addSubview:self.imgView];
    //设置UIScrollView的滚动范围和图片的真实尺寸一致
    self.scrollview.contentSize=self.imgView.frame.size;
    //设置实现缩放
    //设置代理scrollview的代理对象
    self.scrollview.delegate=self;
    //设置最大伸缩比例
    self.scrollview.maximumZoomScale=3;
    //设置最小伸缩比例
    self.scrollview.minimumZoomScale=1;
    [self.scrollview setZoomScale:1 animated:NO];
    
    self.scrollview.scrollsToTop =NO;
    self.scrollview.scrollEnabled =YES;
    self.scrollview.showsHorizontalScrollIndicator=NO;
    self.scrollview.showsVerticalScrollIndicator=NO;
    
    [backgroundView addSubview:self.scrollview];
    [window addSubview:backgroundView];
    
    //单击手势
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap:)];
    singleTapGesture.numberOfTapsRequired = 1;
    singleTapGesture.numberOfTouchesRequired  =1;
    [backgroundView addGestureRecognizer:singleTapGesture];
    
    //双击手势
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    doubleTapGesture.numberOfTouchesRequired =1;
    [backgroundView addGestureRecognizer:doubleTapGesture];
    
    [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
    
    [UIView animateWithDuration:0.3 animations:^{
        _imgView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-(_imgView.frame.size.height*[UIScreen mainScreen].bounds.size.width/_imgView.frame.size.width+80))/2, [UIScreen mainScreen].bounds.size.width, _imgView.frame.size.height*[UIScreen mainScreen].bounds.size.width/_imgView.frame.size.width+80);
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        _imgView.userInteractionEnabled=NO;
    }];
    
}
// - 还原图片
-(void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView=tap.view;
    UIImageView *imgView=(UIImageView *)[tap.view viewWithTag:1];
    animation = [CATransition animation];
    animation.duration =0.2;
    animation.timingFunction =UIViewAnimationCurveEaseInOut;
    animation.fillMode =kCAFillModeForwards;
    animation.type =kCATransition;
    backgroundView.alpha=0;
    [backgroundView.layer addAnimation:animation forKey:@"animation"];
   
   _imgView.userInteractionEnabled=YES;
   
}
//处理单击手势
-(void)handleSingleTap:(UIGestureRecognizer *)sender{
    UITapGestureRecognizer *tap=(UITapGestureRecognizer *)sender;
    [self hideImage:tap];
}
//处理双击手势
-(void)handleDoubleTap:(UIGestureRecognizer *)sender{
    if (scaleNum>=1&&scaleNum<=2) {
        scaleNum++;
    }else{
        scaleNum=1;
    }
    [self.scrollview setZoomScale:scaleNum animated:YES];
}
// UIScrollViewDelegate,告诉scrollview要缩放的是哪个子控件
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imgView;
}
// - 等比例放大，让放大的图片保持在scrollView的中央
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGFloat offsetX = (self.scrollview.bounds.size.width > self.scrollview.contentSize.width)?(self.scrollview.bounds.size.width - self.scrollview.contentSize.width) *0.5 : 0.0;
    CGFloat offsetY = (self.scrollview.bounds.size.height > self.scrollview.contentSize.height)?
    (self.scrollview.bounds.size.height - self.scrollview.contentSize.height) *0.5 : 0.0;
    self.imgView.center =CGPointMake(self.scrollview.contentSize.width *0.5 + offsetX,self.scrollview.contentSize.height *0.5 + offsetY);
}
#pragma mark --- 获取定位后经纬度坐标
//持续定位
- (void)initConnectLocation{
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    //设置定位最小更新距离方法如下，单位米。当两次定位距离满足设置的最小更新距离时，SDK会返回符合要求的定位结果。
    self.locationManager.distanceFilter = 200;
    
    //如果需要持续定位返回逆地理编码信息，（自 V2.2.0版本起支持）需要做如下设置：
    [self.locationManager setLocatingWithReGeocode:YES];
    
    //调用AMapLocationManager提供的startUpdatingLocation方法实现。
    [self.locationManager startUpdatingLocation];
}

//接收位置更新
//实现AMapLocationManagerDelegate代理的amapLocationManager:didUpdateLocation: 方法，处理位置更新。
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    //    float longitude = location.coordinate.longitude;
    //    float latitude = location.coordinate.latitude;

    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);


}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    float longitude = location.coordinate.longitude;
    float latitude = location.coordinate.latitude;
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);

    //定位成功返回坐标给JS
    NSString *callBackLocation = [NSString stringWithFormat:@"callBackGetLocation('%f','%f')",longitude,latitude];
    [self.webView evaluateJavaScript:callBackLocation completionHandler:^(id _Nullable responde, NSError * _Nullable error) {
        if(!error){
             NSLog(@"js err");
        }else{
            NSLog(@"js成功");
        }
    }];


    if (reGeocode)
    {
        NSLog(@"reGeocode:%@", reGeocode);
    }

    [self stopLocation];
}

//停止持续定位
- (void)stopLocation{

    [self.locationManager stopUpdatingLocation];
}

#pragma mark --打开通讯录 ContactsUI

- (void)addContact{
    NSLog(@"%s",__func__);
    if (IS_iOS9) {
        if (@available(iOS 9.0, *)) {
            _contactPickerVC = [[CNContactPickerViewController alloc]init];
        } else {
            // Fallback on earlier versions
        }
        _contactPickerVC.delegate = self;
        
        [self presentViewController:_contactPickerVC animated:YES completion:nil];
        
    } else {
        ABPeoplePickerNavigationController *peoplePickController = [[ABPeoplePickerNavigationController alloc] init];
        peoplePickController.peoplePickerDelegate = self;
        [self presentViewController:peoplePickController animated:YES completion:^{
            
        }];
    }
    
}


#pragma mark --ContactsUI CNContactPickerDelegate
//http://blog.csdn.net/mamong/article/details/49623051

// 注意:如果实现该方法，上面那个方法就不能实现了，这两个方法只能实现一个
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty{
    
    //    [self printContactInfo:contactProperty.contact];
    
    /*
     根据选中某一个号码来获取对应的号码
     */
    NSLog(@"%@",contactProperty);
    CNContact *contact = contactProperty.contact;
    NSLog(@"givenName: %@, familyName: %@", contact.givenName, contact.familyName);
    //    NSString *name = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
    if (![contactProperty.value isKindOfClass:[CNPhoneNumber class]]) {
        
        NSLog(@"请选择11位手机号");
        //        JSValue *Callback = self.context[@"callBackContactPhone"];
        //        [Callback callWithArguments:@[@"请选择11位手机号"]];
        
        return;
    }
    CNPhoneNumber *phoneNumber = contactProperty.value;
    NSString * Str = phoneNumber.stringValue;
    NSCharacterSet *setToRemove = [[ NSCharacterSet characterSetWithCharactersInString:@"0123456789"]invertedSet];
    NSString *phoneStr = [[Str componentsSeparatedByCharactersInSet:setToRemove]componentsJoinedByString:@""];
    if (phoneStr.length != 11) {
        NSLog(@"请选择11位手机号");
        //        JSValue *Callback = self.context[@"callBackContactPhone"];
        //        [Callback callWithArguments:@[@"请选择11位手机号"]];
    }
    NSLog(@"-=-=%@",phoneStr);
    //    self.phoneTextView.text = phoneStr;
    NSString *callJSPhone = [NSString stringWithFormat:@"callBackContactPhone(%@)",phoneStr];
    [self.webView evaluateJavaScript:callJSPhone completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"oc调JS成功");
        } else {
             NSLog(@"oc调JS失败");
        }
    }];

}

//获取所有联系人号码
- (void)printContactInfo:(CNContact *)contact{
    NSString *phoneStr;
    NSString *givenName = contact.givenName;
    NSString *familyName = contact.familyName;
    NSLog(@"givenName=%@, familyName=%@", givenName, familyName);
    //    NSString *name = [NSString stringWithFormat:@"%@%@",familyName,givenName];
    NSArray *phoneNumbers = contact.phoneNumbers;
    //     NSLog(@"====phoneNumbers=%@", phoneNumbers);
    NSMutableArray *mutArr = [[NSMutableArray alloc]init];
    
    for (CNLabeledValue<CNPhoneNumber*> *phone in phoneNumbers) {
        NSString *label = phone.label;
        CNPhoneNumber *phonNumber = (CNPhoneNumber *)phone.value;
        NSLog(@"label=%@, value=%@", label, phonNumber.stringValue);
        phoneStr = phonNumber.stringValue;
        
        [mutArr addObject:phoneStr];
        // 将结果返回给js
        //        NSString *jsStr = [NSString stringWithFormat:@"callBackContactPhone('%@')",phoneStr];
        //        [_webView stringByEvaluatingJavaScriptFromString:jsStr];
        //        NSLog(@"mutArr======%@", mutArr);
        
        
        // 成功回调js的方法Callback
        //        JSValue *Callback = self.context[@"callBackContactPhone"];
        //        [Callback callWithArguments:@[phoneStr]];
//        NSString *callJSPhone = [NSString stringWithFormat:@"callBackContactPhone(%@)",phoneStr];
//        [self.webView evaluateJavaScript:callJSPhone completionHandler:^(id _Nullable response, NSError * _Nullable error) {
//            if (!error) {
//                NSLog(@"oc调JS成功");
//            } else {
//                NSLog(@"oc调JS失败");
//            }
//        }];

        
    }
    NSLog(@"mutArr======%@", mutArr);
    // 将结果返回给js
    
//    JSValue *Callback = self.context[@"callBackContactPhone"];
//    [Callback callWithArguments:@[mutArr]];
    NSString *callJSPhone = [NSString stringWithFormat:@"callBackContactPhone(%@)",phoneStr];
    [self.webView evaluateJavaScript:callJSPhone completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"oc调JS成功");
        } else {
            NSLog(@"oc调JS失败");
        }
    }];
}

#pragma mark -- iOS7 8 调用通讯录

//第一个只进入到列表。第二个可以进入到具体的属性页面。就是到这来点号码后会被调用 ;只能实现二选一
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    /*
     ABMultiValueRef valuesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
     CFStringRef telValue = ABMultiValueCopyValueAtIndex(valuesRef,0);
     NSString *phone = (__bridge NSString *)telValue;
     NSLog(@"----iOS 8 调用通讯录-----%@",phone);
     // 将分享结果返回给js
     NSString *jsStr = [NSString stringWithFormat:@"callBackContactPhone('%@')",phone];
     [_webView stringByEvaluatingJavaScriptFromString:jsStr];
     
     */
    
    // 获取该联系人多重属性--电话号
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    // 获取该联系人的名字，简单属性，只需ABRecordCopyValue取一次值
    ABMutableMultiValueRef firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *firstname = (__bridge NSString *)(firstName);
    ABMutableMultiValueRef lastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
    NSString *lastname = (__bridge NSString *)(lastName);
    // 获取点击的联系人的电话
    NSLog(@"联系人名字 ： %@%@",lastname,firstname);
    
    // 点击某个联系人电话后dismiss联系人控制器，并回调点击的数据
    [self dismissViewControllerAnimated:YES completion:^{
        // 从多重属性——电话号中取值，参数2是取点击的索引
        NSString *aPhone =  (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, ABMultiValueGetIndexForIdentifier(phoneMulti,identifier)) ;
        // 获取点击的联系人的电话，也可以取标签等
        NSLog(@"联系人电话 ： %@",aPhone);
        // 去掉电话号中的 "-"
        aPhone = [aPhone stringByReplacingOccurrencesOfString:@"-" withString:@"" ];
        NSLog(@"去掉-号 ： %@",aPhone);
        // 将结果返回给js
//        JSValue *Callback = self.context[@"callBackContactPhone"];
//        [Callback callWithArguments:@[aPhone]];
        NSString *callJSPhone = [NSString stringWithFormat:@"callBackContactPhone(%@)",aPhone];
        [self.webView evaluateJavaScript:callJSPhone completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"oc调JS成功");
            } else {
                NSLog(@"oc调JS失败");
            }
        }];
    }];
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
#pragma mark -- 语音报读初始化扬声器
- (void)initAudioSession{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    NSError *setCategoryError = nil;
    if (![audioSession setCategory:AVAudioSessionCategoryPlayback
                       withOptions:AVAudioSessionCategoryOptionMixWithOthers
                             error:&setCategoryError]) {
        // handle error
    }
    
    
    NSError* error;
    
    //默认情况下扬声器播放
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:&error];
    [audioSession setActive:YES error:nil];
}
//语音播报
- (void)avAudioPlayFuction:(NSString*)avStr{
    NSLog(@"%s",__func__);
    
    if ([avStr isEqualToString:@"#"]) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"scan_success" ofType:@"wav"];
        NSURL *url = [NSURL fileURLWithPath:path];
        _avAudioPlay = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        _avAudioPlay.delegate = self;
        [_avAudioPlay play];
    } else if ([avStr isEqualToString:@"*"]){
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"scan_failed" ofType:@"wav"];
        NSURL *url = [NSURL fileURLWithPath:path];
        _avAudioPlay = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        _avAudioPlay.delegate = self;
        [_avAudioPlay play];
    }else{
        [self playVoice:avStr];//调用语音报读
    }
}

- (void)playVoice:(NSString *)speechStr{
    NSLog(@"%s",__func__);
    
    NSLog(@"star");
    
    _utterance = [AVSpeechUtterance speechUtteranceWithString:speechStr]; //语音播报
    _utterance.rate*= 0.8;
    _utterance.pitchMultiplier = 0.8; //音高
    _voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    //英式发音
    //    AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-GB"];
    
    _utterance.voice = _voice;
    
    //    NSLog(@"%@",[AVSpeechSynthesisVoice speechVoices]);
    
    _synth = [[AVSpeechSynthesizer alloc]init]; //语音合成器
    [_synth speakUtterance:_utterance]; //说话
    NSLog(@"end");
    
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

- (void)getLocalStorage:(NSString *)key{
    NSLog(@"%s",__func__);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *jsonStr;
    if([[defaults objectForKey:key] isKindOfClass:[NSDictionary class]]){
        NSDictionary *callBackDic = [defaults objectForKey:key];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:callBackDic options:NSJSONWritingPrettyPrinted error:nil];
        jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }else{
        jsonStr = [defaults objectForKey:key];
    }
    NSLog(@"%@",jsonStr);
    //设置JS
     NSString *callValueJS = [NSString stringWithFormat: @"getCallBackValue(%@)",jsonStr];
    //执行JS返回参数值
    [self.webView evaluateJavaScript:callValueJS completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        NSLog(@"err:%@",error.description);
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
                NSString *callValueJS = [NSString stringWithFormat: @"netCallBack(%@)",jsonStr];
               
                //执行JS
                [self.webView evaluateJavaScript:callValueJS completionHandler:^(id _Nullable response, NSError * _Nullable error) {
                   
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
#pragma mark -- 页面加载前获取到缓存头像
- (void)HeadImageLocalStorge{
    //获取缓存的头像base64
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *imgStr = [defaults objectForKey:KUserImg];
    NSLog(@"%@",imgStr);
    //执行JS方法缓存头像 键值headImage
    NSString *sendToken = [NSString stringWithFormat:@"sessionStorage.setItem(\"headImage\",'%@');",imgStr];
    WKUserScript *wkUserScript = [[WKUserScript alloc]initWithSource:sendToken injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [self.config.userContentController addUserScript:wkUserScript];
}
#pragma mark -- 页面加载前获取到缓存登录返回值
- (void)loginLocalStorge{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [defaults objectForKey:@"Rtn_Data"];
    NSLog(@"Rtn_Data==%@",dic);
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
    
    //注入JS
    [self.config.userContentController addUserScript:wkuScript];
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
    self.progressView.hidden = NO;
    
}

//KVO监听进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.webView) {
        [self.progressView setAlpha:1.0f];
        BOOL animated = self.webView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.webView.estimatedProgress animated:animated];
        
        // Once complete, fade out UIProgressView
        if(self.webView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
- (UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
         _progressView.frame = CGRectMake(0, KStatusBarHeight, self.view.bounds.size.width, 3);
//        if (_isNavHidden == YES) {
//            _progressView.frame = CGRectMake(0, 20, self.view.bounds.size.width, 3);
//        }else{
//            _progressView.frame = CGRectMake(0, 64, self.view.bounds.size.width, 3);
//        }
        // 设置进度条的色彩
        [_progressView setTrackTintColor:[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0]];
        _progressView.progressTintColor = [UIColor greenColor];
    }
    return _progressView;
}
- (BOOL)isBlankData:(id)data {
    if([data isKindOfClass:[NSDictionary class]]){
        NSDictionary *dic = data;
        if(dic.count == 0 || [dic isEqual:[NSNull null]] || dic==nil){
            return YES;
        }

    }
    if([data isKindOfClass:[NSArray class]]){
        NSArray *arr = data;
        if(arr==nil || [arr isKindOfClass:[NSNull class]] || arr.count==0){
            return YES;
        }
    }
    if([data isKindOfClass:[NSString class]]){
        NSString *string = data;
        if (string == nil || string == NULL || [string isEqual:[NSNull null]]) {
            return YES;
        }
        if ([string isKindOfClass:[NSNull class]]) {
            return YES;
        }
        if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
            return YES;
        }
    }
    NSString *string = data;
    if (string == nil || string == NULL || [string isEqual:[NSNull null]]) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

- (BOOL)isNullOrNilWithObject:(id)object{
    NSLog(@"%@",object);
    if(object==nil||[object isEqual:@""] ||[object isEqual:[NSNull null]]){
        return YES;
    }else if ([object isKindOfClass:[NSString class]]){
        if([object isEqualToString:@""]){
            return YES;
        }else{
            return NO;
        }
    }else if([object isKindOfClass:[NSNumber class]]){
        if([object isEqualToNumber:@0]){
            return YES;
        }else{
            return NO;
        }
    }
    return NO;
}

@end
