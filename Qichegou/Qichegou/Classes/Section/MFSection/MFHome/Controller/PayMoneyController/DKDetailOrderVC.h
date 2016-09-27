//
//  DKDetailOrderVC.h
//  Qichegou
//
//  Created by Song Gao on 16/1/27.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

//订单详情页--待付款
#import "DKBaseViewController.h"
#import "ChooseCarModel.h"

@interface DKDetailOrderVC : DKBaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    UIButton *continueBtn;
}

@property (nonatomic, strong) UITableView *detailOrderTV;

//参数
@property (nonatomic, strong) NSString *orderIDString;

//数据源
@property (nonatomic, strong) ChooseCarModel *myModel;

@end
