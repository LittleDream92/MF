//
//  HomeViewModel.h
//  Qichegou
//
//  Created by Meng Fan on 16/10/11.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeViewModel : NSObject

//特价车列表
@property (nonatomic, strong) RACCommand *saleCatListCommand;

@end
