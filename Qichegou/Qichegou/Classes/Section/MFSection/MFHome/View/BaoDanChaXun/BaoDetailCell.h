//
//  BaoDetailCell.h
//  Qichegou
//
//  Created by Meng Fan on 16/6/22.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InsuranceModel.h"

@interface BaoDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *view;

//上一个View
@property (nonatomic, strong) UIView *lastView;


//>>>>>>>>>>>>>>
//车损险
@property (nonatomic, strong) UIView *chesunView;
@property (nonatomic, strong) UILabel *chesunELabel;
@property (nonatomic, strong) UILabel *chesunLabel;
//不计免赔（车损)
@property (nonatomic, strong) UIView *bujiChesunView;
@property (nonatomic, strong) UILabel *bujiChesunLabel;
//车损之4S店专修险
@property (nonatomic, strong) UIView *xiuView;
@property (nonatomic, strong) UILabel *xiuLabel;
//车损之玻璃破损险
@property (nonatomic, strong) UIView *boliView;
@property (nonatomic, strong) UILabel *boliLabel;

//>>>>>>>>>>>>>>
//司机座位责任险
@property (nonatomic, strong) UIView *sijiView;
@property (nonatomic, strong) UILabel *sijiELabel;
@property (nonatomic, strong) UILabel *sijiLabel;
//不计免赔（司机）
@property (nonatomic, strong) UIView *bujiDrView;
@property (nonatomic, strong) UILabel *bujiDrLabel;


//>>>>>>>>>>>>>>
//乘客座位责任险
@property (nonatomic, strong) UIView *passengerView;
@property (nonatomic, strong) UILabel *passengerELabel;
@property (nonatomic, strong) UILabel *passengerLabel;
//不计免赔（乘客）
@property (nonatomic, strong) UIView *bujiPaView;
@property (nonatomic, strong) UILabel *bujiPaLabel;


//第三者责任险
@property (nonatomic, strong) UIView *sanView;
@property (nonatomic, strong) UILabel *sanELabel;
@property (nonatomic, strong) UILabel *sanLabel;
//不计免赔（三者）
@property (nonatomic, strong) UIView *bujiSanView;
@property (nonatomic, strong) UILabel *bujiSanLabel;


//全车盗抢险
@property (nonatomic, strong) UIView *daoView;
@property (nonatomic, strong) UILabel *daoLabel;
//不计免赔（盗抢）
@property (nonatomic, strong) UIView *bujiDaoView;
@property (nonatomic, strong) UILabel *bujiDaoLabel;








//新车重置险
@property (nonatomic, strong) UIView *reView;
@property (nonatomic, strong) UILabel *reLabel;

//车船税
@property (nonatomic, strong) UIView *chuanView;
@property (nonatomic, strong) UILabel *chuanLabel;
//交强险
@property (nonatomic, strong) UIView *qiangView;
@property (nonatomic, strong) UILabel *qiangLabel;

//总计
@property (nonatomic, strong) UIView *totalView;
@property (nonatomic, strong) UILabel *totalPriceLabel;





//数据源
@property (nonatomic, strong) InsuranceModel *model;


@end
