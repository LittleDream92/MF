//
//  DKPayMoneyVC.h
//  DKQiCheGou
//
//  Created by Song Gao on 16/1/18.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DKBaseViewController.h"

@class CarOrderModel;
@interface DKPayMoneyVC : DKBaseViewController

//数据源
@property (nonatomic, strong) CarOrderModel *myModel;

//订单编号
@property (nonatomic, copy) NSString *orderIDString;


@end
