//
//  SaleViewModel.m
//  QiChegou
//
//  Created by Meng Fan on 16/9/26.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "SaleViewModel.h"
#import "CarModel.h"

@implementation SaleViewModel


-(instancetype)init {
    self = [super init];
    if (self) {
        [self setUpCommand];
    }
    return self;
}

- (void)setUpCommand {
    [self saleCommandAction];
}

#pragma mark - request action
- (void)saleCommandAction {
    _saleCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [DataService http_Post:SALECAR parameters:input success:^(id responseObject) {
                if ([responseObject[@"status"] integerValue] == 1) {
//                NSLog(@"hot:%@", responseObject);
                    NSArray *saleCar = responseObject[@"tejiache"];
                    if ([saleCar isKindOfClass:[NSArray class]] && saleCar.count>0) {
                        
                        NSMutableArray *mArr = [NSMutableArray array];
                        for (NSDictionary *jsonDic in saleCar) {
                            
                            CarModel *model = [[CarModel alloc] initContentWithDic:jsonDic];
                            [mArr addObject:model];
                        }
                        [subscriber sendNext:mArr];
                    }
                }
            } failure:^(NSError *error) {
                
            }];
            
            return nil;
        }];
        
        return signal;
    }];

}


@end
