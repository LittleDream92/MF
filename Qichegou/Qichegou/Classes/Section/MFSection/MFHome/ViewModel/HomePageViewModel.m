//
//  HomePageViewModel.m
//  QiChegou
//
//  Created by Meng Fan on 16/9/18.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "HomePageViewModel.h"
#import "CarModel.h"

@implementation HomePageViewModel

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
//                    NSLog(@"sale:%@", responseObject);
                    NSArray *saleCars = responseObject[@"tejiache"];
                    if ([saleCars isKindOfClass:[NSArray class]] && saleCars.count>0) {
//
                        NSMutableArray *mArr = [NSMutableArray array];
                        for (NSDictionary *jsonDic in saleCars) {
                            
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
