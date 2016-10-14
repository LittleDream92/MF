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
    
    /*
     _keyArray = @[@"WaiGuan", @"Neishi", @"Way", @"Time"];
     _getBackChooseDictionary = [NSMutableDictionary dictionary];
     self.pushTitleArr = @[@[@"无要求",@"深色",@"浅色"],
     @[@"新车全款", @"新车分期", @"置换全新",@"置换分期"],
     @[@"7天内", @"14天内",@"30天"],
     @[@"上海",@"北京",@"南昌",@"哈尔滨"]];
     self.pushArray = @[@"外观颜色",@"内饰颜色",@"购车方式",@"购车时间"];
     self.celltitleArray = @[@[@"选择外观颜色",@"选择内饰颜色",@"新车或者置换",@"购车时间",@"上牌城市"],
     @[@"我的姓名",@"我的手机",@"请输入验证码"]];
     self.imgNameArray = @[@[@"icon_1",@"icon_2",@"icon_3",@"icon_4"],
     @[@"sale_my", @"sale_tel", @"sale_code"]];
     */
    self.chooseTitleArray = @[@"请输入真实姓名", @"请输入11位手机号", @"请输入验证码", @"请选择外观颜色", @"请选择内饰颜色", @"请选择购车方式", @"请选择购车时间"];
    self.imgNameArray = self.imgNameArray = @[@"sale_my", @"sale_tel", @"sale_code",@"icon_1",@"icon_2",@"icon_3",@"icon_4"];
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
                                   NSArray *carImgs = [jsonDic objectForKey:@"car_imgs"];
                                   if ([carImgs isKindOfClass:[NSArray class]] && carImgs.count > 0) {
                                       
                                       for (NSDictionary *jsonDic in carImgs) {
                                           NSString *imgURL = jsonDic[@"img"];
                                           [mArr addObject:imgURL];
                                       }
                                   }
                                   detailModel.color_imgs = (NSArray *)mArr;
                                   
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
        _carParamsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
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

@end
