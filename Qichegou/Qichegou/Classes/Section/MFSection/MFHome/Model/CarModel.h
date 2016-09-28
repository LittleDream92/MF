//
//  CarModel.h
//  QiChegou
//
//  Created by Meng Fan on 16/9/26.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "BaseModel.h"

@interface CarModel : BaseModel


@property (nonatomic, copy) NSString *first_letter;

@property (nonatomic, copy) NSString *promot_num;

/*
 brand_id:		品牌ID
 brand_name:		品牌名称
 pro_id:			车系ID
 pro_subject:	车系名称
 main_photo:		车系图片  // 1.03版后弃用
 car_id:			车型ID
 car_subject:	车型名称
 year:			年份
 guide_price:	指导价
 price:			优惠价
 offset:			差价（指导价-优惠价）
 promot_zt:		是否特价车 0不是，1是
 promot_price:	特价价格
 buyers_count：	多少人正在买
 
 color_imgs: [	一组颜色图
 {
 color:	颜色名称
 img:	对应颜色的汽车图片
 }
 ]
 
 */

@property (nonatomic, strong) NSString *brand_id;

@property (nonatomic, strong) NSString *brand_name;

@property (nonatomic, strong) NSString *pro_id;

@property (nonatomic, strong) NSString *pro_subject;

@property (nonatomic, strong) NSString *main_photo;

@property (nonatomic, strong) NSString *car_id;

@property (nonatomic, strong) NSString *car_subject;

@property (nonatomic, strong) NSString *year;

@property (nonatomic, strong) NSString *guide_price;

@property (nonatomic, strong) NSString *price;

@property (nonatomic, strong) NSString *offset;

@property BOOL *promot_zt;

@property (nonatomic, strong) NSString *promot_price;

@property (nonatomic, strong) NSString *buyers_count;
/*缩略图*/
@property (nonatomic, copy) NSString *thumb;

/*不同颜色*/
@property (nonatomic, strong) NSArray *color_imgs;
/*不同颜色*/
@property (nonatomic, strong) NSArray *color_text;

/*
 child_brand_name:	子品牌名称	例如马自达品牌下：长安马自达、一汽马自达 （注意：有的品牌没有子品牌，例如国产品牌）
 pro_id:			车系ID
 pro_subject:	车系名称
 main_photo:		车系图片
 {
 "child_brand_name" = "";
 img = "/Uploads/2015-05/20150526042324-81042.jpg";
 "max_price" = "57.81";
 "min_price" = "27.28";
 */
@property (nonatomic, strong) NSString *img;

@property (nonatomic, strong) NSString *max_price;

@property (nonatomic, strong) NSString *min_price;

@property (nonatomic, strong) NSString *child_brand_name;




@end
