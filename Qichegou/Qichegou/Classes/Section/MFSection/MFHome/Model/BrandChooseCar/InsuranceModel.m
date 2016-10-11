//
//  InsuranceModel.m
//  Qichegou
//
//  Created by Meng Fan on 16/6/21.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "InsuranceModel.h"

@implementation InsuranceModel

-(id)initContentWithDic:(NSDictionary *)jsonDic {
    if (self = [super initContentWithDic:jsonDic]) {
        
        //处理特殊数据
        self.insID = [jsonDic objectForKey:@"id"];
        
        self.user_name = [jsonDic objectForKey:@"name"];
        self.user_phone = [jsonDic objectForKey:@"phone"];
        
//        self.chesun_boli = [jsonDic objectForKey:@"chesun_boli2"];
//        self.chesun_huahen = [jsonDic objectForKey:@"chesun_huahen2"];
//        self.chesun_sanfang = [jsonDic objectForKey:@"chesun_sanfang2"];
//        self.chesun_sheshui = [jsonDic objectForKey:@"chesun_sheshui2"];
//        self.chesun_zhuanxiu = [jsonDic objectForKey:@"chesun_zhuanxiu2"];
//        self.chesun_ziran = [jsonDic objectForKey:@"chesun_ziran2"];
//        self.daoqiang = [jsonDic objectForKey:@"daoqiang2"];
        
        //保险链接和条款
        NSDictionary *comDic = [jsonDic objectForKey:@"com"];
        self.com_name = [comDic objectForKey:@"com_name"];
        self.com_logo = [comDic objectForKey:@"logo"];
        self.com_phone = [comDic objectForKey:@"phone"];
        self.tiaokuan_url = [comDic objectForKey:@"tiaokuan_url"];
        
    }
    return self;
}

@end
