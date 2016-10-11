//
//  SaleCarSubmmitViewModel.m
//  Qichegou
//
//  Created by Meng Fan on 16/10/11.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "SaleCarSubmmitViewModel.h"
#import "CarModel.h"

@interface SaleCarSubmmitViewModel ()

@property (nonatomic, strong) RACSignal *submmitEnableSignal;

@end

@implementation SaleCarSubmmitViewModel

-(instancetype)init {
    self = [super init];
    if (self) {
        [self setUpCommandAction];
    }
    return self;
}

- (void)setUpCommandAction {
    [self.saleCarSubmmitOrderCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"处理网络请求返回的数据");
    }];
}

#pragma mark - lazyloading
//特价车详情
-(RACCommand *)saleCarDetailCommand {
    if (!_saleCarDetailCommand) {
        _saleCarDetailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *input) {
            
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                //网络请求特价车详情
                [DataService http_Post:DETAIL_CAR parameters:input success:^(id responseObject) {
//                    NSLog(@"sale detail car:%@", responseObject);
                    if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
                        NSDictionary *jsonDic = [responseObject objectForKey:@"car"];
                        
                        CarModel *detailModel = [[CarModel alloc] initContentWithDic:jsonDic];
                        [subscriber sendNext:detailModel];
                        [subscriber sendCompleted];
                    }else {
                        [subscriber sendCompleted];
                        [PromtView showAlert:[responseObject objectForKey:@"msg"] duration:1.5];
                    }
                } failure:^(NSError *error) {
                    [subscriber sendCompleted];
                    [PromtView showAlert:PromptWord duration:1.5];
                }];
                
                return nil;
            }];
        }];
    }
    return _saleCarDetailCommand;
}

//特价车提交订单
-(RACCommand *)saleCarSubmmitOrderCommand {
    if (!_saleCarSubmmitOrderCommand) {
        _saleCarSubmmitOrderCommand = [[RACCommand alloc] initWithEnabled:self.submmitEnableSignal signalBlock:^RACSignal *(id input) {
            
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                NSLog(@"我要网络请求啦，%@,%@,%@", self.account, self.code, self.name);
                [subscriber sendNext:@"我是返回的数据"];
                [subscriber sendCompleted];
                return nil;
            }];
        }];
    }
    return _saleCarSubmmitOrderCommand;
}


-(RACSignal *)submmitEnableSignal {
    if (!_submmitEnableSignal) {
        _submmitEnableSignal = [RACSignal combineLatest:@[RACObserve(self, account), RACObserve(self, code), RACObserve(self, name)] reduce:^id(NSString *account, NSString *code, NSString *name) {
            return @((account.length == 11) && (code.length > 0) && (name.length > 0));
        }];
    }
    return _submmitEnableSignal;
}

@end
