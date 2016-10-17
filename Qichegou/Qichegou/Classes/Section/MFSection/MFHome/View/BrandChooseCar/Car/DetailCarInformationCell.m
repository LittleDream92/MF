//
//  DetailCarInformationCell.m
//  Qichegou
//
//  Created by Meng Fan on 16/10/14.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DetailCarInformationCell.h"

@interface DetailCarInformationCell ()

@property (nonatomic, strong) UIView *line;

@end

@implementation DetailCarInformationCell

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
        
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews {
    [self.contentView addSubview:self.iconImgView];
    [self.contentView addSubview:self.getCodeBtn];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.writeTF];
    [self.contentView addSubview:self.line];
    
    
    NSInteger leftX1 = 15;
    NSInteger leftX2 = 52;
    if (kScreenHeight > 667) {
        leftX1 = 20;
        leftX2 = 52;
    }
    
    WEAKSELF
    [self.iconImgView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(leftX1);
//        make.size.equalTo(CGSizeMake(25, 25));
    }];
    
    [self.getCodeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(0);
        make.width.equalTo(100);
    }];
    
    [self.lineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(5);
        make.bottom.equalTo(-5);
        make.width.equalTo(1);
        make.right.equalTo(weakSelf.getCodeBtn.mas_left);
    }];
    
    [self.writeTF makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.iconImgView.mas_right).offset(15);
        make.left.equalTo(leftX2);
        make.top.bottom.right.equalTo(0);
    }];
    
    [self.line makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(0);
        make.height.equalTo(1);
    }];
}


#pragma mark - lazyloading
-(UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [UIImageView new];
    }
    return _iconImgView;
}

-(UIButton *)getCodeBtn {
    if (!_getCodeBtn) {
        _getCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _getCodeBtn.titleLabel.font = H14;
        [_getCodeBtn setTitleColor:kskyBlueColor forState:UIControlStateNormal];
    }
    return _getCodeBtn;
}

-(UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = BGGRAYCOLOR;
    }
    return _lineView;
}

-(UITextField *)writeTF {
    if (!_writeTF) {
        _writeTF = [UITextField new];
    }
    return _writeTF;
}

-(UIView *)line {
    if (!_line) {
        _line = [UIView new];
        _line.backgroundColor = BGGRAYCOLOR;
    }
    return _line;
}

#pragma mark - action



@end
