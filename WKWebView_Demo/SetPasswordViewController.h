//
//  SetPasswordViewController.h
//  WorkFrameDemo
//
//  Created by admin on 2017/10/31.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetPasswordViewController : UIViewController

@property(nonatomic,strong)UITextField *oldPWTextField;
@property(nonatomic,strong)UITextField *PWNewTextField;
@property(nonatomic,strong)UITextField *aginNewTextField;

- (void)sureBtn:(UIButton *)btn;

@end
