//
//  MFTextField.h
//  WorkFrameDemo
//
//  Created by admin on 2017/10/30.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MFTextField : UITextField

//左视图的位置和大小
- (CGRect)leftViewRectForBounds:(CGRect)bounds;
//右视图显示的位置和大小
-(CGRect)rightViewRectForBounds:(CGRect)bounds;
//可输入的字符的区域
-(CGRect)textRectForBounds:(CGRect)bounds;
//编辑显示的区域
-(CGRect)editingRectForBounds:(CGRect)bounds;

@end
