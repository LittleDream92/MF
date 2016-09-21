//
//  UILabel+Extension.m
//  BuyCar
//
//  Created by Song Gao on 15/12/24.
//  Copyright © 2015年 Meng Fan. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)

- (void)createLabelWithFontSize:(NSInteger)fontSize color:(UIColor *)color
{
    //设置字体大小
    self.font = [UIFont systemFontOfSize:fontSize];
    
    //设置字体颜色
    self.textColor = color;
}

/*自定义，两种不同的颜色*/
- (NSMutableAttributedString *)makeDifferentColorWithText:(NSString *)textStr colorText:(NSString *)colorStr color:(UIColor *)color
{
    NSMutableAttributedString *textString = [[NSMutableAttributedString alloc] initWithString:textStr];
    
    NSRange colorRange = NSMakeRange([[textString string] rangeOfString:colorStr].location, [[textString string] rangeOfString:colorStr].length);
    [textString addAttribute:NSForegroundColorAttributeName value:color range:colorRange];
    
    return textString;
}


@end
