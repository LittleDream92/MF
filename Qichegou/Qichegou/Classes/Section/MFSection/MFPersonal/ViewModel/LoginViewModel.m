//
//  LoginViewModel.m
//  Qichegou
//
//  Created by Meng Fan on 16/9/23.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "LoginViewModel.h"

@implementation LoginViewModel

-(instancetype)init {
    self = [super init];
    if (self) {
        
        //初始化
        self.isPwdLogin = YES;
    }
    return self;
}

@end
