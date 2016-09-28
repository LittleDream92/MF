//
//  MyOrderCell.m
//  BuyCar
//
//  Created by Song Gao on 15/12/31.
//  Copyright © 2015年 Meng Fan. All rights reserved.
//

#import "MyOrderCell.h"

@implementation MyOrderCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //
        [self createViews];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    [self createViews];
}

- (void)createViews
{
    //初始化操作按钮
    self.operationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.operationBtn.frame = CGRectZero;
    self.operationBtn.tag = 2121;
    [self.contentView addSubview:self.operationBtn];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(ChooseCarModel *)model
{
    if (_model != model) {
        _model = model;
        
        [self setNeedsLayout];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.operationBtn.frame = CGRectZero;
    
    //赋值
    self.orderIDLabel.text = [NSString stringWithFormat:@"订单编号：%@", self.model.order_id];
    
    if (self.model.main_photo.length>0) {
        [self.carImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_String, self.model.main_photo]] placeholderImage:[UIImage imageNamed:@"bg_default"]];
    }
    self.offLineLabel.text = [NSString stringWithFormat:@"优惠期限：截止到%@", self.model.expiry_date];
    
    NSInteger orderStatus = [self.model.zt integerValue];
    if (orderStatus == 0) {
        //待付款
        self.orderStatusLabel.textColor = ITEMCOLOR;
        self.orderStatusLabel.text = [NSString stringWithFormat:@"－待付款"];
        
        self.operationBtn.frame = CGRectMake(115, 90 + 5, 90, 30);
        [self.operationBtn createButtonWithBGImgName:@"btn_continue"
                                  bghighlightImgName:@"btn_continue.2"
                                            titleStr:@"完成订单"
                                            fontSize:12];
        
    }else if (orderStatus == 1) {
        //已取消
        self.orderStatusLabel.textColor = kskyBlueColor;
        self.orderStatusLabel.text = [NSString stringWithFormat:@"－已取消"];
        
    }else if (orderStatus == 2){
        //已支付
        self.orderStatusLabel.textColor = kskyBlueColor;
        self.orderStatusLabel.text = [NSString stringWithFormat:@"－已付款，待提车"];
        
    }else if (orderStatus == 3) {
        //已退款
        self.orderStatusLabel.textColor = kskyBlueColor;
        self.orderStatusLabel.text = [NSString stringWithFormat:@"－已退款"];
    }
    
    self.carTitleLabel.text = [NSString stringWithFormat:@"%@%@", self.model.brand_name, self.model.car_subject];
}

@end
