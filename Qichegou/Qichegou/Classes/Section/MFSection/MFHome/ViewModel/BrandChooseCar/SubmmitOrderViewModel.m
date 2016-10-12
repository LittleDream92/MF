//
//  SubmmitOrderViewModel.m
//  Qichegou
//
//  Created by Meng Fan on 16/10/12.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "SubmmitOrderViewModel.h"

@interface SubmmitOrderViewModel ()

@property (nonatomic, strong) RACSignal *submmitEnableSignal;

@end


@implementation SubmmitOrderViewModel

-(instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(RACCommand *)submmitOrderCommand {
    if (!_submmitOrderCommand) {
        _submmitOrderCommand = [[RACCommand alloc] initWithEnabled:self.submmitEnableSignal signalBlock:^RACSignal *(id input) {
            
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                //网络请求
                
                
                [subscriber sendCompleted];
                return nil;
            }];
        }];
    }
    return _submmitOrderCommand;
}


-(RACSignal *)submmitEnableSignal {
    if (!_submmitEnableSignal) {
        _submmitEnableSignal = [RACSignal combineLatest:@[RACObserve(self, account), RACObserve(self, name), RACObserve(self, code)]  reduce:^id(NSString *account, NSString *name, NSString *code){
            return @(account.length == 11 && name.length > 0 && code.length > 0);
        }];
    }
    return _submmitEnableSignal;
}


#pragma mark - request
- (void)request {
    
//    //检查是否有未完成订单
//    [DataService http_Post:<#(NSString *)#> parameters:<#(NSDictionary *)#> success:<#^(id responseObject)blockS#> failure:<#^(NSError *error)blockF#>];
    
}


@end
