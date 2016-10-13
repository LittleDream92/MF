//
//  CarInformationView.m
//  Qichegou
//
//  Created by Song Gao on 16/1/27.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "CarInformationView.h"
#import "CarOrderModel.h"

@interface CarInformationView ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet UILabel *buycarWayLabel;
@property (weak, nonatomic) IBOutlet UILabel *neishiLabel;
@property (weak, nonatomic) IBOutlet UILabel *buycarTimeLabel;

@property (weak, nonatomic) IBOutlet UIView *linView;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;

@property (weak, nonatomic) IBOutlet UILabel *promtLabel;

@property (weak, nonatomic) IBOutlet UIButton *stateLabel;



@end

@implementation CarInformationView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

-(void)awakeFromNib {
}


- (void)createCellViewWithModel:(CarOrderModel *)model {
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
            self.cancelBtn.hidden = NO;
            self.promtLabel.text = @"请您尽快付款～";
            
            break;
        }
        case 1:
        {
            orderStatusStr = @"已取消";
            self.cancelBtn.hidden = YES;
            self.promtLabel.text = @"您已取消订单～";
            
            break;
        }
        case 2:
        {
            orderStatusStr = @"已支付";
            self.cancelBtn.hidden = NO;
            [self.cancelBtn setTitle:@"申请退款" forState:UIControlStateNormal];
            self.promtLabel.text = @"请您尽快提车,完成后可在我的订单页面领取返现！";
            break;
        }
        case 3:
        {
            orderStatusStr = @"已退款";
            self.cancelBtn.hidden = YES;
            self.promtLabel.text = @"订单已退款成功～";
            
            break;
        }
        case 4:
        {
            orderStatusStr = @"已完成";
            self.cancelBtn.hidden = YES;
            self.promtLabel.text = @"订单已完成～";
            
            break;
        }
        default:
            break;
    }
    
    //订单状态label
    [self.stateLabel setTitle:orderStatusStr forState:UIControlStateNormal];
    
}

@end
