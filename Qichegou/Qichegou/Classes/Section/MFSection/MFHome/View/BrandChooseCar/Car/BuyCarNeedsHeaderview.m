//
//  BuyCarNeedsHeaderview.m
//  Qichegou
//
//  Created by Meng Fan on 16/4/13.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "BuyCarNeedsHeaderview.h"

@implementation BuyCarNeedsHeaderview

-(void)awakeFromNib {
    [super awakeFromNib];
}

/*
 *  赋值传参
 *  参数
 */
- (void)createHeaderViewWithImgName:(NSString *)imgName

                              title:(NSString *)titleStr

                           priceStr:(NSString *)price {
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_String, imgName]] placeholderImage:[UIImage imageNamed:@"bg_default"]];
    
    self.titleLabel.text = titleStr;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    NSMutableAttributedString *attribtStr = [BaseFunction lineWithString:[NSString stringWithFormat:@"厂家指导价：%@万", price]];
    self.detailLabel.attributedText = attribtStr;
}

@end
