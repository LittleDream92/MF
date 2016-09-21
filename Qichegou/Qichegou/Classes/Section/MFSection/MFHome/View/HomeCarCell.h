//
//  HomeCarCell.h
//  QiChegou
//
//  Created by Meng Fan on 16/9/18.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SaleCarModel;
@interface HomeCarCell : UITableViewCell

@property (nonatomic, strong) UIButton *buyBtn;

@property (nonatomic, strong) SaleCarModel *model;

@end
