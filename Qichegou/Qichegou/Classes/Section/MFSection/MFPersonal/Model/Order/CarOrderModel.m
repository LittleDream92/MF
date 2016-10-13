//
//  CarOrderModel.m
//  Qichegou
//
//  Created by Meng Fan on 16/10/13.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "CarOrderModel.h"

@implementation CarOrderModel


-(id)initContentWithDic:(NSDictionary *)jsonDic
{
    self = [super initContentWithDic:jsonDic];
    if (self) {
        //处理特殊数据
        CGFloat dingjin = [[jsonDic objectForKey:@"ding_jin"] floatValue];
        self.ding_jin = [NSString stringWithFormat:@"%.0f", dingjin];
    }
    return self;
}

@end
