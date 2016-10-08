//
//  CarDetailThirdCell.m
//  Qichegou
//
//  Created by Meng Fan on 16/10/8.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "CarDetailThirdCell.h"

@implementation CarDetailThirdCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    if (!self.isShowing) {
////        self.thirdLabel.hidden = YES;
////        self.thirdDetailLabel.hidden = YES;
//        [self.moreBtn setTitle:@"更多" forState:UIControlStateNormal];
//    }else {
////        self.thirdLabel.hidden = NO;
////        self.thirdDetailLabel.hidden = NO;
//        [self.moreBtn setTitle:@"收起" forState:UIControlStateNormal];
//    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)moreAction:(id)sender {
    
    if (self.clickMoreBtn) {
        self.clickMoreBtn();
    }
}

@end
