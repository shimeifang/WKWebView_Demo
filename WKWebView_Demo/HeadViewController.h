//
//  HeadViewController.h
//  WorkFrameDemo
//
//  Created by admin on 2017/4/17.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol sendImageDataDelegate <NSObject>

- (void)sendDataImage:(NSString *)imageHead;

@end

@interface HeadViewController : UIViewController
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIImage *imgStr; //头像

@property(nonatomic,assign)id<sendImageDataDelegate> delegate;

@end
