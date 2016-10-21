//
//  MyOrderCell.m
//  BuyCar
//
//  Created by Song Gao on 15/12/31.
//  Copyright © 2015年 Meng Fan. All rights reserved.
//

#import "MyOrderCell.h"
#import "CarOrderModel.h"

@interface MyOrderCell ()

//@property (nonatomic, strong) UIButton *operationBtn;

@property (weak, nonatomic) IBOutlet UILabel *orderIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *carImgView;
@property (weak, nonatomic) IBOutlet UILabel *carTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *offLineLabel;


@end

@implementation MyOrderCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        //初始化操作按钮
//        [self.contentView addSubview:self.operationBtn];
//        self.operationBtn.frame = CGRectZero;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    //初始化操作按钮
//    [self.contentView addSubview:self.operationBtn];
//    self.operationBtn.frame = CGRectZero;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - lazyloading
//-(UIButton *)operationBtn {
//    if (!_operationBtn) {
//        _operationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _operationBtn.tag = 2121;
//    }
//    return _operationBtn;
//}


#pragma mark - set model methods
-(void)setModel:(CarOrderModel *)model {
    if (_model != model) {
        _model = model;
        
        [self setNeedsLayout];
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    //赋值
    self.orderIDLabel.text = [NSString stringWithFormat:@"订单编号：%@", self.model.order_id];
    
    if (self.model.main_photo.length>0) {
        [self.carImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_String, self.model.main_photo]] placeholderImage:[UIImage imageNamed:@"bg_default"]];
    }
    self.offLineLabel.text = [NSString stringWithFormat:@"优惠期限：截止到%@", self.model.expiry_date];
     self.carTitleLabel.text = [NSString stringWithFormat:@"%@%@", self.model.brand_name, self.model.car_subject];
    
    NSInteger orderStatus = [self.model.zt integerValue];
    if (orderStatus == 0) {
        //待付款
        self.orderStatusLabel.textColor = ITEMCOLOR;
        self.orderStatusLabel.text = [NSString stringWithFormat:@"－待付款"];
        
        self.completeBtn.hidden = NO;
        
//        WEAKSELF
//        [self.operationBtn makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(weakSelf.carTitleLabel.mas_left);
//            make.top.equalTo(weakSelf.offLineLabel.mas_bottom).offset(5);
//            make.size.equalTo(CGSizeMake(150, 25));
//        }];
//        [self.operationBtn createButtonWithBGImgName:@"btn_continue"
//                                  bghighlightImgName:@"btn_continue.2"
//                                            titleStr:@"完成订单"
//                                            fontSize:12];
        
    }else if (orderStatus == 1) {
        //已取消
        self.completeBtn.hidden = YES;
        self.orderStatusLabel.textColor = kskyBlueColor;
        self.orderStatusLabel.text = [NSString stringWithFormat:@"－已取消"];
        
    }else if (orderStatus == 2){
        //已支付
        self.completeBtn.hidden = YES;
        self.orderStatusLabel.textColor = kskyBlueColor;
        self.orderStatusLabel.text = [NSString stringWithFormat:@"－已付款，待提车"];
        
    }else if (orderStatus == 3) {
        //已退款
        self.completeBtn.hidden = YES;
        self.orderStatusLabel.textColor = kskyBlueColor;
        self.orderStatusLabel.text = [NSString stringWithFormat:@"－已退款"];
    }
   
}

@end
