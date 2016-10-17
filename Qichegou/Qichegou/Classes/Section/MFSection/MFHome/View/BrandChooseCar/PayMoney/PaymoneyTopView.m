//
//  PaymoneyTopView.m
//  DKQiCheGou
//
//  Created by Song Gao on 16/1/18.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "PaymoneyTopView.h"
#import "UIView+Extension.h"
#import "CarOrderModel.h"

#define frameX 15

@interface PaymoneyTopView ()

@property (weak, nonatomic) IBOutlet UILabel *carLabel;
@property (weak, nonatomic) IBOutlet UILabel *guidePrice;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *color;
@property (weak, nonatomic) IBOutlet UILabel *inColor;
@property (weak, nonatomic) IBOutlet UILabel *way;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *price;


@end

@implementation PaymoneyTopView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;

}

-(void)awakeFromNib {
    [super awakeFromNib];
}


- (void)createTopViewWithChooseCarModel:(CarOrderModel *)model
{
    NSLog(@"ChooseCarModel赋值！");
    
    self.carLabel.text = [NSString stringWithFormat:@"%@ %@ %@", model.brand_name, model.pro_subject, model.car_subject];
    self.guidePrice.text = [NSString stringWithFormat:@"厂家指导价：%@万", model.guide_price];
    self.time.text = model.create_time;
    self.color.text = model.color;
    self.inColor.text = model.neishi;
    self.way.text = model.gcfs;
    self.dayLabel.text = model.gcsj;
    self.price.text = [NSString stringWithFormat:@"¥%@", model.ding_jin];
}

@end
