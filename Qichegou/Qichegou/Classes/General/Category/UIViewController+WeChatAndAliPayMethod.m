//
//  UIViewController+WeChatAndAliPayMethod.m
//  WeChatAndAliPayDemo
//
//  Created by 李政 on 15/10/21.
//  Copyright © 2015年 Leon李政. All rights reserved.
//

#import "UIViewController+WeChatAndAliPayMethod.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"

@implementation UIViewController (WeChatAndAliPayMethod)

- (void)payTheMoneyUseWeChatPayWithPrepay_id:(NSString *)prepay_id

                                   partnerID:(NSString *)partinerID

                                   nonce_str:(NSString *)nonce_str

                                   timeStamp:(NSString *)timeStamp

                                     package:(NSString *)package

                                        sign:(NSString *)sign
{
    //调起微信支付···
    PayReq* req             = [[PayReq alloc] init];
    req.partnerId           = partinerID;
    req.prepayId            = prepay_id;
    req.nonceStr            = nonce_str;
    req.timeStamp           = [timeStamp intValue];
    req.package             = package;
    req.sign                = sign;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti:) name:@"weixin_pay_result" object:nil];
    [WXApi sendReq:req];
}

//微信付款成功失败
-(void)noti:(NSNotification *)noti{
    NSLog(@"%@",noti);
    if ([[noti object] isEqualToString:@"成功"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:WX_PAY_RESULT object:IS_SUCCESSED];

    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:WX_PAY_RESULT object:IS_FAILED];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"weixin_pay_result" object:nil];
}


//===========================分割线==========================================================

//支付宝支付
-(void)payTHeMoneyUseAliPayWithOrderId:(NSString *)orderId totalMoney:(NSString *)totalMoney payTitle:(NSString *)payTitle
{
    NSMutableString *orderString = [NSMutableString string];
    [orderString appendFormat:@"service=\"%@\"", @"mobile.securitypay.pay"]; //
    [orderString appendFormat:@"&partner=\"%@\"", AliPartnerID];          //
    [orderString appendFormat:@"&_input_charset=\"%@\"", @"utf-8"];    //
    
    [orderString appendFormat:@"&notify_url=\"%@\"", AliNotifyURL];       //
    [orderString appendFormat:@"&out_trade_no=\"%@\"", orderId];   //
    [orderString appendFormat:@"&subject=\"%@\"", payTitle];        //
    [orderString appendFormat:@"&payment_type=\"%@\"", @"1"];          //
    [orderString appendFormat:@"&seller_id=\"%@\"", AliSellerID];         //
    [orderString appendFormat:@"&total_fee=\"%@\"", totalMoney];         //
    [orderString appendFormat:@"&body=\"%@\"", payTitle];              //
    [orderString appendFormat:@"&showUrl =\"%@\"", @"m.alipay.com"];
    
    
    id<DataSigner> signer = CreateRSADataSigner(AliPartnerPrivKey);
    NSString *signedString = [signer signString:orderString];
    
    [orderString appendFormat:@"&sign=\"%@\"", signedString];
    [orderString appendFormat:@"&sign_type=\"%@\"", @"RSA"];
    
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:kAliPayURLScheme callback:^(NSDictionary *resultDic)
     {
         NSLog(@"reslut = %@",resultDic);
         if ([[resultDic objectForKey:@"resultStatus"] isEqual:@"9000"]) {
             //支付成功
             [[NSNotificationCenter defaultCenter] postNotificationName:ALI_PAY_RESULT object:ALIPAY_SUCCESSED];
             
         }else{
             [[NSNotificationCenter defaultCenter] postNotificationName:ALI_PAY_RESULT object:ALIPAY_FAILED];
         }
     }];

}
@end
