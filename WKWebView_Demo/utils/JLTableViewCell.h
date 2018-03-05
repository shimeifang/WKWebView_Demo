//
//  JLTableViewCell.h
//  MyChat1525
//
//  Created by 沈家林 on 16/3/17.
//  Copyright (c) 2016年 沈家林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JLTableViewCellStyle) {
    JLTableViewCellStyleDefault, //左边是一个imageView，一个lable
    JLTableViewCellStyleValue1,//左边是一个label
    JLTableViewCellStyleValue2,//左边一个label，右边一个label
    JLTableViewCellStyleValue3,//中间一个label
    JLTableViewCellStyleSubtitle,//左边一个label，右边一个imageView
    JLTableViewCellStyleSubtitle2//左边一个label，右边一个开关Switch
    
};

@interface JLTableViewCell : UITableViewCell

@property (nonatomic,strong)UIImageView *leftImageView;
@property (nonatomic,strong)UILabel *leftLabel;
@property (nonatomic,strong)UILabel *middLabel;

@property (nonatomic,strong)UIImageView *rightImageView;
@property (nonatomic,strong)UILabel *rightLabel;

@property (nonatomic,strong)UISwitch *rightSwitch;

-(id)initWithStyle:(JLTableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
