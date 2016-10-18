//
//  RegistViewModel.h
//  Qichegou
//
//  Created by Meng Fan on 16/10/18.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegistViewModel : NSObject


@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *pwd;
@property (nonatomic, copy) NSString *rePwd;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *code;

//注册
@property (nonatomic, strong) RACCommand *registCommand;

//修改密码
@property (nonatomic, strong) RACCommand *changePwdCommand;

@end
