//
//  HomePageViewModel.h
//  QiChegou
//
//  Created by Meng Fan on 16/9/18.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomePageViewModel : NSObject

//特价车
@property (nonatomic, strong, readonly) RACCommand *saleCommand;

@end
