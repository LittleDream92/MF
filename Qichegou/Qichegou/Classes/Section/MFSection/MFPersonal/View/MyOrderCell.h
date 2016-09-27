//
//  MyOrderCell.h
//  BuyCar
//
//  Created by Song Gao on 15/12/31.
//  Copyright © 2015年 Meng Fan. All rights reserved.
//
/*我的订单*/
#import <UIKit/UIKit.h>

#import "ChooseCarModel.h"

@interface MyOrderCell : UITableViewCell

@property (nonatomic, strong) UIButton *operationBtn;

@property (weak, nonatomic) IBOutlet UILabel *orderIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *carImgView;
@property (weak, nonatomic) IBOutlet UILabel *carTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *offLineLabel;


//数据源
@property (nonatomic, strong) ChooseCarModel *model;

@end
