//
//  CarProTableViewCell.h
//  Qichegou
//
//  Created by Meng Fan on 16/4/15.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarModel.h"

@interface CarProTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *childName;

@property (weak, nonatomic) IBOutlet UILabel *carProLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (nonatomic, strong) CarModel *model;

@end
