//
//  BaoDanTableViewCell.m
//  Qichegou
//
//  Created by Meng Fan on 16/6/20.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "BaoDanTableViewCell.h"

@implementation BaoDanTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//
//-(void)setModel:(InsuranceModel *)model {
//    if (_model != model) {
//     
//        _model = model;
//        
//        [self setNeedsLayout];
//    }
//}
//
//-(void)layoutSubviews {
//    [super layoutSubviews];
//    
//    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_String, self.model.logo]] placeholderImage:[UIImage imageNamed:@"bg_default"]];
//    self.label.text = self.model.name;
//}

@end
