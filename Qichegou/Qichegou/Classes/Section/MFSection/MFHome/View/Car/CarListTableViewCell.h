//
//  CarListTableViewCell.h
//  Qichegou
//
//  Created by Meng Fan on 16/4/12.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarModel.h"

@interface CarListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailTitleLabel;


//数据源
@property (nonatomic, strong) CarModel *myModel;

@end
