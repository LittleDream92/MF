//
//  LoginViewModel.m
//  Qichegou
//
//  Created by Meng Fan on 16/10/10.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "LoginViewModel.h"
#import "UserModel.h"
#import "AppDelegate.h"

@interface LoginViewModel ()

@property(nonatomic, strong) RACSignal *loginEnableSignal;

@end


@implementation LoginViewModel

-(instancetype)init {
    if (self = [super init]) {
        
        [self setUpCommand];
    }
    return self;
}

/**
 *  在这里处理Command命令请求后的数据，并且唤起控制器刷新UI
 */
- (void)setUpCommand {
    
    [self.loginCommand.executionSignals.switchToLatest subscribeNext:^(NSArray *subscriberArr) {
        
        NSLog(@"%@", subscriberArr);
        
        if ([subscriberArr isKindOfClass:[NSArray class]] && subscriberArr.count > 0) {
            //存储
            NSDictionary *jsonDic = [subscriberArr firstObject];
            NSString *tokenStr = [subscriberArr lastObject];
            UserModel *userModel = [[UserModel alloc] initContentWithDic:jsonDic];
            userModel.token = tokenStr;
            [AppDelegate APP].user = userModel;
            
            //发送登录成功通知
            [NotificationCenters postNotificationName:LOGIN_SUCCESS object:nil userInfo:nil];
        }
    }];
}


#pragma mark - lazyloading
/**
 *  登录的逻辑，两个接口：登录和用户信息
 *  登录接口返回 token，用户信息返回手机号、姓名和头像（暂无）
 *  两个接口嵌套进行网络请求，都请求成功才会去处理数据
 */
-(RACCommand *)loginCommand {
    if (!_loginCommand) {
        
        @weakify(self);
        _loginCommand = [[RACCommand alloc] initWithEnabled:self.loginEnableSignal signalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self requestLogin];
        }];
    }
    return _loginCommand;
}

/**
 *  登录命令的触发条件
 *  目前只判断了账号为11位，密码（验证码不为空），还没有用正则表达式判断，是否为正确的手机号码类型
 */
-(RACSignal *)loginEnableSignal {
    if (!_loginEnableSignal) {
    
        _loginEnableSignal = [RACSignal combineLatest:@[RACObserve(self, account), RACObserve(self, pwd)] reduce:^id(NSString *account, NSString *pwd){
            return @((account.length == 11) && pwd.length);
        }];
    }
    return _loginEnableSignal;
}


#pragma mark - private methods
- (NSDictionary *)getParamsWithToken:(NSString *)token {
    //params
    NSString *randomString = [BaseFunction ret32bitString];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", [BaseFunction getTimeSp]];
    NSString *md5String = [[BaseFunction md5Digest:[NSString stringWithFormat:@"%@%@%@", timeSp, randomString, APPSIGN]] uppercaseString];
    
    NSDictionary *params = nil;
    
    if (token == nil) {
        if (self.isPwdLogin) {  //pwd login params
            params = [[NSDictionary alloc] initWithObjectsAndKeys:randomString,@"nonce_str",
                      timeSp, @"time",
                      md5String, @"sign",
                      self.account,@"tel",
                      self.pwd, @"pass",
                      @"", @"code",nil];
            
        }else {     //code login params
            params = [[NSDictionary alloc] initWithObjectsAndKeys:randomString,@"nonce_str",
                      timeSp, @"time",
                      md5String, @"sign",
                      self.account,@"tel",
                      self.pwd, @"code",
                      @"", @"pass", nil];
        }
    }else {
        params = [[NSDictionary alloc] initWithObjectsAndKeys:randomString,@"nonce_str",
                  timeSp, @"time",
                  md5String, @"sign",
                  token,@"token",nil];
    }
    
    return params;
}


#pragma mark - request
- (RACSignal *)requestLogin {

    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSDictionary *params = [self getParamsWithToken:nil];
        NSLog(@"登录参数：%@", params);
        [DataService http_Post:USERLOGIN parameters:params success:^(id responseObject) {
            NSLog(@"登录结果:%@", responseObject);
            NSDictionary *dict = (NSDictionary *)responseObject;
            
            if ([responseObject[@"status"] integerValue] == 1) {
                NSDictionary *userParams = [self getParamsWithToken:dict[@"token"]];
                NSLog(@"用户参数：%@", userParams);
                [DataService http_Post:USER_INFORMATION parameters:userParams success:^(id responseObject2) {
                    NSLog(@"用户结果:%@", responseObject2);
                    NSArray *subscriberArr = @[responseObject2, dict[@"token"]];
                    [subscriber sendNext:subscriberArr];
                    [subscriber sendCompleted];
                } failure:^(NSError *error) {
                    NSLog(@"error:%@", error);
                    [subscriber sendCompleted];
                    [PromtView showAlert:PromptWord duration:1.5];
                }];
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
