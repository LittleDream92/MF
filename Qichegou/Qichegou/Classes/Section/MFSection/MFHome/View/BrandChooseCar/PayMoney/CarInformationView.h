//
//  CarInformationView.h
//  Qichegou
//
//  Created by Song Gao on 16/1/27.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CarOrderModel;
@interface CarInformationView : UIView

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

- (void)createCellViewWithModel:(CarOrderModel *)model;

@end
