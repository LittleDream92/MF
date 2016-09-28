//
//  LoginViewModel.m
//  Qichegou
//
//  Created by Meng Fan on 16/9/23.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "LoginViewModel.h"
#import "UserModel.h"
#import "AppDelegate.h"

@implementation LoginViewModel

-(instancetype)init {
    self = [super init];
    if (self) {
        
        //初始化
        self.isPwdLogin = YES;
        
        [self setUpSiganl];
        [self setUpCommand];
    }
    return self;
}

- (void)setUpSiganl {
//    // 1. 处理登录点击的信号
//    _loginEnableSignal = [RACSignal combineLatest:@[RACObserve(self, account), RACObserve(self, pwd)] reduce:^id(NSString *account, NSString *pwd){
//        
//        return @(account.length == 11 && pwd.length > 0);
//    }];
}

- (void)setUpCommand {
    _loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            //登录的网络请求
//            NSLog(@"%@, %@", self.account, self.pwd);
            NSLog(@"%@", input);
            NSLog(@"%d", self.isPwdLogin);
            
            NSString *randomString = [BaseFunction ret32bitString];
            NSString *timeSp = [NSString stringWithFormat:@"%ld", [BaseFunction getTimeSp]];
            NSString *md5String = [[BaseFunction md5Digest:[NSString stringWithFormat:@"%@%@%@", timeSp, randomString, APPSIGN]] uppercaseString];
            
            NSDictionary *params = nil;
            
            if (self.isPwdLogin) {
                //密码登录
                params = [[NSDictionary alloc] initWithObjectsAndKeys:randomString,@"nonce_str",
                          timeSp, @"time",
                          md5String, @"sign",
                          self.account,@"tel",
                          self.pwd, @"pass",
                          @"", @"code",nil];
                
            }else {
                //验证码登录
                params = [[NSDictionary alloc] initWithObjectsAndKeys:randomString,@"nonce_str",
                          timeSp, @"time",
                          md5String, @"sign",
                          self.account,@"tel",
                          self.pwd, @"code",
                          @"", @"pass", nil];
            }
            
            NSLog(@"param:%@", params);
            [DataService http_Post:USERLOGIN
                        parameters:params
                           success:^(id responseObject) {
                            NSLog(@"respon:%@", responseObject);
                            if ([responseObject[@"status"] integerValue] == 1) {
                                //保存token
                                NSString *token = [responseObject objectForKey:@"token"];
                                UserModel *userModel = [[UserModel alloc] initContentWithDic:responseObject];
                                userModel.sjhm = self.account;
                                userModel.token = token;
                                [AppDelegate APP].user = userModel;
                                [subscriber sendNext:token];
                            }
                            
                        } failure:^(NSError *error) {
                            
                        }];
            
            return nil;
        }];
        return signal;
    }];
}

#pragma mark - loginAction
- (void)loginActionWithAccount:(NSString *)account pwd:(NSString *)pwd result:(void(^)(BOOL result))block {
    NSString *randomString = [BaseFunction ret32bitString];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", [BaseFunction getTimeSp]];
    NSString *md5String = [[BaseFunction md5Digest:[NSString stringWithFormat:@"%@%@%@", timeSp, randomString, APPSIGN]] uppercaseString];
    
    NSDictionary *params = nil;
    
    if (self.isPwdLogin) {
        //密码登录
        params = [[NSDictionary alloc] initWithObjectsAndKeys:randomString,@"nonce_str",
                  timeSp, @"time",
                  md5String, @"sign",
                  account,@"tel",
                  pwd, @"pass",
                  @"", @"code",nil];
        
    }else {
        //验证码登录
        params = [[NSDictionary alloc] initWithObjectsAndKeys:randomString,@"nonce_str",
                  timeSp, @"time",
                  md5String, @"sign",
                  account,@"tel",
                  pwd, @"pass",
                  @"", @"pass", nil];
    }
    
    NSLog(@"param:%@", params);
    [DataService http_Post:USERLOGIN
                parameters:params
                   success:^(id responseObject) {
                       NSLog(@"respon:%@", responseObject);
                       if ([responseObject[@"status"] integerValue] == 1) {
                           //保存token
                           NSString *token = [responseObject objectForKey:@"token"];
                           UserModel *userModel = [[UserModel alloc] initContentWithDic:responseObject];
                           userModel.sjhm = self.account;
                           userModel.token = token;
                           [AppDelegate APP].user = userModel;
                           block(YES);
                       }else {
                           [PromtView showAlert:responseObject[@"msg"] duration:1.5];
                           block(NO);
                       }
                       
                   } failure:^(NSError *error) {
                       block(NO);
                       [PromtView showAlert:PromptWord duration:1.5];
                   }];
}

@end
