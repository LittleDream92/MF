//
//  CarProTableViewCell.m
//  Qichegou
//
//  Created by Meng Fan on 16/4/15.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "CarProTableViewCell.h"
#import "CarModel.h"

@interface CarProTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *carProLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;

@end

@implementation CarProTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - set
-(void)setModel:(CarModel *)model {
    if (_model != model) {
        _model = model;
        
        [self setNeedsLayout];
    }
}

#pragma mark -
-(void)layoutSubviews {
    [super layoutSubviews];
    
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_String, self.model.img]] placeholderImage:[UIImage imageNamed:@"bg_default"]];
    
    self.carProLabel.text = self.model.pro_subject;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@万 － ¥%@万", self.model.min_price, self.model.max_price];
 
}

@end
