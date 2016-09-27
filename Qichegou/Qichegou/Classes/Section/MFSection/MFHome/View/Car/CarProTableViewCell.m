//
//  CarProTableViewCell.m
//  Qichegou
//
//  Created by Meng Fan on 16/4/15.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "CarProTableViewCell.h"

@implementation CarProTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(CarModel *)model {
    if (_model != model) {
        _model = model;
        
        [self setNeedsLayout];
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_String, self.model.img]] placeholderImage:[UIImage imageNamed:@"bg_default"]];
    
    self.carProLabel.text = self.model.pro_subject;
    
    if (self.model.child_brand_name) {
        self.childName.text = self.model.child_brand_name;
    }
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@万 － ¥%@万", self.model.min_price, self.model.max_price];
 
}

@end
