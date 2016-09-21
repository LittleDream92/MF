//
//  UIButton+Extension.h
//  BuyCar
//
//  Created by Song Gao on 15/12/24.
//  Copyright © 2015年 Meng Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)

/*
 *
 * bgImgName背景图片
 * hiImgName 高亮背景图片
 * titleStr  button标题
 * titleSize 字体大小
 */
- (void)createButtonWithBGImgName:(NSString *)bgImgName
               bghighlightImgName:(NSString *)hiImgName
                         titleStr:(NSString *)titleStr
                         fontSize:(NSInteger)titleSize;


/*
 * 开始倒计时
 * titleStr 倒计时结束显示的button标题
 */
- (void)timerStartWithText:(NSString *)titleStr;


///*
// * 获取验证码的网络请求
// * telString 手机号字符串
// */
//- (void)http_requestForCodeWithParams:(NSString *)telString;

@end
