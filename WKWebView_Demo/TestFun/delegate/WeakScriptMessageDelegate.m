//
//  WeakScriptMessageDelegate.m
//  WKWebView
//
//  Created by admin on 2017/12/28.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "WeakScriptMessageDelegate.h"

@implementation WeakScriptMessageDelegate

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate{
    self = [super init];
    if(self){
        _scriptDelegate = scriptDelegate;
    }
    return self;
}

+(instancetype)scriptWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate{
     return [[WeakScriptMessageDelegate alloc]initWithDelegate:scriptDelegate];
}

#pragma mark - <WKScriptMessageHandler>
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
    
}

@end
