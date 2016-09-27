//
//  HomeMenuCell.m
//  QiChegou
//
//  Created by Meng Fan on 16/9/18.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "HomeMenuCell.h"
#import "HomeBtn.h"

#define kItemWidth (kScreenWidth/4)

@interface HomeMenuCell ()

@property (nonatomic, strong) HomeBtn *brandBtn;
@property (nonatomic, strong) HomeBtn *saleBtn;
@property (nonatomic, strong) HomeBtn *daiBtn;
@property (nonatomic, strong) HomeBtn *xianBtn;

@end

@implementation HomeMenuCell

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
        [self.contentView addSubview:self.brandBtn];
        [self.contentView addSubview:self.saleBtn];
        [self.contentView addSubview:self.daiBtn];
        [self.contentView addSubview:self.xianBtn];
        
        CGFloat padding = 0;
        
        WEAKSELF
        [self.brandBtn makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@kItemWidth);
            make.height.equalTo(80);
            make.centerY.equalTo(weakSelf);
            make.left.equalTo(padding);
        }];
        
        [self.saleBtn makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(weakSelf.brandBtn);
            make.height.equalTo(weakSelf.brandBtn);
            make.centerY.equalTo(weakSelf);
            make.left.equalTo(weakSelf.brandBtn.mas_right).offset(padding);
        }];
        
        [self.daiBtn makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(weakSelf.brandBtn);
            make.height.equalTo(weakSelf.brandBtn);
            make.centerY.equalTo(weakSelf);
            make.left.equalTo(weakSelf.saleBtn.mas_right).offset(padding);
        }];
        
        [self.xianBtn makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(weakSelf.brandBtn);
            make.height.equalTo(weakSelf.brandBtn);
            make.centerY.equalTo(weakSelf);
            make.left.equalTo(weakSelf.daiBtn.mas_right).offset(padding);
        }];
    }
    return self;
}

#pragma mark - lazyloading
-(HomeBtn *)brandBtn {
    if (!_brandBtn) {
        _brandBtn = [HomeBtn buttonWithType:UIButtonTypeCustom];
        [_brandBtn setImage:[UIImage imageNamed:@"Menu1"] forState:UIControlStateNormal];
        [_brandBtn setTitle:@"品牌选车" forState:UIControlStateNormal];
        [_brandBtn addTarget:self action:@selector(brandAction:) forControlEvents:UIControlEventTouchUpInside];
        [_brandBtn setBackgroundColor:[UIColor cyanColor]];
    }
    return _brandBtn;
}

-(HomeBtn *)saleBtn {
    if (!_saleBtn) {
        _saleBtn = [HomeBtn buttonWithType:UIButtonTypeCustom];
        [_saleBtn setImage:[UIImage imageNamed:@"Menu1"] forState:UIControlStateNormal];
        [_saleBtn setTitle:@"特价购车" forState:UIControlStateNormal];
        [_saleBtn addTarget:self action:@selector(saleAction:) forControlEvents:UIControlEventTouchUpInside];
        [_saleBtn setBackgroundColor:[UIColor brownColor]];
    }
    return _saleBtn;
}

-(HomeBtn *)daiBtn {
    if (!_daiBtn) {
        _daiBtn = [HomeBtn buttonWithType:UIButtonTypeCustom];
        [_daiBtn setImage:[UIImage imageNamed:@"Menu1"] forState:UIControlStateNormal];
        [_daiBtn setTitle:@"我要车险" forState:UIControlStateNormal];
        [_daiBtn addTarget:self action:@selector(daiAction:) forControlEvents:UIControlEventTouchUpInside];
        [_daiBtn setBackgroundColor:[UIColor redColor]];
    }
    return _daiBtn;
}

-(HomeBtn *)xianBtn {
    if (!_xianBtn) {
        _xianBtn = [HomeBtn buttonWithType:UIButtonTypeCustom];
        [_xianBtn setImage:[UIImage imageNamed:@"Menu1"] forState:UIControlStateNormal];
        [_xianBtn setTitle:@"健康洗车" forState:UIControlStateNormal];
        [_xianBtn addTarget:self action:@selector(xianAction:) forControlEvents:UIControlEventTouchUpInside];
        [_xianBtn setBackgroundColor:[UIColor yellowColor]];
    }
    return _xianBtn;
}

#pragma mark - action
- (void)brandAction:(HomeBtn *)sender {
    if (self.clickBrandBtn) {
        self.clickBrandBtn();
    }
}

- (void)saleAction:(HomeBtn *)sender {
    if (self.clickSaleBtn) {
        self.clickSaleBtn();
    }
}


- (void)daiAction:(HomeBtn *)sender {
    if (self.clickDaiBtn) {
        self.clickDaiBtn();
    }
}

- (void)xianAction:(HomeBtn *)sender {
    if (self.clickXianBtn) {
        self.clickXianBtn();
    }
}

@end
