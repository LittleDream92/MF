//
//  ActivityOrderHeaderView.m
//  Qichegou
//
//  Created by Meng Fan on 16/3/7.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "ActivityOrderHeaderView.h"


@implementation ActivityOrderHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)createWithIDstring:(NSArray *)array
{
    //订单号label
    self.numberLabel.text = [NSString stringWithFormat:@"订单编号：%@", array[0]];
    
    //title
    self.activityTitleLabel.text = [NSString stringWithFormat:@"活动标题：%@", array[1]];
    
    //price
    self.activityPriceLabel.text = [NSString stringWithFormat:@"订单金额：%@", array[2]];
}

@end
