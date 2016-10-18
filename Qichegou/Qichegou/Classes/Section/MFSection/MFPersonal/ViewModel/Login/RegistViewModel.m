//
//  RegistViewModel.m
//  Qichegou
//
//  Created by Meng Fan on 16/10/18.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "RegistViewModel.h"

@interface RegistViewModel ()

//修改密码
@property (nonatomic, strong) RACSignal *changeEnableSignal;

//注册
@property (nonatomic, strong) RACSignal *registEnableSignal;

@end

@implementation RegistViewModel

-(instancetype)init {
    if (self = [super init]) {

    }
    return self;
}

#pragma mark - 
/** 注册 */
-(RACCommand *)registCommand {
    if (!_registCommand) {
        _registCommand = [[RACCommand alloc] initWithEnabled:self.registEnableSignal signalBlock:^RACSignal *(id input) {
            return [self requestRegist];
        }];
    }
    return _registCommand;
}


-(RACSignal *)registEnableSignal {
    if (!_registEnableSignal) {
        _registEnableSignal = [RACSignal combineLatest:@[RACObserve(self, account), RACObserve(self, pwd), RACObserve(self, rePwd), RACObserve(self, name), RACObserve(self, code)] reduce:^id (NSString *account, NSString *pwd, NSString *rePwd, NSString *name, NSString *code) {
            
            if (!pwd.length && ![pwd isEqualToString:rePwd]) {
                [PromtView showAlert:@"两次密码不一致" duration:1.5];
            }
            
            return @(account.length==11 && pwd.length && [pwd isEqualToString:rePwd] && name.length && code.length);
        }];
    }
    return _registEnableSignal;
}

/** 修改密码 */
-(RACCommand *)changePwdCommand {
    if (!_changePwdCommand) {
        _changePwdCommand = [[RACCommand alloc] initWithEnabled:self.changeEnableSignal signalBlock:^RACSignal *(id input) {
            return [self requestChangePwd];
        }];

    }
    return _changePwdCommand;
}

-(RACSignal *)changeEnableSignal {
    if (!_changeEnableSignal) {
        _changeEnableSignal = [RACSignal combineLatest:@[RACObserve(self, account), RACObserve(self, pwd), RACObserve(self, rePwd), RACObserve(self, code)] reduce:^id (NSString *account, NSString *pwd, NSString *rePwd, NSString *code) {
            
            if (!pwd.length && ![pwd isEqualToString:rePwd]) {
                [PromtView showAlert:@"两次密码不一致" duration:1.5];
            }
            
            return @(account.length==11 && pwd.length && [pwd isEqualToString:rePwd] && code.length);
        }];
    }
    return _changeEnableSignal;
}

#pragma mark - request
/** 注册的网络请求 */
- (RACSignal *)requestRegist {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        @strongify(self);
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.account,@"tel",
                                self.code,@"code",
                                self.name,@"name",
                                self.pwd,@"pass",nil];
        [DataService http_Post:REGIST
                    parameters:params
                       success:^(id responseObject) {
                           
                           NSLog(@"register result:%@ __ msg:%@", responseObject, [responseObject objectForKey:@"msg"]);
                           
                           NSDictionary *jsonDic = responseObject;
                           if ([[jsonDic objectForKey:@"status"] integerValue] == 1) {
                               NSLog(@"注册成功！");
                               [subscriber sendNext:@"注册成功"];
                               [subscriber sendCompleted];
                           }else {
                               [PromtView showAlert:[jsonDic objectForKey:@"msg"] duration:1.5];
                               [subscriber sendCompleted];
                           }
                           
                       } failure:^(NSError *error) {
                           [subscriber sendCompleted];
                           [PromtView showAlert:PromptWord duration:1.5];
                       }];
        return nil;
    }];
}

/** 修改密码的网络请求 */
- (RACSignal *)requestChangePwd {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        @strongify(self);
        NSString *randomString = [BaseFunction ret32bitString];
        NSString *timeSp = [NSString stringWithFormat:@"%ld", [BaseFunction getTimeSp]];
        NSString *md5String = [[BaseFunction md5Digest:[NSString stringWithFormat:@"%@%@%@", timeSp, randomString, APPSIGN]] uppercaseString];
        
        NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:randomString,@"nonce_str",
                                timeSp, @"time",
                                md5String, @"sign",
                                self.account,@"tel",
                                self.code, @"code",
                                self.pwd, @"pass", nil];
        
        [DataService http_Post:RESET_PWD
                    parameters:params
                       success:^(id responseObject) {
                           
                           NSDictionary *jsonDic = responseObject;
                           if ([[jsonDic objectForKey:@"status"] integerValue] == 1) {
                               [subscriber sendNext:@"修改成功"];
                               [subscriber sendCompleted];
                           }else {
                               [subscriber sendCompleted];
                               [PromtView showAlert:responseObject[@"msg"] duration:1.5];
                           }
                       } failure:^(NSError *error) {
                           [subscriber sendCompleted];
                           [PromtView showAlert:PromptWord duration:1.5];
                       }];
        return nil;
    }];
}


@end
