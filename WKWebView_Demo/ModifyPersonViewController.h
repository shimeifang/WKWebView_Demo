//
//  ModifyPersonViewController.h
//  WorkFrameDemo
//
//  Created by admin on 2017/4/17.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol sendHeadDataDelegate <NSObject>

- (void)sendDataImage:(NSString *)imageHead sendUserName:(NSString*)userName;

@end

@interface ModifyPersonViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    
}
@property(nonatomic,strong)NSString *beforeView;

@property(nonatomic,strong)UITextField *userNameTF;

@property(nonatomic,strong)UIImage *headImage;

@property(nonatomic,strong)NSString *imageStr;

@property(nonatomic,strong)UIButton *pickBtn;

@property(nonatomic,strong)NSString *username;

@property(nonatomic,assign)id<sendHeadDataDelegate> delegate;

@end
