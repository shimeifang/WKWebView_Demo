//
//  ListViewController.h
//  WorkFrameDemo
//
//  Created by admin on 17/2/23.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "RootViewController.h"

@interface ListViewController : RootViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    
}


@end
