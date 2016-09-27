//
//  PaymoneyTopView.h
//  DKQiCheGou
//
//  Created by Song Gao on 16/1/18.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseCarModel.h"

@interface PaymoneyTopView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *colorLabel;
@property (nonatomic, strong) UILabel *neishiLabel;
@property (nonatomic, strong) UILabel *buycarWayLabel;
@property (nonatomic, strong) UILabel *buycarTimeLabel;

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *dingjinLabel;
//定金
@property (nonatomic, strong) UILabel *pre_priceLabel;


/*
 * 网络请求后调用此方法赋值
 */
- (void)createTopViewWithChooseCarModel:(ChooseCarModel *)model;


@end
