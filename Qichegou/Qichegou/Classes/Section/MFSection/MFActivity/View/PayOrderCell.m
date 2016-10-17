//
//  PayOrderCell.m
//  Qichegou
//
//  Created by Song Gao on 16/1/26.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "PayOrderCell.h"

@implementation PayOrderCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createViews];
    }
    return self;
}


- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self createViews];
}

- (void)createViews
{
    //初始化button
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.enabled = NO;
    btn.tag = 110;
    btn.frame = CGRectMake(kScreenWidth - 35, 20, 20, 20);
    [btn setBackgroundImage:[UIImage imageNamed:@"icon_comment"] forState:UIControlStateNormal];
    [self.contentView addSubview:btn];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
