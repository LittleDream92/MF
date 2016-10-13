//
//  MyOrderCell.h
//  BuyCar
//
//  Created by Song Gao on 15/12/31.
//  Copyright © 2015年 Meng Fan. All rights reserved.
//
/*我的订单*/
#import <UIKit/UIKit.h>

@class CarOrderModel;
@interface MyOrderCell : UITableViewCell


//数据源
@property (nonatomic, strong) CarOrderModel *model;

@end
