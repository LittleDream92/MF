//
//  CarOrderModel.h
//  Qichegou
//
//  Created by Meng Fan on 16/10/13.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "BaseModel.h"

@interface CarOrderModel : BaseModel

/*
 order_id:		订单ID
 create_time:	下单时间
 expiry_date:	失效时间
 ding_jin:		订金
 guide_price:	指导价
 brand_name:	品牌
 pro_subject: 	车系名称
 main_photo:	车系图片
 car_subject:	车型名称
 color: 		外观颜色
 neishi: 		内饰颜色
 gcsj:			购车时间
 gcfs:			购车方式
 zt:			订单状态	0待付款，1已取消，2已支付，3已退款
 rebate_zt int： 返现状态
 */

@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *expiry_date;
@property (nonatomic, copy) NSString *ding_jin;
@property (nonatomic, copy) NSString *guide_price;

@property (nonatomic, copy) NSString *brand_name;
@property (nonatomic, copy) NSString *pro_subject;
@property (nonatomic, copy) NSString *main_photo;
@property (nonatomic, copy) NSString *car_subject;

@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *neishi;
@property (nonatomic, copy) NSString *gcsj;
@property (nonatomic, copy) NSString *buyTime;
@property (nonatomic, copy) NSString *gcfs;

@property (nonatomic, copy) NSString *zt;
@property (nonatomic, copy) NSString *rebate_zt;


@end
