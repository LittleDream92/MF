//
//  DetailFooterView.h
//  Qichegou
//
//  Created by Meng Fan on 16/6/20.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InsuranceModel.h"

@interface DetailFooterView : UIView


@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *baoxianLabel;
@property (weak, nonatomic) IBOutlet UILabel *baoxiantelLabel;


/**/
- (void)createFooterViewWithInsuranceModel:(InsuranceModel *)model;

@end
