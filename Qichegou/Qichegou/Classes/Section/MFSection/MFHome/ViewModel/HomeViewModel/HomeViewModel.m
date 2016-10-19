//
//  HomeViewModel.m
//  Qichegou
//
//  Created by Meng Fan on 16/10/11.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "HomeViewModel.h"
#import "CarModel.h"

@interface HomeViewModel ()

@end

@implementation HomeViewModel

-(instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(RACCommand *)saleCatListCommand {
    if (!_saleCatListCommand) {
        _saleCatListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *input) {
            return [self requestSaleCarsWithParams:input];
        }];
    }
    return _saleCatListCommand;
}

#pragma mark - request
- (RACSignal *)requestSaleCarsWithParams:(NSDictionary *)params {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [DataService http_Post:SALECAR parameters:params success:^(id responseObject) {
            if ([responseObject[@"status"] integerValue] == 1) {
//                    NSLog(@"sale:%@", responseObject);
                NSArray *saleCars = responseObject[@"tejiache"];
                if ([saleCars isKindOfClass:[NSArray class]] && saleCars.count>0) {
                    
                    NSMutableArray *mArr = [NSMutableArray array];
                    for (NSDictionary *jsonDic in saleCars) {
                        
                        CarModel *model = [[CarModel alloc] initContentWithDic:jsonDic];
                        [mArr addObject:model];
                    }
                    [subscriber sendNext:mArr];
                    [subscriber sendCompleted];
                }else {
                    [subscriber sendCompleted];
                    [PromtView showMessage:@"当前城市暂无特价车" duration:1.5];
                }
            }else {
                [subscriber sendCompleted];
                [PromtView showMessage:responseObject[@"msg"] duration:1.5];
            }
        } failure:^(NSError *error) {
            [subscriber sendCompleted];
            [PromtView showMessage:PromptWord duration:1.5];
        }];
        
        return nil;
    }];
}

@end
