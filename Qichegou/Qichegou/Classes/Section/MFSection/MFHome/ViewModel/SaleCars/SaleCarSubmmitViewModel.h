//
//  SaleCarSubmmitViewModel.h
//  Qichegou
//
//  Created by Meng Fan on 16/10/11.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaleCarSubmmitViewModel : NSObject

//特价车详情
@property (nonatomic, strong) RACCommand *saleCarDetailCommand;

////提交订单
//@property (nonatomic, strong) RACCommand *saleCarSubmmitOrderCommand;


@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;


@end
