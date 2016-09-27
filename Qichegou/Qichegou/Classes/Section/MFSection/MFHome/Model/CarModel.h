//
//  CarModel.h
//  QiChegou
//
//  Created by Meng Fan on 16/9/26.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "BaseModel.h"

@interface CarModel : BaseModel

/*
 "brand_name" = "\U73b0\U4ee3";
 "buyers_count" = 26;
 "car_id" = 1426;
 "car_subject" = "2.0L \U81ea\U52a8 GLS \U667a\U80fd\U578b";
 "guide_price" = "17.48";
 "main_photo" = "/Uploads/2016-04/20160411093131-77828.jpg";
 "pro_id" = 365;
 "pro_subject" = "\U7d22\U7eb3\U5854\U4e5d";
 "promot_num" = 10;
 "promot_price" = "15.38";
 year = 2015;
 */

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
