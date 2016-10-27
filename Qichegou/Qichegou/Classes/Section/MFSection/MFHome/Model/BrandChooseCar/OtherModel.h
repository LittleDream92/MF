//
//  OtherModel.h
//  Qichegou
//
//  Created by Meng Fan on 16/4/13.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "BaseModel.h"

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
 color:		颜色描述
 thumb_lg：	大的缩略图
 thumb_sm:	小的缩略图*/
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *thumb_lg;
@property (nonatomic, copy) NSString *thumb_sm;


@end
