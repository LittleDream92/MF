//
//  OtherModel.h
//  Qichegou
//
//  Created by Meng Fan on 16/4/13.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "BaseModel.h"
#import "AiCheModel.h"

@interface OtherModel : BaseModel

/*
 city_id:	城市ID
 city_name:	城市名称
 zt:		城市状态，0是未启用，1是启用，2是默认城市
 */
@property (nonatomic, copy) NSString *city_id;
@property (nonatomic, copy) NSString *city_name;
@property (nonatomic, copy) NSString *zt;

/*
 model_id:	类型ID
 model_name:	类型名称，例如SUV
 */
@property (nonatomic, copy) NSString *model_id;
@property (nonatomic, copy) NSString *model_name;

/*
 color:		颜色描述
 thumb_lg：	大的缩略图
 thumb_sm:	小的缩略图*/
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *thumb_lg;
@property (nonatomic, copy) NSString *thumb_sm;

/* 违章行为 */
@property (nonatomic, copy) NSString *act;
/* 违章地点 */
@property (nonatomic, copy) NSString *area;
/* 违章代码 */
@property (nonatomic, copy) NSString *code;
/* 违章时间 */
@property (nonatomic, copy) NSString *date;
/* 违章扣分 */
@property (nonatomic, copy) NSString *fen;
/* 违章罚款 */
@property (nonatomic, copy) NSString *money;
/* 违章处理状态 0未处理 1已处理 */
@property (nonatomic, copy) NSString *handled;


/*
 province:		省份名称
 province_code:	省份代码
 */

/* 省份代码 */
@property (nonatomic, copy) NSString *province_code;
/* 省份名称 */
@property (nonatomic, copy) NSString *province;

@property (nonatomic, strong) NSArray *cityArray;

/*
 id: 		ID
 chepai:	 	车牌
 koufen:		扣分
 fakuan:		罚款
 count:		违章记录数
 */

@property (nonatomic, copy) NSString *rule_ID;
@property (nonatomic, copy) NSString *rule_pai;
@property (nonatomic, copy) NSNumber *koufen;
@property (nonatomic, copy) NSNumber *fakuan;
@property (nonatomic, copy) NSNumber *rule_count;

@property (nonatomic, strong) AiCheModel *aicheModel;

@end
