//
//  DetailFooterView.m
//  Qichegou
//
//  Created by Meng Fan on 16/6/20.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DetailFooterView.h"

@implementation DetailFooterView

-(void)awakeFromNib {
    [super awakeFromNib];
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.button.imageEdgeInsets = UIEdgeInsetsMake(0, 115, 0, -115);
    self.button.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);

}

/**/
- (void)createFooterViewWithInsuranceModel:(InsuranceModel *)model {
    
    
    if (model) {

        self.baoxianLabel.text = [NSString stringWithFormat:@"联系%@", model.com_name];
        self.baoxiantelLabel.text = model.com_phone;
    }
    
}

@end
