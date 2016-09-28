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

//品牌
@property (nonatomic, strong, readonly) RACCommand *brandCommand;
//热销车
@property (nonatomic, strong, readonly) RACCommand *hotCommand;
//车系
@property (nonatomic, strong, readonly) RACCommand *carProCommand;
- (void)requestCarProWithDictionary:(NSDictionary *)dic;

@end
