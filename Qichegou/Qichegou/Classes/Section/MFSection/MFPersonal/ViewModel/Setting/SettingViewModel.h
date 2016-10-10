//
//  SettingViewModel.h
//  Qichegou
//
//  Created by Meng Fan on 16/10/9.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingViewModel : NSObject

@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *imgArr;

//缓存大小
@property (nonatomic, assign) CGFloat cacheSize;

//计算缓存大小
- (void)countCacheAction;
//清除缓存
- (void)clearCacheAction;

@property (nonatomic, strong, readonly) RACCommand *loginOutCommand;

@end
