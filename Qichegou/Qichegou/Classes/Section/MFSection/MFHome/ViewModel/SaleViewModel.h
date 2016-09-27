//
//  SaleViewModel.h
//  QiChegou
//
//  Created by Meng Fan on 16/9/26.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaleViewModel : NSObject

//品牌
@property (nonatomic, strong, readonly) RACCommand *saleCommand;

@end
