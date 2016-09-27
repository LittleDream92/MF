//
//  BrandModel.h
//  Qichegou
//
//  Created by Meng Fan on 16/9/23.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "BaseModel.h"

@interface BrandModel : BaseModel

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


/*
 model_id:	类型ID
 model_name:	类型名称，例如SUV
 */
@property (nonatomic, copy) NSString *model_id;
@property (nonatomic, copy) NSString *model_name;

@end
