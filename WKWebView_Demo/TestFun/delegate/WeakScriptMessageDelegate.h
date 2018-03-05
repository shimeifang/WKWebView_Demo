//
//  WeakScriptMessageDelegate.h
//  WKWebView
//
//  Created by admin on 2017/12/28.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WKScriptMessageHandler.h>
#import <WebKit/WebKit.h>
//#import <JavaScriptCore/JavaScriptCore.h>

@interface WeakScriptMessageDelegate : NSObject<WKScriptMessageHandler>

@property(nonatomic,weak) id <WKScriptMessageHandler> scriptDelegate;
/** 创建方法 */
- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;
/** 便利构造器 */
+(instancetype)scriptWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;

@end
