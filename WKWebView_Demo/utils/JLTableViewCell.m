//
//  JLTableViewCell.m
//  MyChat1525
//
//  Created by 沈家林 on 16/3/17.
//  Copyright (c) 2016年 沈家林. All rights reserved.
//

#import "JLTableViewCell.h"

@interface JLTableViewCell()
@property (nonatomic,weak)UIView* leftLastView;
@property (nonatomic,weak)UIView* rightLastView;
@end



@implementation JLTableViewCell
-(id)initWithStyle:(JLTableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        switch (style) {
            case JLTableViewCellStyleDefault:
            {
                [self addLeftImageView];
                [self addLeftLabel];
            }
                break;
            case JLTableViewCellStyleValue1:{
                
                [self addLeftLabel];
            }
                break;
            case JLTableViewCellStyleValue2:{
                [self addLeftLabel];
                [self addRightLabel];
            }
                break;
            case JLTableViewCellStyleValue3:{
                [self addMiddleLabel];
            }
                break;
            case JLTableViewCellStyleSubtitle:{
                [self addLeftLabel];
                [self addRightImageView];
            }
                break;
            case JLTableViewCellStyleSubtitle2:{
                [self addLeftLabel];
                [self addRightBtn];
            }
                break;
            default:
                break;
        }
        _leftLastView=nil;
        _rightLastView=nil;
    }
    return self;
}

-(void)addLeftLabel{
    KWS(ws);
    _leftLabel=[UILabel new];
    _leftLabel.font=[UIFont systemFontOfSize:15];
    [self.contentView addSubview:_leftLabel];
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.contentView).offset(10);
        make.bottom.equalTo(ws.contentView).offset(-10);
        if (ws.leftLastView) {
            make.left.equalTo(ws.leftLastView.mas_right).offset(15);
        }else{
            make.left.equalTo(ws.contentView).offset(15);
        }
        make.width.mas_lessThanOrEqualTo(150);
    }];
    _leftLastView=_leftLabel;
}

-(void)addLeftImageView{
    KWS(ws);
    _leftImageView=[UIImageView new];
    _leftImageView.contentMode=UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_leftImageView];
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.contentView).offset(10);
        make.height.equalTo(_leftImageView.mas_width);
        make.bottom.equalTo(ws.contentView).offset(-10);
        if (ws.leftLastView) {
            make.left.equalTo(ws.leftLastView.mas_right).offset(15);
        }else{
            make.left.equalTo(ws.contentView).offset(15);
        }
    }];
    _leftLastView=_leftImageView;
}

-(void)addMiddleLabel{
    KWS(ws);
    _middLabel=[UILabel new];
    _middLabel.font=[UIFont systemFontOfSize:15];
    _middLabel.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:_middLabel];
    [_middLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

-(void)addRightLabel{
    KWS(ws);
    _rightLabel=[UILabel new];
    _rightLabel.font=[UIFont systemFontOfSize:15];
    _rightLabel.textColor=[UIColor grayColor];
    _rightLabel.textAlignment=NSTextAlignmentRight;
    [self.contentView addSubview:_rightLabel];
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.contentView).offset(10);
        make.bottom.equalTo(ws.contentView).offset(-10);
        if (ws.rightLastView) {
            make.right.equalTo(ws.rightLastView.mas_left).offset(-15);
        }else{
            make.right.equalTo(ws.contentView.mas_right).offset(-15);
        }
        make.width.mas_lessThanOrEqualTo(80);
    }];
    _rightLastView=_rightLabel;
}

-(void)addRightImageView{
    KWS(ws);
    _rightImageView=[UIImageView new];
    _rightImageView.contentMode=UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_rightImageView];
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.contentView).offset(5);
        make.bottom.equalTo(ws.contentView).offset(-5);
        if (ws.rightLastView) {
            make.right.equalTo(ws.rightLastView.mas_left).offset(-25);
        }else{
            make.right.equalTo(ws.contentView.mas_right).offset(-15);
        }
        make.width.equalTo(ws.rightImageView.mas_height);
    }];
    _rightLastView=_rightImageView;
}

-(void)addRightBtn{
    KWS(ws);
    _rightSwitch = [UISwitch new];
    [self.contentView addSubview:_rightSwitch];
    [_rightSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.contentView).offset(8);
        make.bottom.equalTo(ws.contentView).offset(-10);
        if (ws.rightLastView) {
            make.right.equalTo(ws.rightLastView.mas_left).offset(-15);
        }else{
            make.right.equalTo(ws.contentView);
        }
        make.height.mas_equalTo(@30);
        make.width.mas_equalTo(@50);
    }];
    _rightLastView=_rightSwitch;
}

@end
