//
//  BrandViewModel.m
//  QiChegou
//
//  Created by Meng Fan on 16/9/26.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "BrandViewModel.h"
#import "SaleCarModel.h"

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
                            
                            SaleCarModel *model = [[SaleCarModel alloc] initContentWithDic:jsonDic];
                            
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
                    }
                }
            } failure:^(NSError *error) {
                
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
                    NSArray *hotBrands = responseObject[@"brands"];
                    if ([hotBrands isKindOfClass:[NSArray class]] && hotBrands.count>0) {
                        
                        NSMutableArray *mArr = [NSMutableArray array];
                        for (NSDictionary *jsonDic in hotBrands) {
                            
                            SaleCarModel *model = [[SaleCarModel alloc] initContentWithDic:jsonDic];
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
