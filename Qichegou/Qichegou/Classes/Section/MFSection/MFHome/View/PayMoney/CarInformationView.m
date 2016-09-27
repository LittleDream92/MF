//
//  CarInformationView.m
//  Qichegou
//
//  Created by Song Gao on 16/1/27.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "CarInformationView.h"

@implementation CarInformationView

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
    //初始化订单状态label
    orderStautsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [orderStautsLabel createLabelWithFontSize:12 color:ITEMCOLOR];
    [self addSubview:orderStautsLabel];
    
    //初始化取消订单按钮
    cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(kScreenWidth - 15 - 62, self.linView.bottom + 30, 62, 20);
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [cancelBtn setTitleColor:ITEMCOLOR forState:UIControlStateNormal];
    cancelBtn.tag = 2323;
    [cancelBtn createButtonWithBGImgName:@"btn_cancel"
                      bghighlightImgName:@"btn_cancel.2"
                                titleStr:@"取消订单"
                                fontSize:12];

    [self addSubview:cancelBtn];
    
}

- (void)createCellViewWithModel:(ChooseCarModel *)model
{
    //赋值
    self.timeLabel.text = model.create_time;
    self.colorLabel.text = model.color;
    self.neishiLabel.text = model.neishi;
    self.buycarWayLabel.text = model.gcfs;
    self.buycarTimeLabel.text = model.gcsj;
    
    
    
    NSString *orderStatusStr = @"";
    switch ([model.zt integerValue]) {
        case 0:
        {
            orderStatusStr = @"待付款";
//            self.promtLabel2.text = @"凭此订单编号，可到汽车购旗下XX4S店，按照客服给您的报价提车";
//            [self.promtLabel2 sizeToFit];
//            self.telLabel.frame = CGRectMake(15, self.promtLabel2.bottom+8, 100, 21);
//            self.promtLabel.frame = CGRectMake(15, self.telLabel.bottom+8, 0, 0);
            self.promtLabel.text = @"请您尽快付款～";
            [self.promtLabel sizeToFit];
            break;
        }
        case 1:
        {
            orderStatusStr = @"已取消";
            cancelBtn.hidden = YES;
            self.promtLabel.text = @"您已取消订单～";
            [self.promtLabel sizeToFit];
            break;
        }
        case 2:
        {
            orderStatusStr = @"已支付";
            [cancelBtn setTitle:@"申请退款" forState:UIControlStateNormal];
            self.promtLabel.text = @"请您尽快提车,完成后可在我的订单页面领取返现！";
            break;
        }
        case 3:
        {
            orderStatusStr = @"已退款";
            cancelBtn.hidden = YES;
            self.promtLabel.text = @"订单已退款成功～";
            [self.promtLabel sizeToFit];
            break;
        }
        case 4:
        {
            orderStatusStr = @"已完成";
            cancelBtn.hidden = YES;
            self.promtLabel.text = @"订单已完成～";
            [self.promtLabel sizeToFit];
            break;
        }
        default:
            break;
    }
    
    UIFont *fnt = [UIFont systemFontOfSize:12];
    // 根据字体得到NSString的尺寸
    CGSize size = [orderStatusStr sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
    
    //订单状态label
    orderStautsLabel.frame = CGRectMake(kScreenWidth-size.width-15, self.timeLabel.frame.origin.y, size.width, size.height);
    orderStautsLabel.text = orderStatusStr;
    
}

@end
