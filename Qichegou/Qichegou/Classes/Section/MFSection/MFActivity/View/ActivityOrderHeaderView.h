//
//  ActivityOrderHeaderView.h
//  Qichegou
//
//  Created by Meng Fan on 16/3/7.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityOrderHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (weak, nonatomic) IBOutlet UILabel *activityTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *activityPriceLabel;


- (void)createWithIDstring:(NSArray *)array;

@end
