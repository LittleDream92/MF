//
//  BrandViewModel.m
//  QiChegou
//
//  Created by Meng Fan on 16/9/26.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "BrandViewModel.h"
#import "CarModel.h"

@implementation BrandViewModel

-(instancetype)init {
    self = [super init];
    if (self) {
        [self setUpCommand];
    }
    return self;
}

- (void)setUpCommand {
    [self hotCommandAction];
    [self brandCommandAction];
}

#pragma mark - request action
- (void)brandCommandAction {
    _brandCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            //网络请求
            [DataService http_Post:BRABD_LIST parameters:input success:^(id responseObject) {
//                NSLog(@"respon:%@", responseObject);
                if ([responseObject[@"status"] integerValue] == 1) {
                    NSArray *brands = responseObject[@"brands"];
                    if ([brands isKindOfClass:[NSArray class]] && brands.count > 0) {
                        
                        NSMutableDictionary *sectionDic = [NSMutableDictionary dictionary];
                        NSMutableArray *mArr = [NSMutableArray array];
                        
                        for (NSDictionary *jsonDic in brands) {
                            
                            CarModel *model = [[CarModel alloc] initContentWithDic:jsonDic];
                            
                            NSString *sectionTitle = model.first_letter;
                            
                            NSMutableArray *rowArray =[sectionDic objectForKey:sectionTitle];
                            
                            if (rowArray == nil) {
                                [mArr addObject:sectionTitle];
                                rowArray = [NSMutableArray array];
                                [sectionDic setObject:rowArray forKey:model.first_letter];
                            }
                            
                            [rowArray addObject:model];
                        }
                        
                        NSArray *array = @[mArr, sectionDic];
                        
                        [subscriber sendNext:array];
                        [subscriber sendCompleted];
                    }
                }
            } failure:^(NSError *error) {
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
        
        return signal;
        
    }];
}



- (void)hotCommandAction {
    _hotCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {

        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [DataService http_Post:HOTCAR parameters:input success:^(id responseObject) {
                if ([responseObject[@"status"] integerValue] == 1) {
//                    NSLog(@"hot:%@", responseObject);
                    NSArray *hotBrands = responseObject[@"rexiaoche"];
                    if ([hotBrands isKindOfClass:[NSArray class]] && hotBrands.count>0) {
                        
                        NSMutableArray *mArr = [NSMutableArray array];
                        for (NSDictionary *jsonDic in hotBrands) {
                            
                            CarModel *model = [[CarModel alloc] initContentWithDic:jsonDic];
                            [mArr addObject:model];
                        }
                        [subscriber sendNext:mArr];
                        [subscriber sendCompleted];
                    }
                }
            } failure:^(NSError *error) {
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
        
        return signal;
    }];
}

#pragma mark - lazyloading
-(RACCommand *)carProCommand {
    if (!_carProCommand) {
        
        @weakify(self);
        _carProCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self);
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                params[@"bid"] = self.brandID;
                params[@"cityid"] = [UserDefaults objectForKey:kLocationAction][@"cityid"];
                
                //网络请求
                [DataService http_Post:CARPROS parameters:params success:^(id responseObject) {
//                    NSLog(@"pro:%@", responseObject);
                    if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
                        NSArray *jsonArr = [responseObject objectForKey:@"products"];
                        if ([jsonArr isKindOfClass:[NSArray class]] && jsonArr.count > 0) {
                            
                            NSMutableArray *mArr = [NSMutableArray array];
                            for (NSDictionary *jsonDic in jsonArr) {
                                CarModel *model = [[CarModel alloc] initContentWithDic:jsonDic];
                                [mArr addObject:model];
                            }
                            [subscriber sendNext:mArr];
                            [subscriber sendCompleted];
                        }else {
                            [subscriber sendCompleted];
                        }
                    }
                    
                } failure:^(NSError *error) {
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
        }];
    }
    return _carProCommand;
}

/*
-(RACCommand *)carTypeCommand {
    if (!_carTypeCommand) {
        _carTypeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [DataService http_Post:CAR_TYPE parameters:nil success:^(id responseObject) {
                    
                    if ([responseObject[@"status"] integerValue] == 1) {
                        NSArray *arr = responseObject[@"models"];
                        if ([arr isKindOfClass:[NSArray class]] && arr.count > 0) {
                            
                            NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
                            for (NSDictionary *jsonDic in arr) {
//                                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:jsonDic[@"model_id"], jsonDic[@"model_name"], nil];
//                                [mArr addObject:dic];
                                [mDic setObject:jsonDic[@"model_id"] forKey:jsonDic[@"model_name"]];
                            }
                            
                            [subscriber sendNext:mDic];
                        }
                    }
                    
                    [subscriber sendCompleted];
                } failure:^(NSError *error) {
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
        }];
    }
    return _carTypeCommand;
}
*/



@end
