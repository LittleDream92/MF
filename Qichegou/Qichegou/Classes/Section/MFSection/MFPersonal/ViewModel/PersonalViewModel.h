//
//  PersonalViewModel.h
//  Qichegou
//
//  Created by Meng Fan on 16/9/21.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonalViewModel : NSObject

@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *imgNamesArr;

//命令
@property (nonatomic, strong, readonly) RACCommand *settingCommand;
@property (nonatomic, strong, readonly) RACCommand *myOrderCommand;
@property (nonatomic, strong, readonly) RACCommand *myActivityCommand;
@property (nonatomic, strong, readonly) RACCommand *loginCommand;

@end
