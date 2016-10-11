//
//  BaoDetailCell.m
//  Qichegou
//
//  Created by Meng Fan on 16/6/22.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "BaoDetailCell.h"

@implementation BaoDetailCell

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.lastView = self.view;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(170*kWidthSale, 0, 100, 40)];
        [label createLabelWithFontSize:16 color:RGB(204, 204, 204)];
        label.text = @"保额";
        [self.view addSubview:label];
        
        [self initView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lastView = self.view;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(170*kWidthSale, 0, 100, 40)];
    [label createLabelWithFontSize:16 color:RGB(204, 204, 204)];
    label.text = @"保额";
    [self.view addSubview:label];
    [self initView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setModel:(InsuranceModel *)model {
    if (_model != model) {
        _model = model;
        
        [self setNeedsLayout];
    }
}


-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.lastView = self.view;
    
    if (self.model.chesun) {
        self.chesunView.hidden = NO;
        self.chesunView.frame = CGRectMake(5, self.lastView.bottom, kScreenWidth-10, 40);
        self.chesunELabel.text = [NSString stringWithFormat:@"¥%@", self.model.chesun_baoe];
        self.chesunLabel.text = [NSString stringWithFormat:@"¥%@", self.model.chesun];
        self.lastView = self.chesunView;
    }else  {
        self.chesunView.hidden = YES;
    }
    if (self.model.chesun_buji) {
        self.bujiChesunView.hidden = NO;
        self.bujiChesunView.frame = CGRectMake(5, self.lastView.bottom, kScreenWidth-10, 40);
        self.bujiChesunLabel.text = [NSString stringWithFormat:@"¥%@", self.model.chesun_buji];
        self.lastView = self.bujiChesunView;
    }else {
        self.bujiChesunView.hidden = YES;
    }
    if (self.model.chesun_zhuanxiu) {
        self.xiuView.hidden = NO;
        self.xiuView.frame = CGRectMake(5, self.lastView.bottom, kScreenWidth-10, 40);
        self.xiuLabel.text = [NSString stringWithFormat:@"¥%@", self.model.chesun_zhuanxiu];
        self.lastView = self.xiuView;
    }else {
        self.xiuView.hidden = YES;
    }
    if (self.model.chesun_boli) {
        self.boliView.hidden = NO;
        self.boliView.frame = CGRectMake(5, self.lastView.bottom, kScreenWidth-10, 40);
        self.boliLabel.text = [NSString stringWithFormat:@"¥%@", self.model.chesun_boli];
        self.lastView = self.boliView;
    }else {
        self.boliView.hidden = YES;
    }
    
    
    if (self.model.siji) {
        self.sijiView.hidden = NO;
        self.sijiView.frame = CGRectMake(5, self.lastView.bottom, kScreenWidth-10, 40);
        self.sijiELabel.text = [NSString stringWithFormat:@"¥%@", self.model.siji_baoe];
        self.sijiLabel.text = [NSString stringWithFormat:@"¥%@", self.model.siji];
        self.lastView = self.sijiView;
    }else  {
        self.sijiView.hidden = YES;
    }
    
    if (self.model.siji_buji) {
        self.bujiDrView.hidden = NO;
        self.bujiDrView.frame = CGRectMake(5, self.lastView.bottom, kScreenWidth-10, 40);
        self.bujiDrLabel.text = [NSString stringWithFormat:@"¥%@", self.model.siji_buji];
        self.lastView = self.bujiDrView;
    }else {
        self.bujiDrView.hidden = YES;
    }
    
    if (self.model.chengke) {
        self.passengerView.hidden = NO;
        self.passengerView.frame = CGRectMake(5, self.lastView.bottom, kScreenWidth-10, 40);
        self.passengerELabel.text = [NSString stringWithFormat:@"¥%@(%@座)", self.model.chengke_baoe, self.model.chengke_zuowei];
        self.passengerLabel.text = [NSString stringWithFormat:@"¥%@", self.model.chengke];
        self.lastView = self.passengerView;
    }else {
        self.passengerView.hidden = YES;
    }
    
    if (self.model.chengke_buji) {
        self.bujiPaView.hidden = NO;
        self.bujiPaView.frame = CGRectMake(5, self.lastView.bottom, kScreenWidth-10, 40);
        self.bujiPaLabel.text = [NSString stringWithFormat:@"¥%@", self.model.chengke_buji];
        self.lastView = self.bujiPaView;
    }else {
        self.bujiPaView.hidden = YES;
    }
    
    if (self.model.sanzhe) {
        self.sanView.hidden = NO;
        self.sanView.frame = CGRectMake(5, self.lastView.bottom, kScreenWidth-10, 40);
        self.sanELabel.text = [NSString stringWithFormat:@"¥%@", self.model.sanzhe_baoe];
        self.sanLabel.text = [NSString stringWithFormat:@"¥%@", self.model.sanzhe];
        self.lastView = self.sanView;

    }else {
        self.sanView.hidden = YES;
    }
    if (self.model.sanzhe_buji) {
        self.bujiSanView.hidden = NO;
        self.bujiSanView.frame = CGRectMake(5, self.lastView.bottom, kScreenWidth-10, 40);
        self.bujiSanLabel.text = [NSString stringWithFormat:@"¥%@", self.model.sanzhe_buji];
        self.lastView = self.bujiSanView;
        
    }else {
        self.bujiSanView.hidden = YES;
    }
    
    if (self.model.daoqiang) {
        self.daoView.hidden = NO;
        self.daoView.frame = CGRectMake(5, self.lastView.bottom, kScreenWidth-10, 40);
        self.daoLabel.text = [NSString stringWithFormat:@"¥%@", self.model.daoqiang];
        self.lastView = self.daoView;
    }else {
        self.daoView.hidden = YES;
    }
    
    if (self.model.daoqiang_buji) {
        self.bujiDaoView.hidden = NO;
        self.bujiDaoView.frame = CGRectMake(5, self.lastView.bottom, kScreenWidth-10, 40);
        self.bujiDaoLabel.text = [NSString stringWithFormat:@"¥%@", self.model.daoqiang_buji];
        self.lastView = self.bujiDaoView;
    }else {
        self.bujiDaoView.hidden = YES;
    }
    
    if (self.model.xinche_chongzhi) {
        self.reView.hidden = NO;
        self.reView.frame = CGRectMake(5, self.lastView.bottom, kScreenWidth-10, 40);
        self.reLabel.text = [NSString stringWithFormat:@"¥%@", self.model.xinche_chongzhi];
        self.lastView = self.reView;
    }else {
        self.reView.hidden = YES;
    }
    
    if (self.model.chechuan) {
        self.chuanView.hidden = NO;
        self.chuanView.frame = CGRectMake(5, self.lastView.bottom, kScreenWidth-10, 40);
        self.chuanLabel.text = [NSString stringWithFormat:@"¥%@", self.model.chechuan];
        self.lastView = self.chuanView;
    }else {
        self.chuanView.hidden = YES;
    }
    
    if (self.model.jiaoqiang) {
        self.qiangView.hidden = NO;
        self.qiangView.frame = CGRectMake(5, self.lastView.bottom, kScreenWidth-10, 40);
        self.qiangLabel.text = [NSString stringWithFormat:@"¥%@", self.model.jiaoqiang];
        self.lastView = self.qiangView;
    }else {
        self.qiangView.hidden = YES;
    }
    
    self.totalView.hidden = NO;
    self.totalView.frame = CGRectMake(5, self.lastView.bottom, kScreenWidth-10, 40);
    self.totalPriceLabel.text = [NSString stringWithFormat:@"¥%@", self.model.total_money];
}

#pragma mark - initView
- (void)initView {
    
    //初始化第一个view
    self.chesunView = [self setupView];
    [self setupTypeLabelWithView:self.chesunView title:@"机动车损失险"];
    self.chesunELabel = [self setupBaoeLabelWithView:self.chesunView];
    self.chesunLabel = [self setupContentLabelWithView:self.chesunView];
//    [self setupLineWithView:self.chesunView];
    //
    self.bujiChesunView = [self setupView];
//    [self setupTypeLabelWithView:self.bujiChesunView title:@"不计免赔(车损)"];
    [self setupDetailLabelWithView:self.bujiChesunView title:@"不计免赔(车损)"];
    self.bujiChesunLabel = [self setupContentLabelWithView:self.bujiChesunView];
//    [self setupLineWithView:self.bujiChesunView];
    //
    self.xiuView = [self setupView];
//    [self setupTypeLabelWithView:self.xiuView title:@"车损之4S店专修险"];
    [self setupDetailLabelWithView:self.xiuView title:@"车损之4S店专修险"];
    self.xiuLabel = [self setupContentLabelWithView:self.xiuView];
//    [self setupLineWithView:self.xiuView];
    
    self.boliView = [self setupView];
//    [self setupTypeLabelWithView:self.boliView title:@"车损之玻璃破损险"];
    [self setupDetailLabelWithView:self.boliView title:@"车损之玻璃破损险"];
//    self.boliType = [self setupBaoeLabelWithView:self.boliView];
    self.boliLabel = [self setupContentLabelWithView:self.boliView];
    [self setupLineWithView:self.boliView];
    
    
    //初始化第二个view
    self.sijiView = [self setupView];
    [self setupTypeLabelWithView:self.sijiView title:@"司机座位责任险"];
    self.sijiELabel = [self setupBaoeLabelWithView:self.sijiView];
    self.sijiLabel = [self setupContentLabelWithView:self.sijiView];
//    [self setupLineWithView:self.sijiView];
    //
    self.bujiDrView = [self setupView];
//    [self setupTypeLabelWithView:self.bujiDrView title:@"不计免赔(司机)"];
    [self setupDetailLabelWithView:self.bujiDrView title:@"不计免赔(司机)"];
    self.bujiDrLabel = [self setupContentLabelWithView:self.bujiDrView];
    [self setupLineWithView:self.bujiDrView];
    
    //初始化第三个view
    self.passengerView = [self setupView];
    [self setupTypeLabelWithView:self.passengerView title:@"乘客座位责任险"];
    self.passengerELabel = [self setupBaoeLabelWithView:self.passengerView];
    self.passengerLabel = [self setupContentLabelWithView:self.passengerView];
    self.bujiPaView = [self setupView];
    [self setupDetailLabelWithView:self.bujiPaView title:@"不计免赔(乘客)"];
    self.bujiPaLabel = [self setupContentLabelWithView:self.bujiPaView];
    [self setupLineWithView:self.bujiPaView];
    
    //初始化第四个view
    self.sanView = [self setupView];
    [self setupTypeLabelWithView:self.sanView title:@"第三者责任险"];
    self.sanELabel = [self setupBaoeLabelWithView:self.sanView];
    self.sanLabel = [self setupContentLabelWithView:self.sanView];
    self.bujiSanView = [self setupView];
    [self setupDetailLabelWithView:self.bujiSanView title:@"不计免赔(第三者)"];
    self.bujiSanLabel = [self setupContentLabelWithView:self.bujiSanView];
    [self setupLineWithView:self.bujiSanView];
    
    
    //初始化第五个view
    self.daoView = [self setupView];
    [self setupTypeLabelWithView:self.daoView title:@"全车盗抢险"];
    self.daoLabel = [self setupContentLabelWithView:self.daoView];
    self.bujiDaoView = [self setupView];
    [self setupDetailLabelWithView:self.bujiDaoView title:@"不计免赔（盗抢）"];
    self.bujiDaoLabel = [self setupContentLabelWithView:self.bujiDaoView];
    [self setupLineWithView:self.bujiDaoView];

    
    //初始化第八个view
    self.reView = [self setupView];
    [self setupTypeLabelWithView:self.reView title:@"新车重置险"];
    self.reLabel = [self setupContentLabelWithView:self.reView];
    [self setupLineWithView:self.reView];
    
    self.chuanView = [self setupView];
    [self setupTypeLabelWithView:self.chuanView title:@"车船税"];
    self.chuanLabel = [self setupContentLabelWithView:self.chuanView];
    [self setupLineWithView:self.chuanView];
    self.qiangView = [self setupView];
    [self setupTypeLabelWithView:self.qiangView title:@"交强险"];
    self.qiangLabel = [self setupContentLabelWithView:self.qiangView];
    [self setupLineWithView:self.qiangView];
    
    self.totalView = [self setupView];

    UILabel *totallabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 100, 40)];
    [totallabel createLabelWithFontSize:18 color:RGB(241, 12, 0)];
    totallabel.text = @"总计";
    [self.totalView addSubview:totallabel];
    
    self.totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-200, 0, 200-20, 40)];
    [self.totalPriceLabel createLabelWithFontSize:18 color:RGB(241, 12, 0)];
    self.totalPriceLabel.textAlignment =  NSTextAlignmentRight;
    [self.totalView addSubview:self.totalPriceLabel];
}

- (UIView *)setupView {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectZero];
    bgView.hidden = YES;
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];

    return bgView;
}

- (UILabel *)setupBaoeLabelWithView:(UIView *)view {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(170*kWidthSale, 0, 180, 40)];
    [label createLabelWithFontSize:14 color:RGB(26, 26, 26)];
    [view addSubview:label];
    return label;
}

- (UILabel *)setupTypeLabelWithView:(UIView *)view title:(NSString *)title {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 40)];
    [label createLabelWithFontSize:14 color:RGB(26, 26, 26)];
    label.text = title;
    [view addSubview:label];
    
    return label;
}

- (UILabel *)setupDetailLabelWithView:(UIView *)view title:(NSString *)title {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 150, 40)];
    [label createLabelWithFontSize:13 color:[UIColor grayColor]];
    label.text = title;
    [view addSubview:label];
    
    return label;
}

- (UILabel *)setupContentLabelWithView:(UIView *)view {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-120, 0, 100, 40)];
    [label createLabelWithFontSize:14 color:RGB(254, 145, 0)];
    label.textAlignment = NSTextAlignmentRight;
    [view addSubview:label];
    
    return label;
}

- (void)setupLineWithView:(UIView *)view {
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39, kScreenWidth-10, 1)];
    line.backgroundColor = BGGRAYCOLOR;
    [view addSubview:line];
}


@end
