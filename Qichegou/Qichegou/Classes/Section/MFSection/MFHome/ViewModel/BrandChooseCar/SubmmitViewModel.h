//
//  SubmmitViewModel.h
//  Qichegou
//
//  Created by Meng Fan on 16/10/8.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubmmitViewModel : NSObject

//判断是否有未完成订单
@property (nonatomic, strong, readonly) RACCommand *ifHaveUncompleteOrder;

+ (void)registAndLoginWithtel:(NSString *)tel name:(NSString *)name code:(NSString *)code Block:(void(^)(NSString *token))block;

+ (void)ifHaveUmCompleteOrderWithBlock:(void(^)(BOOL have))block;

@end
