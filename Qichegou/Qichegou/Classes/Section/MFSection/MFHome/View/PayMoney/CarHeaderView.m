//
//  CarHeaderView.m
//  Qichegou
//
//  Created by Song Gao on 16/1/27.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "CarHeaderView.h"

@implementation CarHeaderView

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

- (void)createViews
{
    //
    carImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20*kHeightSale, 15, 80, 40)];
    carImgView.image = [UIImage imageNamed:@"bg_default"];
    [self addSubview:carImgView];
    
    //
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(carImgView.right + 15*kHeightSale, 15, 0, 0)];
    [titleLabel createLabelWithFontSize:14*kHeightSale color:TEXTCOLOR];
    [self addSubview:titleLabel];
    
    //
    guide_priceLabel  = [[UILabel alloc] initWithFrame:CGRectZero];
    [guide_priceLabel createLabelWithFontSize:12 color:GRAYCOLOR];
    [self addSubview:guide_priceLabel];
}

- (void)createViewWithModel:(ChooseCarModel *)carModel
{
    //赋值
    if (carModel.main_photo.length > 0) {
        [carImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_String, carModel.main_photo]]];
    }

    titleLabel.text = [NSString stringWithFormat:@"%@ %@ %@", carModel.brand_name, carModel.pro_subject, carModel.car_subject];
    [titleLabel sizeToFit];

    guide_priceLabel.frame = CGRectMake(carImgView.right + 15, titleLabel.bottom + 10, 0, 0);
    guide_priceLabel.text = [NSString stringWithFormat:@"厂家指导价：%@万", carModel.guide_price];
    [guide_priceLabel sizeToFit];
}


@end
