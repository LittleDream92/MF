//
//  CondationViewModel.h
//  Qichegou
//
//  Created by Meng Fan on 16/10/11.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CondationViewModel : NSObject

@property (nonatomic, copy) NSString *midID;
@property (nonatomic, copy) NSString *min;
@property (nonatomic, copy) NSString *max;

@property (nonatomic, strong) RACCommand *numCarsCommand;

@end
