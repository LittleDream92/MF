//
//  CarHeaderView.h
//  Qichegou
//
//  Created by Song Gao on 16/1/27.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ChooseCarModel.h"

@interface CarHeaderView : UIView
{
    UIImageView *carImgView;
    UILabel *titleLabel;
    UILabel *guide_priceLabel;
}



- (void)createViewWithModel:(ChooseCarModel *)carModel;

@end
