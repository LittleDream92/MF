//
//  CityDetailModel.m
//  CityDemo
//
//  Created by Meng Fan on 16/7/20.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "CityDetailModel.h"

@implementation CityDetailModel

-(id)initContentWithDic:(NSDictionary *)jsonDic {
    if (self = [super initContentWithDic:jsonDic]) {
        
        self.isNeedClass = [[jsonDic objectForKey:@"class"] boolValue];
        self.classNumber = [jsonDic objectForKey:@"classno"];
        
        self.isNeedEngine = [[jsonDic objectForKey:@"engine"] boolValue];
        self.engineNumber = [jsonDic objectForKey:@"engineno"];
    }
    return self;
}

@end
