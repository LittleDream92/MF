//
//  CarDetailFourCell.m
//  Qichegou
//
//  Created by Meng Fan on 16/10/8.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "CarDetailFourCell.h"
#import "DKMainWebViewController.h"
#import "UIView+ViewController.h"

@implementation CarDetailFourCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)serviceAction:(id)sender {
    DKMainWebViewController *serviceVC = [[DKMainWebViewController alloc] init];
    serviceVC.title = @"服务协议";
    serviceVC.isRequest = NO;
    serviceVC.webString = PROTOCOL_QICHEGOU;
    [self.viewController.navigationController pushViewController:serviceVC animated:YES];
}

@end
