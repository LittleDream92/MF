//
//  SubmmitOrderViewModel.m
//  Qichegou
//
//  Created by Meng Fan on 16/10/12.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "SubmmitOrderViewModel.h"
#import "AppDelegate.h"
#import "CarModel.h"

@interface SubmmitOrderViewModel ()

@end


@implementation SubmmitOrderViewModel

-(instancetype)initWithCarID:(NSString *)carID {
    self = [super init];
    if (self) {
        
        self.cid = carID;
        [self setUpData];
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

#pragma mark - lazyloading
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

//提交订单的网络请求
-(RACCommand *)submmitOrderCommand {
    
    if (!_submmitOrderCommand) {
        @weakify(self);
        _submmitOrderCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            NSLog(@"input : %@", input);
            NSDictionary *params = input;
            self.name = params[@"name"];
            self.account = params[@"tel"];
            self.code = params[@"code"];
            self.waiGuan = params[@"waiguan"];
            self.neishi = params[@"neishi"];
            self.gcfs = params[@"gcfs"];
            self.gcsj = params[@"gcsj"];
            
            return [self requestSubmmitOrder];
        }];
    }
    return _submmitOrderCommand;
}

#pragma mark - request
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


/** 提交订单的Command命令 */
- (RACSignal *)requestSubmmitOrder {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        if ([AppDelegate APP].user) {   //login
            [self requestIfHaveUmCompleteOrderWithsubscriber:subscriber];
        }else {                         //unLogin
            [self requestLoginWithSubscriber:subscriber];
        }
        return nil;
    }];
}


/** 1、登录 */
- (void)requestLoginWithSubscriber:(id<RACSubscriber>)subscriber {
    NSString *randomString = [BaseFunction ret32bitString];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", [BaseFunction getTimeSp]];
    NSString *md5String = [[BaseFunction md5Digest:[NSString stringWithFormat:@"%@%@%@", timeSp, randomString, APPSIGN]] uppercaseString];
    
    
    NSDictionary *loginParams = [[NSDictionary alloc] initWithObjectsAndKeys:randomString,@"nonce_str",
                                 timeSp, @"time",
                                 md5String, @"sign",
                                 self.account,@"tel",
                                 self.code, @"code",
                                 self.name, @"name", nil];
    NSLog(@"login params : %@", loginParams);
    [DataService http_Post:ORDER_REGIST parameters:loginParams success:^(id responseObject) {
        
        NSLog(@"order login:%@", responseObject);
        if ([responseObject[@"status"] integerValue] == 1) {
            
            //存储
            UserModel *userModel = [[UserModel alloc] initContentWithDic:responseObject];
            userModel.sjhm = self.account;
            userModel.zsxm = self.name;
            userModel.token = responseObject[@"token"];
            [AppDelegate APP].user = userModel;
            //发送登录成功通知
            [NotificationCenters postNotificationName:LOGIN_SUCCESS object:nil userInfo:nil];
            
            //2、是否有未完成订单
            [self requestIfHaveUmCompleteOrderWithsubscriber:subscriber];
        }else {
            [PromtView showAlert:responseObject[@"msg"] duration:1.5];
            [subscriber sendCompleted];
        }
        
    } failure:^(NSError *error) {
        [PromtView showAlert:PromptWord duration:1.5f];
        [subscriber sendCompleted];
    }];
}


/** 2、是否有未完成订单 */
- (void)requestIfHaveUmCompleteOrderWithsubscriber:(id<RACSubscriber>)subscriber {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [AppDelegate APP].user.token, @"token",nil];
    [DataService http_Post:UNCOMPLETE_ORDER parameters:params success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        
        if ([[responseObject objectForKey:@"status"] integerValue] == 1) {  //YES
            [subscriber sendNext:@"YES"];
            [subscriber sendCompleted];
        }else if ([[responseObject objectForKey:@"status"] integerValue] == 0){ //NO
            [self LabelTextIsNullWithSubscribe:subscriber];
        }else {         //其他
            [PromtView showAlert:@"请求失败" duration:1.5];
            [subscriber sendCompleted];
        }
    } failure:^(NSError *error) {
        [PromtView showAlert:PromptWord duration:1.5f];
        [subscriber sendCompleted];
    }];
}

/** 3、提交订单 */
- (void)LabelTextIsNullWithSubscribe:(id<RACSubscriber>)subscriber {
    NSString *randomString = [BaseFunction ret32bitString];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", [BaseFunction getTimeSp]];
    NSString *md5String = [[BaseFunction md5Digest:[NSString stringWithFormat:@"%@%@%@", timeSp, randomString, APPSIGN]] uppercaseString];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[UserDefaults objectForKey:kLocationAction][@"cityid"],@"cityid",
                            
                            self.cid,@"cid",
                            
                            self.waiGuan, @"color",
                            
                            self.neishi, @"neishi",
                            
                            self.gcsj, @"gcsj",
                            
                            self.gcsj, @"gcfs",
                            
                            [AppDelegate APP].user.token, @"token",
                            
                            md5String,@"sign",
                            timeSp,@"time",
                            randomString,@"nonce_str",nil];
    NSLog(@"submmit order params : %@", params);
    
    [DataService http_Post:ADD_ORDER parameters:params success:^(id responseObject) {
        NSLog(@"submmit order:%@", responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue] == 1) {   //获取订单号
            
            NSString *orderID = [responseObject objectForKey:@"oid"];
            [subscriber sendNext:orderID];
            [subscriber sendCompleted];
        }else {
            NSLog(@"%@",[responseObject objectForKey:@"msg"]);
            [PromtView showAlert:[responseObject objectForKey:@"msg"] duration:1.5];
            [subscriber sendCompleted];
        }
    } failure:^(NSError *error) {
        [PromtView showAlert:PromptWord duration:1.5f];
        [subscriber sendCompleted];
    }];
}

@end
