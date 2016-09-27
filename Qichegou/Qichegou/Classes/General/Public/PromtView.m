//
//  PromtView.m
//  Qichegou
//
//  Created by Song Gao on 16/2/1.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "PromtView.h"

@implementation PromtView

//==============================================================================
#pragma mark - 一、显示定制View的消息，定时消失
//==============================================================================
+(void)showMessage:(NSString *)message duration:(NSTimeInterval)time
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor grayColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    UILabel *label = [[UILabel alloc]init];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15.0f],
                                 NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize labelSize = [message boundingRectWithSize:CGSizeMake(207, 999)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:attributes context:nil].size;
    
    label.frame = CGRectMake(10, 5, labelSize.width +20, labelSize.height);
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    [showview addSubview:label];
    
    showview.frame = CGRectMake((screenSize.width - labelSize.width - 20)/2,
                                screenSize.height - 100,
                                labelSize.width+40,
                                labelSize.height+10);
    [UIView animateWithDuration:time animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}

#pragma mark - 二、显示UIAlert窗口消息，定时消失

//==============================================================================

//------------------------------------------------------------------------------
#pragma mark - 1、外部调用接口
//------------------------------------------------------------------------------

+(void)showAlert:(NSString *) message duration:(NSTimeInterval)time
{
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"温馨提示:"
                                                          message:message delegate:nil
                                                cancelButtonTitle:nil
                                                otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:time
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}

//------------------------------------------------------------------------------
#pragma mark - 2、外部调用接口的回调方法
//------------------------------------------------------------------------------

+(void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert = NULL;
}


//==============================================================================

#pragma mark - 三、显示UIAlert窗口消息，定时消失

//==============================================================================

//------------------------------------------------------------------------------
#pragma mark - 1、外部调用接口
//------------------------------------------------------------------------------

+(void)showAlertMessageWithMessage:(NSString*)message duration:(NSTimeInterval)time
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示:" message:message delegate:nil
                                          cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:time];
}

//------------------------------------------------------------------------------
#pragma mark - 2、外部调用接口的回调方法
//------------------------------------------------------------------------------

+(void) dimissAlert:(UIAlertView *)alert {
    if(alert)     {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
}
//------------------------------------------------------------------------------


@end
