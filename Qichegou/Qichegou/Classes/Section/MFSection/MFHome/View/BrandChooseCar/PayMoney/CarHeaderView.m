//
//  CarHeaderView.m
//  Qichegou
//
//  Created by Song Gao on 16/1/27.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "CarHeaderView.h"
#import "CarOrderModel.h"

@interface CarHeaderView ()

@property (nonatomic, strong) UIImageView *carImgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *guide_priceLabel;

@end

@implementation CarHeaderView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //
        [self createViews];
    }
    return self;
}

-(void)awakeFromNib {
    [self createViews];
}


- (void)createViews {
    WEAKSELF
    [self addSubview:self.carImgView];
    [self.carImgView makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(80, 70));
        make.left.equalTo(20);
        make.centerY.equalTo(weakSelf);
    }];
    
    [self addSubview:self.titleLabel];
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.carImgView.mas_right).offset(15);
        make.right.equalTo(20);
        make.top.equalTo(15);
        make.height.equalTo(20);
    }];
    
    [self addSubview:self.guide_priceLabel];
    [self.guide_priceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLabel.mas_left);
        make.right.equalTo(weakSelf.titleLabel.mas_right);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(10);
        make.height.equalTo(21);
    }];
}

#pragma mark - lazyloading
-(UIImageView *)carImgView {
    if (!_carImgView) {
        _carImgView = [[UIImageView alloc] init];
        _carImgView.contentMode = UIViewContentModeScaleAspectFit;
        _carImgView.image = [UIImage imageNamed:@"bg_default"];
    }
    return _carImgView;
}

-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel createLabelWithFontSize:14 color:TEXTCOLOR];
    }
    return _titleLabel;
}

-(UILabel *)guide_priceLabel {
    if (!_guide_priceLabel) {
        _guide_priceLabel = [[UILabel alloc] init];
        [_guide_priceLabel createLabelWithFontSize:12 color:GRAYCOLOR];
    }
    return _guide_priceLabel;
}

#pragma mark -
- (void)createViewWithModel:(CarOrderModel *)carModel {
    //赋值
    if (carModel.main_photo.length > 0) {
        [self.carImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_String, carModel.main_photo]] placeholderImage:[UIImage imageNamed:@"bg_default"]];
    }

    self.titleLabel.text = [NSString stringWithFormat:@"%@ %@ %@", carModel.brand_name, carModel.pro_subject, carModel.car_subject];
    [self.titleLabel sizeToFit];
    self.guide_priceLabel.text = [NSString stringWithFormat:@"厂家指导价：%@万", carModel.guide_price];
}


@end
