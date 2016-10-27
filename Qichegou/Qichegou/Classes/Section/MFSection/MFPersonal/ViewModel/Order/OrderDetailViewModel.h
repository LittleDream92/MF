//
//  OrderDetailViewModel.h
//  Qichegou
//
//  Created by Meng Fan on 16/10/25.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetailViewModel : NSObject

@property (nonatomic, copy) NSString *orderID;

-(instancetype)initWithOrderID:(NSString *)orderID;

@property (nonatomic, strong) RACCommand *orderDetailCommand;
@property (nonatomic, strong) RACCommand *cancelOrderCommand;

@end
