//
//  CityControl.m
//  Qichegou
//
//  Created by Meng Fan on 16/3/10.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "CityControl.h"

#define CityImgViewW 16
#define CityImgViewH 9

@interface CityControl ()



@end

@implementation CityControl

#pragma mark - 自定义初始化方法 一
-(instancetype)initWithFrame:(CGRect)frame
                  cityString:(NSString *)cityStr
{
    self = [super initWithFrame:frame];
    if (self) {
        
        WEAKSELF
        [self addSubview:self.cityLabel];
        [self.cityLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.centerY.equalTo(weakSelf);
        }];
        
        self.cityLabel.text = cityStr;
        
        [self addSubview:self.downArrowImgView];
        [self.downArrowImgView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.cityLabel.mas_right).offset(5);
            make.size.equalTo(CGSizeMake(16, 9));
            make.centerY.equalTo(weakSelf);
        }];
    }
    return self;
}


#pragma mark - lazyloading
-(UILabel *)cityLabel {
    if (!_cityLabel) {
        _cityLabel = [[UILabel alloc] init];
        [_cityLabel createLabelWithFontSize:15 color:white_color];
    }
    return _cityLabel;
}

-(UIImageView *)downArrowImgView {
    if (!_downArrowImgView) {
        _downArrowImgView = [[UIImageView alloc] init];
        _downArrowImgView.image = [UIImage imageNamed:@"down_arrow"];
    }
    return _downArrowImgView;
}

@end
