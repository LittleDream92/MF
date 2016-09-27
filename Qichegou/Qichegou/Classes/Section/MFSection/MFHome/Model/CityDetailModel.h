//
//  CityDetailModel.h
//  CityDemo
//
//  Created by Meng Fan on 16/7/20.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "BaseModel.h"

@interface CityDetailModel : BaseModel

/*
 city_code	城市代码
 city_name	城市名称
 engine		是否需要发动机号，0不需要， 1需要
 engineno	需要几位发动机号，0全部，   1-9需要发动机号后N位
 class		是否需要车架号，  0不需要， 1需要
 classno		需要几位车架号，  0全部，   1-9需要车架号后N位
 */
/*
 abbr = "\U6d59";
 "city_code" = "ZJ_HZ";
 "city_name" = "\U676d\U5dde";
 class = 1;
 classa = 1;
 classno = 6;
 engine = 0;
 engineno = 0;
 regist = 0;
 registno = 0;
 */

/* 城市代码 */
@property (nonatomic, copy) NSString *city_code;
/* 城市名称 */
@property (nonatomic, copy) NSString *city_name;

/* 是否需要车架号 */
@property (nonatomic, assign) BOOL isNeedClass;
/* 需要后几位车架号 */
@property (nonatomic, copy) NSString *classNumber;


/* 是否需要发动机号 */
@property (nonatomic, assign) BOOL isNeedEngine;
/* 需要后几位发动机号 */
@property (nonatomic, copy) NSString *engineNumber;


@end
