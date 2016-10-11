//
//  AiCheModel.h
//  Qichegou
//
//  Created by Meng Fan on 16/7/29.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "BaseModel.h"

@interface AiCheModel : BaseModel

/*
 city_code:	 城市代码
 chepai:		 车牌号码
 chepai_type: 车牌种类，‘01’是黄牌大型车，‘02’是蓝牌小型车
 fadongji:	 发动机号
 chejiahao:	 车架号
 */

@property (nonatomic, copy) NSString *city_code;
@property (nonatomic, copy) NSString *city_name;    //城市名称
@property (nonatomic, copy) NSString *chepai;
@property (nonatomic, copy) NSString *chepai_type;
@property (nonatomic, copy) NSString *fadongji;
@property (nonatomic, copy) NSString *chejiahao;


@end
