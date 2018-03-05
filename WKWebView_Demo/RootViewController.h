//
//  RootViewController.h
//  Frame721
//
//  Created by admin on 17/1/5.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController

-(void)configUI;
-(void)loadData;
-(void)addTitle:(NSString *)title;
-(void)addBtnWithTitle:(NSString *)title withBgImageName:(NSString *)bgName withLocation:(NSString *)location;
- (void)addBtnWithTitles:(NSArray *)titles withBgImageNames:(NSArray *)bgNames withLocation:(NSString *)location;
-(void)leftClick:(UIButton *)btn;
-(void)rightClick:(UIButton *)btn;

@end
