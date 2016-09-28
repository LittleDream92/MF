//
//  CarListTableViewCell.h
//  Qichegou
//
//  Created by Meng Fan on 16/4/12.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CarModel;
@interface CarListTableViewCell : UITableViewCell

//数据源
@property (nonatomic, strong) CarModel *myModel;

@end
