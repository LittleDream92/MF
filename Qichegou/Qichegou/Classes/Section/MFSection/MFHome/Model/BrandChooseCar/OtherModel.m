//
//  OtherModel.m
//  Qichegou
//
//  Created by Meng Fan on 16/4/13.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "OtherModel.h"
#import "CityDetailModel.h"

@implementation OtherModel

-(id)initContentWithDic:(NSDictionary *)jsonDic
{
    self = [super initContentWithDic:jsonDic];
    if (self) {
        //
        
        NSArray *cityArray = jsonDic[@"citys"];
        if ([cityArray isKindOfClass:[NSArray class]] && cityArray.count > 0) {
            
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *cityDic in cityArray) {
                CityDetailModel *model = [[CityDetailModel alloc] initContentWithDic:cityDic];
                [mArr addObject:model];
            }
            self.cityArray = mArr;
        }
        
        self.rule_ID = [jsonDic objectForKey:@"id"];
        self.rule_pai = [jsonDic objectForKey:@"chepai"];
        self.rule_count = [jsonDic objectForKey:@"count"];
        
        AiCheModel *model = [[AiCheModel alloc] init];
        model.city_code = [jsonDic objectForKey:@"city_code"];
        model.chepai = [jsonDic objectForKey:@"chepai"];
        model.chepai_type = [jsonDic objectForKey:@"chepai_type"];
        model.fadongji = [jsonDic objectForKey:@"fadongji"];
        model.chejiahao = [jsonDic objectForKey:@"chejiahao"];
        self.aicheModel = model;
        
    }
    return self;
}

@end
