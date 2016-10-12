//
//  BaseFunction.h
//  QiChegou
//
//  Created by Meng Fan on 16/7/8.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseFunction : NSObject

/**
 *  MD5加密
 *
 *  @param str 待加密的字符串
 *
 *  @return 加密后的字符串
 */
+ (NSString *)md5Digest:(NSString *) str;


/*
 *  随机产生32位字符串， 修改代码红色数字可以改变 随机产生的位数。
 */
+(NSString *)ret32bitString;


/*
 *  获取当前系统的时间戳
 */
+(long)getTimeSp;

/*
 *  获取字符串的宽度
 */
+ (float) widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height;

/*
 *  获得字符串的高度
 */
+ (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width;


/*
 *  返回中划线
 *  lineString  :   需要显示中划线的字符串
 */
+ (NSMutableAttributedString *)lineWithString:(NSString *)lineString;


@end
