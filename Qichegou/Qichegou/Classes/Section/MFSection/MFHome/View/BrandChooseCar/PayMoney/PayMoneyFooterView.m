//
//  PayMoneyFooterView.m
//  Qichegou
//
//  Created by Song Gao on 16/1/26.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "PayMoneyFooterView.h"

@implementation PayMoneyFooterView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        self.backgroundColor = white_color;
        [self createViews];
    }
    return self;
}

- (void)createViews {
//    //初始化横线视图
//    lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 5, kScreenWidth - 30, 1)];
//    lineView.backgroundColor = kplayceGrayColor;
//    [self addSubview:lineView];
//    
//    //初始化提示文字
//    [self createLabelView];
}

- (void)createLabelView {
//    myView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth - 200)/2, lineView.bottom+5, 200, 20*kHeightSale)];
//    [self addSubview:myView];
//    
//    [self createMyView];
//    
//    
//    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, myView.bottom, kScreenWidth, 15)];
//    [label2 createLabelWithFontSize:10 color:GRAYCOLOR];
//    label2.textAlignment = NSTextAlignmentCenter;
//    label2.text = @"请在7天内完成，否则您的订单将自动取消";
//    NSMutableAttributedString *attrString= [label2 makeDifferentColorWithText:label2.text colorText:@"7" color:ITEMCOLOR];
//    [label2 setAttributedText:attrString];
//    [self addSubview:label2];
}

- (void)createMyView {
//    UIImageView *iconView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
//    iconView1.image = [UIImage imageNamed:@"icon_select"];
//    [myView addSubview:iconView1];
//    
//    //
//    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(iconView1.right, 0, 0, 0)];
//    [label1 createLabelWithFontSize:10 color:TEXTCOLOR];
//    label1.text = @"预付款到汽车购";
//    [label1 sizeToFit];
//    [myView addSubview:label1];
//    
//    UIImageView *iconView2 = [[UIImageView alloc] initWithFrame:CGRectMake(label1.right + 10, 0, 10, 10)];
//    iconView2.image = [UIImage imageNamed:@"icon_select"];
//    [myView addSubview:iconView2];
//    
//    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(iconView2.right, 0, 0, 0)];
//    [label2 createLabelWithFontSize:10 color:TEXTCOLOR];
//    label2.text = @"随时退";
//    [label2 sizeToFit];
//    [myView addSubview:label2];
//    
//    UIImageView *iconView3 = [[UIImageView alloc] initWithFrame:CGRectMake(label2.right + 10, 0, 10, 10)];
//    iconView3.image = [UIImage imageNamed:@"icon_select"];
//    [myView addSubview:iconView3];
//    
//    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(iconView3.right, 0, 0, 0)];
//    [label3 createLabelWithFontSize:10 color:TEXTCOLOR];
//    label3.text = @"可抵购车款";
//    [label3 sizeToFit];
//    [myView addSubview:label3];
    
}


@end
