//
//  OrderListViewModel.m
//  Qichegou
//
//  Created by Meng Fan on 16/10/25.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "OrderListViewModel.h"
#import "AppDelegate.h"
#import "CarOrderModel.h"

@interface OrderListViewModel ()

@end

@implementation OrderListViewModel

-(instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - lazyloading
-(RACCommand *)orderListCommand {
    if (!_orderListCommand) {
        @weakify(self);
        _orderListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self requestOrderList];
        }];
    }
    return _orderListCommand;
}

#pragma mark - request
- (RACSignal *)requestOrderList {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString *randomString = [BaseFunction ret32bitString];
        NSString *timeSp = [NSString stringWithFormat:@"%ld", [BaseFunction getTimeSp]];
        NSString *md5String = [[BaseFunction md5Digest:[NSString stringWithFormat:@"%@%@%@", timeSp, randomString, APPSIGN]] uppercaseString];
        
        NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:randomString,@"nonce_str",
                                timeSp, @"time",
                                md5String, @"sign",
                                [AppDelegate APP].user.token,@"token", nil];
        NSLog(@"car orders params:%@", params);

        [DataService http_Post:MY_ORDER parameters:params success:^(id responseObject) {
            if ([[responseObject objectForKey:@"status"] integerValue] == 1) {

                if ([[responseObject objectForKey:@"data"] isKindOfClass:[NSArray class]] && [[responseObject objectForKey:@"data"] count]>0) {
                    //说明有订单,处理数据
                    NSArray *jsonArr = [responseObject objectForKey:@"data"];

                    NSMutableArray *mArr = [NSMutableArray array];
                    for (NSDictionary *jsonDic in jsonArr) {
                        CarOrderModel *model = [[CarOrderModel alloc] initContentWithDic:jsonDic];
                        [mArr addObject:model];
                    }
                    
                    [subscriber sendNext:mArr];
                    [subscriber sendCompleted];

                }else {
                    [subscriber sendNext:nil];
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


@end
