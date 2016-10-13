//
//  SaleDetalHeaderTableViewCell.m
//  Qichegou
//
//  Created by Meng Fan on 16/10/8.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "SaleDetalHeaderTableViewCell.h"
#import "CarModel.h"

@interface SaleDetalHeaderTableViewCell ()

@property (nonatomic, strong) UIImageView *headerCarImgView;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *guidPrice;
@property (nonatomic, strong) UILabel *salePrice;

@end

@implementation SaleDetalHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        WEAKSELF
        [self.contentView addSubview:self.headerCarImgView];
        [self.headerCarImgView makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(0);
            make.height.equalTo(150);
        }];
        
        [self.contentView addSubview:self.bgView];
        [self.bgView makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(weakSelf.headerCarImgView);
            make.height.equalTo(weakSelf.headerCarImgView.mas_height);
        }];
        
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(20);
            make.top.equalTo(weakSelf.bgView.mas_bottom).offset(10);
        }];
        
        [self.contentView addSubview:self.guidPrice];
        [self.guidPrice makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.titleLabel.mas_left);
            make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(8);
        }];
        
        [self.contentView addSubview:self.salePrice];
        [self.salePrice makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.titleLabel.mas_left);
            make.top.equalTo(weakSelf.guidPrice.mas_bottom).offset(3);
        }];
    }
    return self;
}


#pragma mark - lazyloading
-(UIImageView *)headerCarImgView {
    if (!_headerCarImgView) {
        _headerCarImgView = [[UIImageView alloc] init];
        _headerCarImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _headerCarImgView;
}

-(UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    }
    return _bgView;
}

-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel createLabelWithFontSize:13 color:TEXTCOLOR];
    }
    return _titleLabel;
}

-(UILabel *)guidPrice {
    if (!_guidPrice) {
        _guidPrice = [[UILabel alloc] init];
        [_guidPrice createLabelWithFontSize:13 color:GRAYCOLOR];
    }
    return _guidPrice;
}

-(UILabel *)salePrice {
    if (!_salePrice) {
        _salePrice = [[UILabel alloc] init];
#warning orange color
//        [_salePrice createLabelWithFontSize:13 color:ITEMCOLOR];
    }
    return _salePrice;
}


#pragma mark - 
-(void)setModel:(CarModel *)model {
    if (_model != model) {
        _model = model;
        
        [self.headerCarImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_String, model.main_photo]] placeholderImage:[UIImage imageNamed:@"bg_default"]];
        
        self.titleLabel.text = [NSString stringWithFormat:@"%@%@%@",model.brand_name, model.pro_subject, model.car_subject];
        
        self.guidPrice.text = [NSString stringWithFormat:@"%@万", model.price];
        
        self.salePrice.text = [NSString stringWithFormat:@"特价：%@万", model.promot_price];
    }
}

@end
