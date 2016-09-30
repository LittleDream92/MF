//
//  CondationCollectionCell.m
//  DKQiCheGou
//
//  Created by Song Gao on 16/1/13.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "CondationCollectionCell.h"

@implementation CondationCollectionCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        [self createViews];
    }
    return self;
}

-(void)awakeFromNib
{
    [self createViews];
}

- (void)createViews {

    [self.contentView addSubview:self.carImgView];
    [self.carImgView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.top.equalTo(0);
        make.height.equalTo(80);
    }];
    
    [self.contentView addSubview:self.carLabel];
    [self.carLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.top.equalTo(75);
    }];
}

#pragma mark - lazyloading
-(UIImageView *)carImgView {
    if (!_carImgView) {
        _carImgView = [[UIImageView alloc] init];
//        _carImgView.backgroundColor = red_color;
        _carImgView.contentMode = UIViewContentModeScaleAspectFit;
        _carImgView.userInteractionEnabled = YES;
    }
    return _carImgView;
}

-(UILabel *)carLabel {
    if (!_carLabel) {
        _carLabel = [[UILabel alloc] init];
        [_carLabel createLabelWithFontSize:13 color:TEXTCOLOR];
        _carLabel.textAlignment = NSTextAlignmentCenter;
//        _carLabel.backgroundColor = [UIColor cyanColor];
        _carLabel.userInteractionEnabled = YES;
    }
    return _carLabel;
}

@end
