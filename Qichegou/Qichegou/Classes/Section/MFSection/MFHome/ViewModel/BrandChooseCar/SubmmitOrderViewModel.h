//
//  SubmmitOrderViewModel.h
//  Qichegou
//
//  Created by Meng Fan on 16/10/12.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubmmitOrderViewModel : NSObject

/**
 *  提交订单需要的参数
 */
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *neishi;
@property (nonatomic, copy) NSString *gcfs;
@property (nonatomic, copy) NSString *gcsj;


/** 提交订单命令 */
@property (nonatomic, strong) RACCommand *submmitOrderCommand;

@end
