//
//  SubmmitViewModel.m
//  Qichegou
//
//  Created by Meng Fan on 16/10/8.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "SubmmitViewModel.h"
#import "AppDelegate.h"

@implementation SubmmitViewModel

-(instancetype)init {
    self = [super init];
    if (self) {
        [self setUpCommand];
    }
    return self;
}

- (void)setUpCommand {
    
    [self haveUnCompleteOrderAction];
    //    [self carProCommandAction];
}

#pragma mark - request action
- (void)haveUnCompleteOrderAction {
    _ifHaveUncompleteOrder = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            //网络请求
            //拿到token值
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [AppDelegate APP].user.token, @"token",nil];
            
            [DataService http_Post:UNCOMPLETE_ORDER
                        parameters:params
                           success:^(id responseObject) {
                               
                               NSLog(@"%@:%@", responseObject, [responseObject objectForKey:@"msg"]);
                               
                               //判断有没有未完成订单
                               if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
                                   
                                   //有未完成订单
                                   [subscriber sendNext:@"YES"];
                                   
                               }else if ([[responseObject objectForKey:@"status"] integerValue] == 0){
                                   
                                   //没有待付款订单，提交订单
                                   [subscriber sendNext:@"NO"];
                                   
                               }else {
                                   //其他
                                   [PromtView showAlert:PromptWord duration:1.5];
                               }
                               
                           } failure:^(NSError *error) {
                               //
                               NSLog(@"order status error:%@", error);
                               [PromtView showAlert:PromptWord duration:1.5];
                           }];

            
            return nil;
        }];
        
        return signal;
    }];
}


#pragma mark -
+ (void)registAndLoginWithtel:(NSString *)tel name:(NSString *)name code:(NSString *)code Block:(void(^)(NSString *token))block {
    NSString *randomString = [BaseFunction ret32bitString];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", [BaseFunction getTimeSp]];
    NSString *md5String = [[BaseFunction md5Digest:[NSString stringWithFormat:@"%@%@%@", timeSp, randomString, APPSIGN]] uppercaseString];
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:randomString,@"nonce_str",
                            timeSp, @"time",
                            md5String, @"sign",
                            tel,@"tel",
                            code, @"code",
                            name, @"name", nil];
    
    [DataService http_Post:ORDER_REGIST
                parameters:params
                   success:^(id responseObject) {
                       NSLog(@"order login:%@", responseObject);
                       if ([responseObject[@"status"] integerValue] == 1) {
                           
                           //存储
                           UserModel *userModel = [[UserModel alloc] initContentWithDic:responseObject];
                           userModel.sjhm = tel;
                           userModel.zsxm = name;
                           userModel.token = responseObject[@"token"];
                           [AppDelegate APP].user = userModel;
                           //发送登录成功通知
                           [NotificationCenters postNotificationName:LOGIN_SUCCESS object:nil userInfo:nil];
                           
                           block(userModel.token);
                       }else {
                           [PromtView showAlert:PromptWord duration:1.5];
                       }
                   } failure:^(NSError *error) {
                       NSLog(@"order login error:%@", error);
                       [PromtView showAlert:PromptWord duration:1.5];
                   }];

}

+ (void)ifHaveUmCompleteOrderWithBlock:(void(^)(BOOL have))block {
    //网络请求
    //拿到token值
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [AppDelegate APP].user.token, @"token",nil];
    
    [DataService http_Post:UNCOMPLETE_ORDER
                parameters:params
                   success:^(id responseObject) {
                       
                       NSLog(@"%@:%@", responseObject, [responseObject objectForKey:@"msg"]);
                       
                       //判断有没有未完成订单
                       if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
                           
                           //有未完成订单
                           block(YES);
                           
                       }else if ([[responseObject objectForKey:@"status"] integerValue] == 0){
                           
                           //没有待付款订单，提交订单
                           block(NO);
                           
                       }else {
                           //其他
                           [PromtView showAlert:responseObject[@"msg"] duration:1.5];
                       }
                       
                   } failure:^(NSError *error) {
                       //
                       NSLog(@"order status error:%@", error);
                       [PromtView showAlert:PromptWord duration:1.5];
                   }];
}

@end
