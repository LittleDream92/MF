//
//  HomeOperationCell.m
//  QiChegou
//
//  Created by Meng Fan on 16/9/18.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "HomeOperationCell.h"
#import "UIViewExt.h"

@interface HomeOperationCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation HomeOperationCell

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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.centerY.equalTo(weakSelf);
        }];
        
        [self.contentView addSubview:self.moreBtn];
        [self.moreBtn makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(50, 35));
            make.centerY.equalTo(weakSelf);
            make.right.equalTo(-5);
        }];
        
        [self.contentView addSubview:self.lineView];
        [self.lineView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(45, 0, 0, 0));
        }];
    }
    return self;
}


#pragma mark - lazyloading
-(UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [[UIButton alloc] init];
        _moreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_moreBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    }
    return _moreBtn;
}

-(UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor orangeColor];
    }
    return _lineView;
}

-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"特价车型";
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor darkGrayColor];

    }
    return _titleLabel;
}


#pragma mark - action



@end
