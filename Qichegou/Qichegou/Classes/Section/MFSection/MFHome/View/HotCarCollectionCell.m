//
//  HotCarCollectionCell.m
//  QiChegou
//
//  Created by Meng Fan on 16/9/26.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "HotCarCollectionCell.h"
#import "UIImageView+WebCache.h"
#import "CarModel.h"

@interface HotCarCollectionCell ()

@property (nonatomic, strong) UIImageView *carView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation HotCarCollectionCell

-(instancetype)init {
    self = [super init];
    if (self) {
        [self setUpViews];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews {
    
    WEAKSELF
    [self.contentView addSubview:self.carView];
    [self.carView makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(50, 50));
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(5);
    }];
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.carView.mas_bottom).offset(5);
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.height.equalTo(20);
    }];
}


#pragma mark - lazyloading
-(UIImageView *)carView {
    if (!_carView) {
        _carView = [[UIImageView alloc] init];
        _carView.contentMode = UIViewContentModeScaleToFill;
    }
    return _carView;
}

-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = TEXTCOLOR;
        _titleLabel.font = H16;
    }
    return _titleLabel;
}

#pragma mark - set
-(void)setModel:(CarModel *)model {
    if (_model != model) {
        _model = model;
        
        NSLog(@"co cell:%@", model);
        
        [self.carView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_String, model.thumb]] placeholderImage:[UIImage imageNamed:@"brand_bg"]];
        self.titleLabel.text = model.brand_name;
    }
}

@end
