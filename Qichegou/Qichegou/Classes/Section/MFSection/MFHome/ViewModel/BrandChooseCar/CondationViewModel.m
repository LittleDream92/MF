//
//  CondationViewModel.m
//  Qichegou
//
//  Created by Meng Fan on 16/10/11.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "CondationViewModel.h"

@implementation CondationViewModel

-(instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


-(RACCommand *)numCarsCommand {
    if (!_numCarsCommand) {
        @weakify(self);
        _numCarsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self);
                
                NSLog(@"min : %@, max : %@", self.min, self.max);
                
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                params[@"cityid"] = [UserDefaults objectForKey:kLocationAction][@"cityid"];
                params[@"iscount"] = @"1";
                params[@"min"] = self.min;
                params[@"max"] = self.max;
                params[@"mid"] = self.midID;
                
                NSLog(@"number params : %@", params);
                
                [DataService http_Post:CARLIST parameters:params success:^(id responseObject) {
                    NSLog(@"number is  : %@", responseObject);
                    if ([responseObject[@"status"] integerValue] == 1) {
                        NSString *totalNumber = responseObject[@"total"];
                        [subscriber sendNext:totalNumber];
                        [subscriber sendCompleted];
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
        }];
    }
    return _numCarsCommand;
}


@end
