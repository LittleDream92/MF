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
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *salePrice;
@property (nonatomic, strong) UILabel *lastNum;

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
            make.edges.equalTo(UIEdgeInsetsMake(5, 10, 5, 10));
        }];
        
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(5);
            make.centerY.equalTo(weakSelf.contentView);
        }];
        
        [self.contentView addSubview:self.salePrice];
        [self.salePrice makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.titleLabel);
            make.top.equalTo(weakSelf.titleLabel.mas_bottom);
        }];
        
        [self.contentView addSubview:self.lastNum];
        [self.lastNum makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(5);
            make.right.equalTo(-5);
            make.size.equalTo(CGSizeMake(100, 21));
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

-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = H15;
        _titleLabel.textColor = white_color;
        
    }
    return _titleLabel;
}

-(UILabel *)salePrice {
    if (!_salePrice) {
        _salePrice = [[UILabel alloc] init];
        _salePrice.font = H13;
        _salePrice.textColor = ITEMCOLOR;
    }
    return _salePrice;
}

-(UILabel *)lastNum {
    if (!_lastNum) {
        _lastNum = [[UILabel alloc] init];
        _lastNum.textColor = orange_color;
        _lastNum.font = H13;
        _lastNum.textAlignment = NSTextAlignmentCenter;
        _lastNum.backgroundColor = gray_color;
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
        
        NSLog(@"%@", carModel.guide_price);
        self.titleLabel.text = [NSString stringWithFormat:@"%@%@", carModel.brand_name, carModel.pro_subject];
        self.salePrice.text = [NSString stringWithFormat:@"优惠：降%.1f万", sale];
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
