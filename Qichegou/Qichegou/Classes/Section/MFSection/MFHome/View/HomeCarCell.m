//
//  HomeCarCell.m
//  QiChegou
//
//  Created by Meng Fan on 16/9/18.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "HomeCarCell.h"
#import "CarModel.h"
#import "UIImageView+WebCache.h"

@interface HomeCarCell ()

@property (nonatomic, strong) UIImageView *carImgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *describeLabel;
@property (nonatomic, strong) UILabel *priceLabel;


@end

@implementation HomeCarCell

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
        [self.contentView addSubview:self.carImgView];
        [self.carImgView makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(160, 90));
            make.centerY.equalTo(weakSelf);
            make.left.equalTo(5);
        }];
        
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.carImgView.mas_top);
            make.left.equalTo(weakSelf.carImgView.mas_right).offset(5);
        }];
        
        [self.contentView addSubview:self.describeLabel];
        [self.describeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.titleLabel.mas_bottom);
            make.left.equalTo(weakSelf.titleLabel);
            make.right.equalTo(-15);
        }];
        
        [self.contentView addSubview:self.priceLabel];
        [self.priceLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.titleLabel);
            make.top.equalTo(weakSelf.describeLabel.mas_bottom);
        }];
        
        [self.contentView addSubview:self.buyBtn];
        [self.buyBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.titleLabel);
            make.right.equalTo(-15);
            make.bottom.equalTo(weakSelf.carImgView);
        }];
        
       
    }
    return self;
}

#pragma mark - lazyloading
-(UIImageView *)carImgView {
    if (!_carImgView) {
        _carImgView = [[UIImageView alloc] init];
//        _carImgView.backgroundColor = [UIColor brownColor];
        _carImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _carImgView;
}

-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor darkGrayColor];
    }
    return _titleLabel;
}

-(UILabel *)describeLabel {
    if (!_describeLabel) {
        _describeLabel = [[UILabel alloc] init];
        _describeLabel.font = [UIFont systemFontOfSize:13];
        _describeLabel.textColor = [UIColor grayColor];
    }
    return _describeLabel;
}

-(UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont systemFontOfSize:13];
        _priceLabel.textColor = [UIColor orangeColor];
    }
    return _priceLabel;
}

-(UIButton *)buyBtn {
    if (!_buyBtn) {
        _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _buyBtn.layer.cornerRadius = 5;
        _buyBtn.backgroundColor = [UIColor blueColor];
        [_buyBtn setTitle:@"立即订购" forState:UIControlStateNormal];
        [_buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _buyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _buyBtn;
}

#pragma mark - model
-(void)setModel:(CarModel *)model {
    if (_model != model) {
        _model = model;
        
//        NSLog(@"model:%@", model);
        [self.carImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_String, model.main_photo]] placeholderImage:[UIImage imageNamed:@"brand_bg"]];
        
        self.titleLabel.text = [NSString stringWithFormat:@"%@%@", model.brand_name, model.pro_subject];
        self.describeLabel.text = model.car_subject;
        self.priceLabel.text = [NSString stringWithFormat:@"%@万", model.promot_price];
    }
}

@end
