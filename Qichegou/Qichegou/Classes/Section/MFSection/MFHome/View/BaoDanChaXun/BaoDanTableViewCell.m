//
//  BaoDanTableViewCell.m
//  Qichegou
//
//  Created by Meng Fan on 16/6/20.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "BaoDanTableViewCell.h"

@implementation BaoDanTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.separatorInset = UIEdgeInsetsMake(0, -20, 0, 0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
