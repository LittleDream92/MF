//
//  CarListTableViewCell.m
//  Qichegou
//
//  Created by Meng Fan on 16/4/12.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "CarListTableViewCell.h"

@implementation CarListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setMyModel:(CarModel *)myModel {
    if (_myModel != myModel) {
        _myModel = myModel;
        
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_String, self.myModel.main_photo]] placeholderImage:[UIImage imageNamed:@"bg_default"]];
    
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.text = [NSString stringWithFormat:@"%@", self.myModel.car_subject];
    self.detailTitleLabel.text = [NSString stringWithFormat:@"%@", self.myModel.pro_subject];
}

@end
