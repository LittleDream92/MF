//
//  SubmmitOrderViewModel.h
//  Qichegou
//
//  Created by Meng Fan on 16/10/12.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CarModel;

@interface SubmmitOrderViewModel : NSObject


//车型ID
@property (nonatomic, copy) NSString *cid;

/**
 *  ViewController中用到的具体数据
 */
@property (nonatomic, strong) NSArray *chooseTitleArray;
@property (nonatomic, strong) NSArray *imgNameArray;
@property (nonatomic, strong) NSArray *pushArray;
@property (nonatomic, strong) NSArray *pushTitleArr;
@property (nonatomic, strong) NSArray *keyArray;
@property (nonatomic, strong) NSMutableDictionary *getBackChooseDictionary;

/**
 *  提交订单需要的参数
 */
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *waiGuan;
@property (nonatomic, copy) NSString *neishi;
@property (nonatomic, copy) NSString *gcfs;
@property (nonatomic, copy) NSString *gcsj;


/** 1、具体车型的网络请求 */
@property (nonatomic, strong) RACCommand *carDetailCommand;
/** 2、参数请求命令 */
@property (nonatomic, strong) RACCommand *carParamsCommand;
/** 提交订单命令 */
@property (nonatomic, strong) RACCommand *submmitOrderCommand;


/** 1、具体车型请求数据的结果 */
@property (nonatomic, strong) NSArray *colorArray;
@property (nonatomic, strong) CarModel *carModel;
/** 2、参数请求结果 */
@property (nonatomic, strong) NSArray *keyArr;
@property (nonatomic, strong) NSArray *valueArr;



/** 自定义初始化方法 */
-(instancetype)initWithCarID:(NSString *)carID;

@end
