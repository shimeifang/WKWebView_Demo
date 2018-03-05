//
//  MFTextField.m
//  WorkFrameDemo
//
//  Created by admin on 2017/10/30.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "MFTextField.h"

@implementation MFTextField
//左视图的位置和大小
- (CGRect)leftViewRectForBounds:(CGRect)bounds{
    CGRect leftRect = [super leftViewRectForBounds:bounds];
    leftRect.origin.x =5; //像右边偏5
    return leftRect;
}
//右视图显示的位置和大小
-(CGRect)rightViewRectForBounds:(CGRect)bounds{
    CGRect rightRect =CGRectZero;
    rightRect.origin.x = bounds.size.width - 65;
    rightRect.size.height =25;
    rightRect.origin.y = (bounds.size.height - rightRect.size.height)/2;
    rightRect.size.width =55;
    return rightRect;
}
//可输入的字符的区域
-(CGRect)textRectForBounds:(CGRect)bounds{
    CGRect textRect = [super textRectForBounds:bounds];
    if (self.leftView ==nil) {
        return CGRectInset(textRect, 10,0);
    }
    CGFloat offset =30 - textRect.origin.x;
    textRect.origin.x =30;
    textRect.size.width = textRect.size.width - offset - 10;
    return textRect;
}
//编辑显示的区域
-(CGRect)editingRectForBounds:(CGRect)bounds{
    CGRect textRect = [super editingRectForBounds:bounds];
    if (self.leftView ==nil) {
        return CGRectInset(textRect, 10,0);
    }
    CGFloat offset =30 - textRect.origin.x;
    textRect.origin.x =30;
    textRect.size.width = textRect.size.width - offset - 10;
    return textRect;
}

@end
