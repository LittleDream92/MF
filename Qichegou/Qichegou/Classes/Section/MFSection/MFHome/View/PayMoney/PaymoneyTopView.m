//
//  PaymoneyTopView.m
//  DKQiCheGou
//
//  Created by Song Gao on 16/1/18.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "PaymoneyTopView.h"
#import "UIView+Extension.h"

#define frameX 15

@implementation PaymoneyTopView

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
    //初始化标题
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(frameX, 20*kHeightSale, 0, 0)];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.titleLabel.textColor = TEXTCOLOR;
    [self addSubview:self.titleLabel];
    
    //初始化price
    self.priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.priceLabel createLabelWithFontSize:12 color:GRAYCOLOR];
    [self addSubview:self.priceLabel];
    
    //
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.timeLabel createLabelWithFontSize:12 color:TEXTCOLOR];
    [self addSubview:self.timeLabel];
    
    //
    self.colorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.colorLabel createLabelWithFontSize:12 color:TEXTCOLOR];
    [self addSubview:self.colorLabel];
    
    //
    self.neishiLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.neishiLabel createLabelWithFontSize:12 color:TEXTCOLOR];
    [self addSubview:self.neishiLabel];
    
    //
    self.buycarWayLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.buycarWayLabel createLabelWithFontSize:12 color:TEXTCOLOR];
    [self addSubview:self.buycarWayLabel];
    
    //
    self.buycarTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.buycarTimeLabel createLabelWithFontSize:12 color:TEXTCOLOR];
    [self addSubview:self.buycarTimeLabel];
    
    //
    self.lineView = [[UIView alloc] initWithFrame:CGRectZero];
    self.lineView.backgroundColor = kplayceGrayColor;
    [self addSubview:self.lineView];
    
    //
    self.dingjinLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.dingjinLabel createLabelWithFontSize:14 color:TEXTCOLOR];
    [self addSubview:self.dingjinLabel];
    
    //
    self.pre_priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.pre_priceLabel createLabelWithFontSize:14 color:ITEMCOLOR];
    self.pre_priceLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.pre_priceLabel];
    
}


- (void)createTopViewWithChooseCarModel:(ChooseCarModel *)model
{
    NSLog(@"ChooseCarModel赋值！");
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@ %@ %@", model.brand_name, model.pro_subject, model.car_subject];
    [self.titleLabel sizeToFit];
    
    self.priceLabel.frame = CGRectMake(frameX, self.titleLabel.bottom + 20*kHeightSale, 0, 0);
    self.priceLabel.text = [NSString stringWithFormat:@"厂家指导价：%@万", model.guide_price];
    [self.priceLabel sizeToFit];
    
    self.timeLabel.frame = CGRectMake(frameX, self.priceLabel.bottom + 20*kHeightSale, 0, 0);
    self.timeLabel.text = [NSString stringWithFormat:@"生效时间：%@",model.create_time];
    NSMutableAttributedString *timaStr = [self.timeLabel makeDifferentColorWithText:self.timeLabel.text colorText:@"生效时间：" color:GRAYCOLOR];
    [self.timeLabel setAttributedText:timaStr];
    [self.timeLabel sizeToFit];
    
    self.colorLabel.frame = CGRectMake(frameX, self.timeLabel.bottom + 15*kHeightSale, 0, 0);
    self.colorLabel.text = [NSString stringWithFormat:@"外观颜色：%@",model.color];
    NSMutableAttributedString *colorStr = [self.colorLabel makeDifferentColorWithText:self.colorLabel.text colorText:@"外观颜色：" color:GRAYCOLOR];
    [self.colorLabel setAttributedText:colorStr];
    [self.colorLabel sizeToFit];
    
    self.neishiLabel.frame = CGRectMake(frameX, self.colorLabel.bottom+15*kHeightSale, 0, 0);
    self.neishiLabel.text = [NSString stringWithFormat:@"内饰颜色：%@", model.neishi];
    NSMutableAttributedString *neishiString =[self.neishiLabel makeDifferentColorWithText:self.neishiLabel.text colorText:@"内饰颜色：" color:GRAYCOLOR];
    [self.neishiLabel setAttributedText:neishiString];
    [self.neishiLabel sizeToFit];
    
    self.buycarWayLabel.frame = CGRectMake(frameX, self.neishiLabel.bottom+15*kHeightSale, 0, 0);
    NSString *textStr = [NSString stringWithFormat:@"购车方式：%@", model.gcfs];
    NSMutableAttributedString *buycarString =[self.buycarWayLabel makeDifferentColorWithText:textStr colorText:@"购车方式：" color:GRAYCOLOR];
    [self.buycarWayLabel setAttributedText:buycarString];
    [self.buycarWayLabel sizeToFit];
    
    self.buycarTimeLabel.frame = CGRectMake(frameX, self.buycarWayLabel.bottom+15*kHeightSale, 0, 0);
    self.buycarTimeLabel.text = [NSString stringWithFormat:@"购车时间：%@",  model.gcsj];
    NSMutableAttributedString *buycarTimeString =[self.buycarTimeLabel makeDifferentColorWithText:self.buycarTimeLabel.text colorText:@"购车时间：" color:GRAYCOLOR];
    [self.buycarTimeLabel setAttributedText:buycarTimeString];
    [self.buycarTimeLabel sizeToFit];
    
    self.lineView.frame = CGRectMake(frameX, self.buycarTimeLabel.bottom+15*kHeightSale, kScreenWidth - 30, 1);
    
    self.dingjinLabel.frame = CGRectMake(frameX, self.lineView.bottom+15*kHeightSale, 0, 0);
    self.dingjinLabel.text = @"订金金额";
    [self.dingjinLabel sizeToFit];

    _pre_priceLabel.x = kScreenWidth - 115;
    _pre_priceLabel.size = CGSizeMake(100, 21);
    _pre_priceLabel.centerY = _dingjinLabel.centerY;
    
    self.pre_priceLabel.text = [NSString stringWithFormat:@"¥%@", model.ding_jin];
}

@end
