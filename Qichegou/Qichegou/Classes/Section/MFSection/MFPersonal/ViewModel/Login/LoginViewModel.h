//
//  LoginViewModel.h
//  Qichegou
//
//  Created by Meng Fan on 16/10/10.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginViewModel : NSObject

@property (nonatomic, assign) BOOL isPwdLogin;


@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *pwd;

//登录
@property (nonatomic, strong) RACCommand *loginCommand;

@end
