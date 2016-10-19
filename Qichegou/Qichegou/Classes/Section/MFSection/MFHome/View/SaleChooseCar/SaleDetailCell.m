//
//  SaleDetailCell.m
//  QiChegou
//
//  Created by Meng Fan on 16/9/26.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "SaleDetailCell.h"
#import "CarModel.h"
#import "UIImageView+WebCache.h"

@interface SaleDetailCell ()

@property (nonatomic, strong) UIImageView *carBgView;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *labelView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *salePrice;
@property (nonatomic, strong) UILabel *lastNum;

@property (nonatomic, strong) UILabel *saleLabel1;
@property (nonatomic, strong) UILabel *saleNum;

@end

@implementation SaleDetailCell

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
        
        WEAKSELF
        [self.contentView addSubview:self.carBgView];
        [self.carBgView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(10, 20, 0, 20));
        }];
        
        [self.contentView addSubview:self.bgView];
        [self.bgView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(20);
            make.right.equalTo(-20);
            make.top.equalTo(10);
            make.bottom.equalTo(0);
        }];
        
        [self.bgView addSubview:self.labelView];
        [self.labelView makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.height.equalTo(20);
        }];
        
        [self.labelView addSubview:self.titleLabel];
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(20);
            make.centerY.equalTo(weakSelf.labelView);
        }];

        [self.labelView addSubview:self.salePrice];
        [self.salePrice makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-15);
            make.centerY.equalTo(weakSelf.labelView);
        }];
        
        [self.labelView addSubview:self.saleNum];
        [self.saleNum makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.salePrice.mas_left);
            make.centerY.equalTo(weakSelf.labelView);
        }];
        
        [self.labelView addSubview:self.saleLabel1];
        [self.saleLabel1 makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.saleNum.mas_left);
            make.centerY.equalTo(weakSelf.labelView);
        }];
        
        [self.bgView addSubview:self.lastNum];
        [self.lastNum makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(5);
            make.right.equalTo(0);
            make.size.equalTo(CGSizeMake(90, 21));
        }];
    }
    return self;
}

#pragma mark - lazyloading
-(UIImageView *)carBgView {
    if (!_carBgView) {
        _carBgView = [[UIImageView alloc] init];
        _carBgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _carBgView;;
}

-(UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1];
    }
    return _bgView;
}

-(UIView *)labelView {
    if (!_labelView) {
        _labelView = [[UIView alloc] init];
        _labelView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sale"]];
    }
    return _labelView;
}

-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = H13;
        _titleLabel.textColor = white_color;
        
    }
    return _titleLabel;
}

-(UILabel *)saleLabel1 {
    if (!_saleLabel1) {
        _saleLabel1 = [[UILabel alloc] init];
        _saleLabel1.font = H12;
        _saleLabel1.textColor = white_color;
        _saleLabel1.text = @"优惠：降";
    }
    return _saleLabel1;
}

-(UILabel *)saleNum {
    if (!_saleNum) {
        _saleNum = [[UILabel alloc] init];
        _saleNum.font = [UIFont boldSystemFontOfSize:15];
        _saleNum.textColor = kRedColor;
    }
    return _saleNum;
}

-(UILabel *)salePrice {
    if (!_salePrice) {
        _salePrice = [[UILabel alloc] init];
        _salePrice.font = H12;
        _salePrice.textColor = white_color;
        _salePrice.text = @"万";
    }
    return _salePrice;
}

-(UILabel *)lastNum {
    if (!_lastNum) {
        _lastNum = [[UILabel alloc] init];
        _lastNum.textColor = white_color;
        _lastNum.font = H13;
        _lastNum.textAlignment = NSTextAlignmentCenter;
        _lastNum.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sale_num"]];
    }
    return _lastNum;
}

#pragma mark - set
-(void)setCarModel:(CarModel *)carModel {
    if (_carModel != carModel) {
        _carModel = carModel;
        
        [self.carBgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_String, carModel.main_photo]] placeholderImage:[UIImage imageNamed:@""]];
//        UIImage *bgImage = [self getImageFromURL:[NSString stringWithFormat:@"%@%@", URL_String, carModel.main_photo]];
//        UIGraphicsBeginImageContext(self.carBgView.frame.size);
//        
//        [bgImage drawInRect:CGRectMake(0, 0, self.carBgView.frame.size.width, self.carBgView.frame.size.height)];
//        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        
//        self.carBgView.image = image;
        
        CGFloat sale = [carModel.guide_price floatValue] - [carModel.promot_price floatValue];
        
//        NSLog(@"%@", carModel.guide_price);
        self.titleLabel.text = [NSString stringWithFormat:@"%@%@", carModel.brand_name, carModel.pro_subject];
        self.saleNum.text = [NSString stringWithFormat:@"%.1f", sale];
        self.lastNum.text = [NSString stringWithFormat:@"剩余%@辆", carModel.promot_num];
    }
}

#pragma mark - action
//-(UIImage *) getImageFromURL:(NSString *)fileURL {
//    NSLog(@"执行图片下载函数");
//    UIImage * result;
//    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
//    result = [UIImage imageWithData:data];
//    return result;
//}

@end
