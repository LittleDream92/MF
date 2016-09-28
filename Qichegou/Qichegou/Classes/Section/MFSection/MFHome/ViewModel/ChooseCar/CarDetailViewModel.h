//
//  CarDetailViewModel.h
//  Qichegou
//
//  Created by Meng Fan on 16/9/28.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarDetailViewModel : NSObject

@property (nonatomic, strong, readonly) RACCommand *carDetailCommand;

@end
