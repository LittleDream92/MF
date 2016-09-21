//
//  UILabel+Extension.h
//  BuyCar
//
//  Created by Song Gao on 15/12/24.
//  Copyright © 2015年 Meng Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)

- (void)createLabelWithFontSize:(NSInteger)fontSize color:(UIColor *)color;


/*自定义*/
- (NSMutableAttributedString *)makeDifferentColorWithText:(NSString *)textStr
                         colorText:(NSString *)colorStr
                             color:(UIColor *)color;


@end
