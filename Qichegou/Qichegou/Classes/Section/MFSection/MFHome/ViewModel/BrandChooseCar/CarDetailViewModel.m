//
//  CarDetailViewModel.m
//  Qichegou
//
//  Created by Meng Fan on 16/9/28.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "CarDetailViewModel.h"
#import "OtherModel.h"
#import "CarModel.h"
#import "AppDelegate.h"

@interface CarDetailViewModel ()

//@property (nonatomic, strong) RACSignal *submmitEnableSignal;

@end

@implementation CarDetailViewModel


-(instancetype)initWithCarID:(NSString *)carID {
    self = [super init];
    if (self) {
        self.carID = carID;
        
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
//    NSLog(@"model view : %@", self.carID);
}

#pragma mark -

//具体车型的网络请求
-(RACCommand *)carDetailCommand {
    if (!_carDetailCommand) {
        @weakify(self);
        _carDetailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self requestDetailCarWithParams:input];
        }];
    }
    return _carDetailCommand;
}

//参数的网络请求
-(RACCommand *)carParamsCommand {
    if (!_carParamsCommand) {
        _carParamsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [self requestParamsWithParams:input];
        }];
    }
    return _carParamsCommand;
}

//图片的网络请求
-(RACCommand *)carImagesCommand {
    if (!_carImagesCommand) {
        _carImagesCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [self requestCarImagesWithParams:input];
        }];
    }
    return _carImagesCommand;
}

#pragma mark - RAC request
//具体车型数据的网络请求
- (RACSignal *)requestDetailCarWithParams:(NSDictionary *)params {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [DataService http_Post:DETAIL_CAR parameters:params success:^(id responseObject) {
            if ([responseObject[@"status"] integerValue] == 1) {
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
                    self.colorArray = (NSArray *)mArr2;
                    
                }else {
                    self.colorArray = (NSArray *)@[@"默认"];
                    [PromtView showAlert:@"此车暂无可选的外观颜色" duration:1.5];
                }
                
                detailModel.color_imgs = (NSArray *)mArr;
                
                self.carModel = detailModel;
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            }else {
                [PromtView showAlert:[responseObject objectForKey:@"msg"] duration:1.5];
                [subscriber sendCompleted];
            }

        } failure:^(NSError *error) {
            [PromtView showAlert:PromptWord duration:1.5];
            [subscriber sendCompleted];
        }];
        
        return nil;
    }];
}

//参数的网络请求
- (RACSignal *)requestParamsWithParams:(NSDictionary *)params {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
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
                    
                    self.keyArr = keyArray;
                    self.valueArr = valueArray;
                    
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
}


//车型图片的网络请求
- (RACSignal *)requestCarImagesWithParams:(NSDictionary *)params {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        [DataService http_Post:IMGS parameters:params success:^(id responseObject) {
            NSLog(@"car images :%@", responseObject);
            
            if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
                NSArray *jsonArr = [responseObject objectForKey:@"images"];
                if ([jsonArr isKindOfClass:[NSArray class]] && jsonArr.count > 0) {
                    NSMutableArray *mArr = [NSMutableArray array];
                    for (NSDictionary *jsonDic in jsonArr) {

                        OtherModel *model = [[OtherModel alloc] initContentWithDic:jsonDic];
                        [mArr addObject:model];
                    }
                    
                    [subscriber sendNext:mArr];
                    [subscriber sendCompleted];
                }else {
                    [PromtView showMessage:@"暂无图片" duration:1.5];
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                }
            }else {
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
                [PromtView showMessage:responseObject[@"msg"] duration:1.5];
            }

        } failure:^(NSError *error) {
            NSLog(@"car images error:%@", error);
            [subscriber sendCompleted];
            [PromtView showMessage:PromptWord duration:1.5];
        }];
        
        return nil;
    }];
}


#pragma mark - 非RAC的网络请求图片
//- (void)requestImagesWithIndex:(NSInteger)index {
//    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.carID,@"cid",
//                            [NSString stringWithFormat:@"%ld", index], @"type", nil];
//    
//    [DataService http_Post:IMGS parameters:params success:^(id responseObject) {
////        NSLog(@"%ld car images :%@", index , responseObject);
//        
//        if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
//            NSArray *jsonArr = [responseObject objectForKey:@"images"];
//            if ([jsonArr isKindOfClass:[NSArray class]] && jsonArr.count > 0) {
//                NSMutableArray *mArr = [NSMutableArray array];
//                [mArr removeAllObjects];
//                for (NSDictionary *jsonDic in jsonArr) {
//                    
//                    OtherModel *model = [[OtherModel alloc] initContentWithDic:jsonDic];
//                    [mArr addObject:model];
//                }
//                if (index == 1) {
//                    self.img1_arr = mArr;
//                }else if (index == 2) {
//                    self.img2_arr = mArr;
//                }else if (index == 3) {
//                    self.img3_arr = mArr;
//                }else if (index == 4) {
//                    self.img4_arr = mArr;
//                }
//                
//            }else {
//                if (index == 1) {
//                    self.img1_arr = @[@"暂无图片"];
//                }else if (index == 2) {
//                    self.img2_arr = @[@"暂无图片"];
//                }else if (index == 3) {
//                    self.img3_arr = @[@"暂无图片"];
//                }else if (index == 4) {
//                    self.img4_arr = @[@"暂无图片"];
//                }
//                [PromtView showMessage:@"暂无图片" duration:1.5];
//            }
//        }else {
//            if (index == 1) {
//                self.img1_arr = @[@"暂无图片"];
//            }else if (index == 2) {
//                self.img2_arr = @[@"暂无图片"];
//            }else if (index == 3) {
//                self.img3_arr = @[@"暂无图片"];
//            }else if (index == 4) {
//                self.img4_arr = @[@"暂无图片"];
//            }
//            [PromtView showMessage:responseObject[@"msg"] duration:1.5];
//        }
//        
////        NSLog(@"img1: %@\n img2:%@\n img3:%@\n img4:%@", self.img1_arr, self.img2_arr, self.img3_arr, self.img4_arr);
//        
//        
//    } failure:^(NSError *error) {
////        NSLog(@"car images error:%@", error);
//        if (index == 1) {
//            self.img1_arr = @[PromptWord];
//        }else if (index == 2) {
//            self.img2_arr = @[PromptWord];
//        }else if (index == 3) {
//            self.img3_arr = @[PromptWord];
//        }else if (index == 4) {
//            self.img4_arr = @[PromptWord];
//        }
//        [PromtView showMessage:PromptWord duration:1.5];
//    }];
//}



@end
