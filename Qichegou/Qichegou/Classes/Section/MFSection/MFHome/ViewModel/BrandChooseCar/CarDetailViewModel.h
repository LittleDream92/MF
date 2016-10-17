//
//  CarDetailViewModel.h
//  Qichegou
//
//  Created by Meng Fan on 16/9/28.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CarModel;
@interface CarDetailViewModel : NSObject

@property (nonatomic, assign) BOOL haveLogin;

/**
 *  ViewController中用到的具体数据
 */
@property (nonatomic, strong) NSArray *chooseTitleArray;
@property (nonatomic, strong) NSArray *imgNameArray;
@property (nonatomic, strong) NSArray *pushArray;
@property (nonatomic, strong) NSArray *pushTitleArr;
@property (nonatomic, strong) NSArray *keyArray;
@property (nonatomic, strong) NSMutableDictionary *getBackChooseDictionary;

@property (nonatomic, strong) NSArray *colorArray;

//具体车型的网络请求
@property (nonatomic, strong) RACCommand *carDetailCommand;
@property (nonatomic, strong) CarModel *carModel;

//车型颜色请求命令
@property (nonatomic, strong) RACCommand *carColorCommand;

//参数请求命令
@property (nonatomic, strong) RACCommand *carParamsCommand;
//图片请求命令
@property (nonatomic, strong) RACCommand *carImagesCommand;



//请求数据的车型ID
@property (nonatomic, copy) NSString *carID;
//请求图片时的下标
@property (nonatomic, assign) NSInteger index;



//提交订单按钮对应的命令
@property (nonatomic, strong) RACCommand *submmitOrderCommand;


@end
