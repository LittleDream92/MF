//
//  DKDetailOrderVC.h
//  Qichegou
//
//  Created by Song Gao on 16/1/27.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DKBaseViewController.h"

@class CarOrderModel;
@interface DKDetailOrderVC : DKBaseViewController

//参数
@property (nonatomic, strong) NSString *orderIDString;

//数据源
@property (nonatomic, strong) CarOrderModel *myModel;

@end
