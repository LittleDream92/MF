//
//  PromtView.h
//  Qichegou
//
//  Created by Song Gao on 16/2/1.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PromtView : NSObject

#pragma mark - 一、显示定制View的消息，定时消失
+(void)showMessage:(NSString *)message duration:(NSTimeInterval)time;



#pragma mark - 二、显示UIAlert窗口消息，定时消失
#pragma mark - 1、外部调用接口
+(void)showAlert:(NSString *) message duration:(NSTimeInterval)time;

#pragma mark - 2、外部调用接口的回调方法
+(void)timerFireMethod:(NSTimer*)theTimer;



#pragma mark - 三、显示UIAlert窗口消息，定时消失
#pragma mark - 1、外部调用接口
+(void)showAlertMessageWithMessage:(NSString*)message duration:(NSTimeInterval)time;

#pragma mark - 2、外部调用接口的回调方法
+(void) dimissAlert:(UIAlertView *)alert;

@end
