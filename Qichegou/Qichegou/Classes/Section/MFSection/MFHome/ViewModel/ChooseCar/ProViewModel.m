//
//  ProViewModel.m
//  Qichegou
//
//  Created by Meng Fan on 16/9/27.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "ProViewModel.h"
#import "CarModel.h"

@implementation ProViewModel


-(instancetype)init {
    self = [super init];
    if (self) {
        [self setUpCommand];
    }
    return self;
}

- (void)setUpCommand {
    
    [self carProCommandAction];
}

#pragma mark - request action

- (void)carProCommandAction {
    _carProCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            //网络请求
            [DataService http_Post:CARPROS parameters:input success:^(id responseObject) {
//                NSLog(@"pro:%@", responseObject);
                if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
                    NSArray *jsonArr = [responseObject objectForKey:@"products"];
                    if ([jsonArr isKindOfClass:[NSArray class]] && jsonArr.count > 0) {
                        
                        NSMutableArray *mArr = [NSMutableArray array];
                        for (NSDictionary *jsonDic in jsonArr) {
                            CarModel *model = [[CarModel alloc] initContentWithDic:jsonDic];
                            [mArr addObject:model];
                        }
                        [subscriber sendNext:mArr];
                    }else {
                        [subscriber sendNext:nil];
                    }
                }
                
            } failure:^(NSError *error) {
                
            }];
            
            return nil;
        }];
        return signal;
    }];;
}

@end
