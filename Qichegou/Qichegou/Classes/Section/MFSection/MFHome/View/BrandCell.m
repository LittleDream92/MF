//
//  BrandCell.m
//  QiChegou
//
//  Created by Meng Fan on 16/9/26.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "BrandCell.h"
#import "UIImageView+WebCache.h"
#import "CarModel.h"

@interface BrandCell ()

@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation BrandCell

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
        [self.contentView addSubview:self.iconImg];
        [self.iconImg makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(24, 24));
            make.centerY.equalTo(weakSelf);
            make.left.equalTo(15);
        }];
        
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf);
            make.left.equalTo(weakSelf.iconImg.mas_right).offset(15);
        }];
    }
    return self;
}
#pragma mark - lazyloading
-(UIImageView *)iconImg {
    if (!_iconImg) {
        _iconImg = [[UIImageView alloc] init];
    }
    return _iconImg;
}

-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = TEXTCOLOR;
        _titleLabel.font = H16;
    }
    return _titleLabel;
}


#pragma mark - set
-(void)setBrandModel:(CarModel *)brandModel {
    if (_brandModel != brandModel) {
        _brandModel = brandModel;
        
//        NSLog(@"%@", brandModel);
        [self.iconImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_String, brandModel.thumb]] placeholderImage:[UIImage imageNamed:@"brand_bg"]];
        
        self.titleLabel.text = brandModel.brand_name;
    }
}

@end
