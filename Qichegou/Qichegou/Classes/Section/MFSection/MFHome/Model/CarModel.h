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
@property (nonatomic, copy) NSString *brand_name;
@property (nonatomic, copy) NSString *buyers_count;
@property (nonatomic, copy) NSString *car_id;
@property (nonatomic, copy) NSString *car_subject;
@property (nonatomic, copy) NSString *guide_price;
@property (nonatomic, copy) NSString *main_photo;
@property (nonatomic, copy) NSString *pro_id;
@property (nonatomic, copy) NSString *pro_subject;
@property (nonatomic, copy) NSString *promot_num;
@property (nonatomic, copy) NSString *promot_price;
@property (nonatomic, copy) NSString *year;




@end
