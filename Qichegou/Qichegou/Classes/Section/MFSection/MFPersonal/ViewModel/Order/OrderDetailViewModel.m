//
//  OrderDetailViewModel.m
//  Qichegou
//
//  Created by Meng Fan on 16/10/25.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "OrderDetailViewModel.h"
#import "AppDelegate.h"
#import "CarOrderModel.h"

@interface OrderDetailViewModel ()

@end

@implementation OrderDetailViewModel

-(instancetype)initWithOrderID:(NSString *)orderID {
    self = [super init];
    if (self) {
        self.orderID = orderID;
    }
    return self;
}

#pragma mark - lazyloading
-(RACCommand *)orderDetailCommand {
    if (!_orderDetailCommand) {
        @weakify(self);
        _orderDetailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self requestCarDetailWithOrderID:self.orderID];
        }];
    }
    return _orderDetailCommand;
}

-(RACCommand *)cancelOrderCommand {
    if (!_cancelOrderCommand) {
        @weakify(self);
        _cancelOrderCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self requestCarDetailWithOrderID:self.orderID];
        }];
    }
    return _cancelOrderCommand;
}


#pragma mark - request
- (RACSignal *)requestCarDetailWithOrderID:(NSString *)orderID {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

        NSDictionary *params = [self getParamsWithOrderID:orderID];
        //订单详情请求
        [DataService http_Post:ORDER_DETAIL parameters:params success:^(id responseObject) {
            if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
                NSLog(@"order detail : %@", responseObject);
                
                //处理数据，封装 model
                if ([responseObject objectForKey:@"data"] != NULL) {
                    NSDictionary *jsonDic = [responseObject objectForKey:@"data"];
                    
                    CarOrderModel *model = [[CarOrderModel alloc] initContentWithDic:jsonDic];
                    
                    [subscriber sendNext:model];
                    [subscriber sendCompleted];
                }else {
                    [PromtView showMessage:@"返回数据出错！" duration:1.5];
                    [subscriber sendCompleted];
                }
            }else {
                [PromtView showMessage:responseObject[@"msg"] duration:1.5];
                [subscriber sendCompleted];
            }
        } failure:^(NSError *error) {
            [PromtView showMessage:PromptWord duration:1.5];
            [subscriber sendCompleted];
        }];
        
        return nil;
    }];
}

- (RACSignal *)requestCancelOrderWithOrderID:(NSString *)orderID {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSDictionary *params = [self getParamsWithOrderID:orderID];
        
        [DataService http_Post:CANCEL_ORDER parameters:params success:^(id responseObject) {
            NSLog(@"resposeObject:%@", responseObject);
            
            if ([responseObject[@"status"] integerValue] == 1) {
                [subscriber sendNext:@"YES"];
                [subscriber sendCompleted];
            }else {
                [PromtView showMessage:responseObject[@"msg"] duration:1.5];
                [subscriber sendCompleted];
            }
        } failure:^(NSError *error) {
            [PromtView showAlert:PromptWord duration:1.5];
            [subscriber sendCompleted];
        }];
        
        return nil;
    }];
}


#pragma mark - private
- (NSDictionary *)getParamsWithOrderID:(NSString *)orderID {
    //获取token值
    NSString *tokenStr = [AppDelegate APP].user.token;
    NSString *randomString = [BaseFunction ret32bitString];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", [BaseFunction getTimeSp]];
    NSString *md5String = [[BaseFunction md5Digest:[NSString stringWithFormat:@"%@%@%@", timeSp, randomString, APPSIGN]] uppercaseString];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:orderID,@"oid",
                            tokenStr,@"token",
                            md5String,@"sign",
                            timeSp,@"time",
                            randomString,@"nonce_str",nil];
    return params;
}

@end
