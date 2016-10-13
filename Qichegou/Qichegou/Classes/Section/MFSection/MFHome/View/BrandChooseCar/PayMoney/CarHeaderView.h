//
//  CarHeaderView.h
//  Qichegou
//
//  Created by Song Gao on 16/1/27.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CarOrderModel;
@interface CarHeaderView : UIView

- (void)createViewWithModel:(CarOrderModel *)carModel;

@end
