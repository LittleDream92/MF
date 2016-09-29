//
//  PersonalViewModel.m
//  Qichegou
//
//  Created by Meng Fan on 16/9/21.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "PersonalViewModel.h"

@implementation PersonalViewModel

-(instancetype)init {
    if (self = [super init]) {
        [self setData];
        
        [self setUpCommand];
    }
    return self;
}

- (void)setData {
    self.imgNamesArr = @[@"icon_myOrder",@"icon_activity",@"icon_changePwd",@"icon_off",@"icon_time"];
    self.titleArr = @[@"我的订单",@"我的活动",@"修改密码",@"退出登录",@"最近浏览"];
}


- (void)setUpCommand {
    
}


@end
