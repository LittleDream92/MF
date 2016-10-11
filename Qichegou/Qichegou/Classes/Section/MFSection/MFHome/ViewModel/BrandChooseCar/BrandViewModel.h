//
//  BrandViewModel.h
//  QiChegou
//
//  Created by Meng Fan on 16/9/26.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrandViewModel : NSObject

@property (nonatomic, strong) NSArray *proArr;

/** 品牌选车*/

@property (nonatomic, strong, readonly) RACCommand *brandCommand;
//热销车
@property (nonatomic, strong, readonly) RACCommand *hotCommand;

@property (nonatomic, copy) NSString *brandID;
//车系
@property (nonatomic, strong) RACCommand *carProCommand;



/** 条件选车*/
//条件选车虽然有接口，但是图片，车辆类型都是固定的，ID也是collectionView的Item下标+1，为了减轻网络请求的负担，不再进行网络请求
//@property (nonatomic, strong) RACCommand *carTypeCommand;


@end
