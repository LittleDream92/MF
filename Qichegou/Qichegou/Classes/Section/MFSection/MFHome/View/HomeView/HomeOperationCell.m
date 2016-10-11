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
@property (nonatomic, strong) UIButton *moreBtn;

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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        WEAKSELF
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(20);
            make.centerY.equalTo(weakSelf);
        }];
        
        [self.contentView addSubview:self.moreBtn];
        [self.moreBtn makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(60, 35));
            make.centerY.equalTo(weakSelf);
            make.right.equalTo(-5);
        }];
        
        [self.contentView addSubview:self.lineView];
        [self.lineView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(self.frame.size.height-5, 0, 0, 0));
        }];
    }
    return self;
}


#pragma mark - lazyloading
-(UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [[UIButton alloc] init];
        _moreBtn.titleLabel.font = H14;
        [_moreBtn setTitleColor:TEXTCOLOR forState:UIControlStateNormal];
        [_moreBtn setTitle:@"更多" forState:UIControlStateNormal];
        [_moreBtn setImage:[UIImage imageNamed:@"more_right"] forState:UIControlStateNormal];
        _moreBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        _moreBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0);
        [_moreBtn addTarget:self action:@selector(moreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

-(UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = RGB(224, 224, 244);
    }
    return _lineView;
}

-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"特价车型";
        _titleLabel.font = H14;
        _titleLabel.textColor = TEXTCOLOR;

    }
    return _titleLabel;
}


#pragma mark - action
- (void)moreBtnAction:(UIButton *)sender {
    if (self.clickMoreSaleBtn) {
        self.clickMoreSaleBtn();
    }
}


@end
