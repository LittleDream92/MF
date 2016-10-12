//
//  VendorMacro.h
//  Qichegou
//
//  Created by Meng Fan on 16/9/21.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#ifndef VendorMacro_h
#define VendorMacro_h



//第三方相关常量，如，友盟等

//************************ 支付宝 ************************
//合作身份者id，以2088开头的16位纯数字（客户给）
#define AliPartnerID @""

//收款支付宝账号
#define AliSellerID  @""

//商户私钥，自助生成 (pkcs8格式的)（这个私钥需要自己手动生成，具体生成方法可以看支付宝的官方文档，下面给出大体格式）
#define AliPartnerPrivKey @""

//支付宝服务器主动通知商户 网站里指定的页面 http 路径。
#define AliNotifyURL @""

//app id
#define kAliPayURLScheme @""

//通知的名字及参数
#define ALI_PAY_RESULT      @"Ali_pay_result_isSuccessed"
#define ALIPAY_SUCCESSED    @"Ali_pay_isSuccessed"
#define ALIPAY_FAILED       @"Ali_pay_isFailed"



//************************ 微信 ************************
//微信支付：通知的名字及参数
#define WX_PAY_RESULT   @"weixin_pay_result_isSuccessed"
#define IS_SUCCESSED    @"wechat_pay_isSuccessed"
#define IS_FAILED       @"wechat_pay_isFailed"


#endif /* VendorMacro_h */
