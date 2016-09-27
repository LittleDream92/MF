//
//  Interface.h
//  Qichegou
//
//  Created by Meng Fan on 16/9/21.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#ifndef Interface_h
#define Interface_h


//接口


//base url
//#define URL_String @"http://test.tangxinzhuan.com"
//#define URL_String @"http://test.qichegou.com"
#define URL_String @"http://www.qichegou.com"


#define BRABD_LIST  @"/api/car/brands"           //品牌
#define HOTCAR      @"/api/car/rexiaoche"        //热销车
#define SALECAR     @"/api/car/tejiache"         //特价车
#define ACTIVITYLIST @"/wap/activity/index"         //活动列表


#define USERLOGIN @"/api/user/login"               //验证码／密码登录

//我的活动列表
#define ACTIVITY_ORDER @"/wap/activity/myactivity"
//取消活动订单
#define CANCEL_ACTIVITY_ORDER @"/api/activity/cancel"

//**************************** 支付模块 *****************************
//请求服务器数据
#define GET_DATA @"/api/wxpayapp/getPrepayInfo"

#endif /* Interface_h */
