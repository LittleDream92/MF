//
//  BaseFunction.m
//  QiChegou
//
//  Created by Meng Fan on 16/7/8.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "BaseFunction.h"
#import <CommonCrypto/CommonDigest.h>
#import <UIKit/UIKit.h>

@implementation BaseFunction

/**
 *  md5加密的字符串
 *
 *  @param str
 *
 *  @return
 */
+ (NSString *)md5Digest:(NSString *) str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

/*
 *  随机产生32位字符串， 修改代码红色数字可以改变 随机产生的位数。
 */
+(NSString *)ret32bitString {
    char data[32];
    
    for (int x=0;x<32;data[x++] = (char)('A' + (arc4random_uniform(26))));
    
    return [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
}


/*
 *  获取当前系统的时间戳
 */
+(long)getTimeSp {
    long time;
    NSDate *fromdate=[NSDate date];
    time=(long)[fromdate timeIntervalSince1970];
    return time;
}


//获取字符串的宽度
+ (float) widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height
{
    NSDictionary *attr = @{NSFontAttributeName: SYSTEMFONT(fontSize)};
    CGSize sizeToFit = [value boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                        attributes:attr
                                           context:nil].size;
    //此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.width;
}
//获得字符串的高度
+ (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    NSDictionary *attr = @{NSFontAttributeName: SYSTEMFONT(fontSize)};
    CGSize sizeToFit = [value boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                        attributes:attr
                                           context:nil].size;
    //此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.height;
}


/*
 *  返回中划线的
 *  lineString  :   需要显示中划线的字符串
 */
+ (NSMutableAttributedString *)lineWithString:(NSString *)lineString
{
    NSDictionary *attribtDic =  @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:lineString attributes:attribtDic];
    return attribtStr;
}

@end
