//
//  UIButton+Extension.m
//  BuyCar
//
//  Created by Song Gao on 15/12/24.
//  Copyright © 2015年 Meng Fan. All rights reserved.
//

#import "UIButton+Extension.h"

@implementation UIButton (Extension)

- (void)createButtonWithBGImgName:(NSString *)bgImgName
               bghighlightImgName:(NSString *)hiImgName
                         titleStr:(NSString *)titleStr
                         fontSize:(NSInteger)titleSize
{
    if (bgImgName.length > 0) {
        [self setBackgroundImage:[UIImage imageNamed:bgImgName] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:hiImgName] forState:UIControlStateHighlighted];
    }
    self.titleLabel.font = [UIFont systemFontOfSize:titleSize];
    [self setTitle:titleStr forState:UIControlStateNormal];
}

- (void)timerStartWithText:(NSString *)titleStr
{
    //开启倒计时
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self setTitle:titleStr forState:UIControlStateNormal];
                self.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 120;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [self setTitle:[NSString stringWithFormat:@"%@S后重发",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                self.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

//- (void)http_requestForCodeWithParams:(NSString *)telString
//{
//    //参数
//    NSString *randomString = [BaseFunction ret32bitString];
//    NSString *timeSp = [NSString stringWithFormat:@"%ld", [BaseFunction getTimeSp]];
//    NSString *md5String = [[BaseFunction md5Digest:[NSString stringWithFormat:@"%@%@%@", timeSp, randomString, APPSIGN]] uppercaseString];
//    
//    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:randomString,@"nonce_str",
//                            timeSp, @"time",
//                            md5String, @"sign",
//                            telString, @"tel", nil];
//    
//    [DataService http_Post:GETCODE
//     
//                parameters:params
//     
//                   success:^(id responseObject) {
//                       
//                       NSLog(@"POST get code 成功！:%@", responseObject);
//                       NSLog(@"msg:%@", [responseObject objectForKey:@"msg"]);
//                       
//                       NSDictionary *jsonDic = responseObject;
//                       if ([[jsonDic objectForKey:@"status"] integerValue] == 1) {
//                           [PromtView showAlert:@"验证码已发送" duration:1.5];
//                           
//                       }else {
//                           [PromtView showAlert:responseObject[@"msg"] duration:1.5];
//                       }
//                       
//                   } failure:^(NSError *error) {
//                       
//                       NSLog(@"error:%@", error);
//                       [PromtView showAlert:PromptWord duration:1.5];
//                   }];
//}

@end
