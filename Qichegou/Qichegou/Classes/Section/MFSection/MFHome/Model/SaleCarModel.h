//
//  SaleCarModel.h
//  QiChegou
//
//  Created by Meng Fan on 16/9/18.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "BaseModel.h"

@interface SaleCarModel : BaseModel

/*
 brand_id:	品牌ID
 brand_name:	品牌名称
 first_letter:	品牌大写首字母
 thumb:		品牌LOGO图片
 */
@property (nonatomic, copy) NSString *brand_id;
@property (nonatomic, copy) NSString *brand_name;
@property (nonatomic, copy) NSString *first_letter;
@property (nonatomic, copy) NSString *thumb;

@end
