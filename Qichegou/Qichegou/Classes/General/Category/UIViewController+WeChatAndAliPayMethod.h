//
//  UIViewController+WeChatAndAliPayMethod.h
//  WeChatAndAliPayDemo
//
//  Created by 李政 on 15/10/21.
//  Copyright © 2015年 Leon李政. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VendorMacro.h"

@interface UIViewController (WeChatAndAliPayMethod)
/**
 *  微信支付调用方法
 */

- (void)payTheMoneyUseWeChatPayWithPrepay_id:(NSString *)prepay_id

                                   partnerID:(NSString *)partinerID

                                   nonce_str:(NSString *)nonce_str

                                   timeStamp:(NSString *)timeStamp

                                     package:(NSString *)package

                                        sign:(NSString *)sign;


/**
 *  支付宝支付调用方法
 *
 *  @param orderId    订单id（一般是后台生成之后返给你，你把这个id填到这里）
 *  @param totalMoney 钱数
 *  @param payTitle   支付页面的标题（说白了就是让客户知道这是花得什么钱，买了什么）
 */
- (void)payTHeMoneyUseAliPayWithOrderId:(NSString *)orderId totalMoney:(NSString *)totalMoney payTitle:(NSString *)payTitle;


@end
