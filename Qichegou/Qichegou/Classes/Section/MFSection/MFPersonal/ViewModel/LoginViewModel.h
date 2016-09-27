//
//  LoginViewModel.h
//  Qichegou
//
//  Created by Meng Fan on 16/9/23.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginViewModel : NSObject

@property (nonatomic, assign) BOOL isPwdLogin;

//// 处理按钮是否允许点击
//@property(nonatomic, strong, readonly) RACSignal *loginEnableSignal;

/**
 *  保存登录界面的账号和密码
 */
@property(nonatomic, strong) NSString *account;
@property(nonatomic, strong) NSString *pwd;

// 登录按钮的命令
@property(nonatomic, strong, readonly) RACCommand *loginCommand;

@end
