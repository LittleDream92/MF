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

//请求数据的车型ID
@property (nonatomic, copy) NSString *carID;

//自定义初始化方法
-(instancetype)initWithCarID:(NSString *)carID;

//图片的数据源
@property (nonatomic, strong) NSArray *img1_arr;
@property (nonatomic, strong) NSArray *img2_arr;
@property (nonatomic, strong) NSArray *img3_arr;
@property (nonatomic, strong) NSArray *img4_arr;


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


@property (nonatomic, strong) CarModel *carModel;
//参数请求结果
@property (nonatomic, strong) NSArray *keyArr;
@property (nonatomic, strong) NSArray *valueArr;



/** 具体车型的网络请求 */
@property (nonatomic, strong) RACCommand *carDetailCommand;
/** 参数请求命令 */
@property (nonatomic, strong) RACCommand *carParamsCommand;
/** 图片请求命令 */
@property (nonatomic, strong) RACCommand *carImagesCommand;




////请求图片时的下标
//@property (nonatomic, assign) NSInteger index;


@end
