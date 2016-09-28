//
//  BaoDanTableViewCell.h
//  Qichegou
//
//  Created by Meng Fan on 16/6/20.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InsuranceModel.h"

@interface BaoDanTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *label;

/* 数据源 */
@property (nonatomic, strong) InsuranceModel *model;


@end
