//
//  CarDetailViewModel.m
//  Qichegou
//
//  Created by Meng Fan on 16/9/28.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "CarDetailViewModel.h"
#import "CarModel.h"
#import "AppDelegate.h"

@interface CarDetailViewModel ()

@property (nonatomic, strong) RACSignal *submmitEnableSignal;

@end

@implementation CarDetailViewModel

-(instancetype)init {
    self = [super init];
    if (self) {
        [self setUpData];
        [self setUpCommand];
    }
    return self;
}

- (void)setUpData {
    self.getBackChooseDictionary = [NSMutableDictionary dictionary];
    self.chooseTitleArray = @[@"请输入真实姓名", @"请输入11位手机号", @"请输入验证码", @"请选择外观颜色", @"请选择内饰颜色", @"请选择购车方式", @"请选择购车时间"];
    self.imgNameArray = self.imgNameArray = @[@"sale_my", @"sale_tel", @"sale_code",@"icon_1",@"icon_2",@"icon_3",@"icon_4"];
    self.pushArray = @[@"外观颜色",@"内饰颜色",@"购车方式",@"购车时间"];
    self.pushTitleArr = @[@[@"无要求",@"深色",@"浅色"],
                          @[@"新车全款", @"新车分期", @"置换全新",@"置换分期"],
                          @[@"7天内", @"14天内",@"30天"],
                          @[@"上海",@"北京",@"南昌",@"哈尔滨"]];
    self.keyArray = @[@"WaiGuan", @"Neishi", @"Way", @"Time"];
}

- (void)setUpCommand {
    [self carDetailCommandAction];
}

#pragma mark - request action
- (void)carDetailCommandAction {
    @weakify(self);
    _carDetailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            //网络请求
            [DataService http_Post:DETAIL_CAR
                        parameters:input
                           success:^(id responseObject) {
                               NSLog(@"detail Car:%@", responseObject);
                               
                               if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
                                   NSDictionary *jsonDic = [responseObject objectForKey:@"car"];
                                   CarModel *detailModel = [[CarModel alloc] initContentWithDic:jsonDic];
                                   
                                   NSMutableArray *mArr = [NSMutableArray array];
                                   NSMutableArray *mArr2 = [NSMutableArray array];
                                   NSArray *carImgs = [jsonDic objectForKey:@"car_imgs"];
                                   if ([carImgs isKindOfClass:[NSArray class]] && carImgs.count > 0) {
                                       
                                       for (NSDictionary *jsonDic in carImgs) {
                                           NSString *imgURL = jsonDic[@"img"];
                                           [mArr addObject:imgURL];
                                           
                                           NSString *colorStr = jsonDic[@"color"];
                                           [mArr2 addObject:colorStr];
                                       }
                                   }
                                   
                                   detailModel.color_imgs = (NSArray *)mArr;
                                   self.colorArray = (NSArray *)mArr2;
                                   
                                   self.carModel = detailModel;
                                   [subscriber sendNext:nil];
                                   [subscriber sendCompleted];
                               }else {
                                   
                                   NSLog(@"%@", [responseObject objectForKey:@"msg"]);
                                   [PromtView showAlert:[responseObject objectForKey:@"msg"] duration:1.5];
                                   [subscriber sendCompleted];
                               }
                               
                           } failure:^(NSError *error) {
                               [PromtView showAlert:PromptWord duration:1.5];
                               [subscriber sendCompleted];
                           }];

            
            return nil;
        }];
        
        return signal;
    }];
}


#pragma mark - 
-(BOOL)haveLogin {
    if (!_haveLogin) {
        if ([AppDelegate APP].user) {
            _haveLogin = YES;
        }else {
            _haveLogin = NO;
        }
    }
    return _haveLogin;
}

//参数的网络请求
-(RACCommand *)carParamsCommand {
    if (!_carParamsCommand) {
        @weakify(self);
        _carParamsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self);
                NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.carID ,@"cid", nil];
                
                [DataService http_Post:PARAMSLIST parameters:params success:^(id responseObject) {
                    if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
                        NSArray *responsArr = [responseObject objectForKey:@"params"];
                        if ([responsArr isKindOfClass:[NSArray class]] && responsArr.count > 0) {
                            
                            //处理参数
                            NSMutableArray *mArrTitle = [NSMutableArray array];
                            NSMutableArray *keyArray = [NSMutableArray array];
                            NSMutableArray *valueArray = [NSMutableArray array];
                            
                            for (NSDictionary *dic in responsArr) {
                                NSString *groupTitle = dic[@"group_name"];
                                [mArrTitle addObject:groupTitle];
                                
                                NSArray *keyValueArr = dic[@"params"];
                                NSMutableArray *keyArr = [NSMutableArray array];
                                NSMutableArray *valueArr = [NSMutableArray array];
                                for (NSDictionary *jsonDic in keyValueArr) {
                                    [keyArr addObject:jsonDic[@"param"]];
                                    [valueArr addObject:jsonDic[@"value"]];
                                }
                                
                                [keyArray addObject:keyArr];
                                [valueArray addObject:valueArr];
                            }
                            
                            //把组名，key、value发送出去
                            NSArray *nextArr = @[mArrTitle, keyArray, valueArray];
                            [subscriber sendNext:nextArr];
                            [subscriber sendCompleted];

                        }else {
                            [subscriber sendCompleted];
                        }
                    }else {
                        [subscriber sendCompleted];
                    }
                } failure:^(NSError *error) {
                    [subscriber sendCompleted];
                    [PromtView showAlert:PromptWord duration:1.5];
                }];
                
                return nil;
            }];
        }];
    }
    return _carParamsCommand;
}

-(RACCommand *)carColorCommand {
    if (!_carColorCommand) {
        @weakify(self);
        _carColorCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self);
                
                [DataService http_Post:CHOOSE_COLOR parameters:input success:^(id responseObject) {
                    NSLog(@"car colors:%@", responseObject);
                    if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
                        
                        if ([[responseObject objectForKey:@"colors"] isKindOfClass:[NSArray class]] && [[responseObject objectForKey:@"colors"] count] > 0) {
                            
                            NSArray *jsonArr = [responseObject objectForKey:@"colors"];
                            
                            NSMutableArray *mArr = [NSMutableArray array];
                            for (NSDictionary *jsonDic in jsonArr) {
                                NSString *colorText = [jsonDic objectForKey:@"color"];
                                [mArr addObject:colorText];
                            }
                            self.colorArray = mArr;
                            [subscriber sendNext:mArr];
                            [subscriber sendCompleted];
                        }else {
                            [subscriber sendCompleted];
                            [PromtView showAlert:@"此车还没有颜色可选" duration:1.5];
                        }
                        
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
    return _carColorCommand;
}

-(RACSignal *)submmitEnableSignal {
    if (!_submmitEnableSignal) {
        _submmitEnableSignal = [RACSignal combineLatest:@[RACObserve(self, getBackChooseDictionary)] reduce:^id(NSMutableDictionary *dict){
            NSLog(@"dict :%d", [dict allKeys].count);
            return @([dict allKeys].count > 4);
        }];
    }
    return _submmitEnableSignal;
}

-(RACCommand *)submmitOrderCommand {
    if (!_submmitOrderCommand) {
        _submmitOrderCommand = [[RACCommand alloc] initWithEnabled:self.submmitEnableSignal signalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                NSLog(@"即将提交订单");
                [subscriber sendCompleted];
                return nil;
            }];
        }];
    }
    return _submmitOrderCommand;
}

@end
