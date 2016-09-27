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

//服务协议
#define PROTOCOL_QICHEGOU @"http://www.qichegou.com/Wap/help/detail/catid/87"


#define BRABD_LIST  @"/api/car/brands"           //品牌
#define HOTCAR      @"/api/car/rexiaoche"        //热销车
#define SALECAR     @"/api/car/tejiache"         //特价车
#define ACTIVITYLIST @"/wap/activity/index"         //活动列表

//车系列表
#define CARPROS @"/api/car/pros"
//具体车型
#define DETAIL_CAR @"/api/car/car"
//车型图片
#define IMGS @"/api/car/images"
//车辆参数
#define PARAMSLIST @"/api/car/params"
//外观颜色
#define CHOOSE_COLOR @"/api/car/getcolors"
//车型列表
#define CARLIST @"/api/car/cars"


#define USERLOGIN @"/api/user/login"               //验证码／密码登录
//提交订单页面的注册
#define ORDER_REGIST @"/api/user/loginOrRegister"
//退出登录
#define CANCEL_LOGIN @"/api/user/logout"
//重置密码
#define RESET_PWD @"/api/user/findpass"
//用户信息
#define USER_INFORMATION @"/api/user/getUserInfo"
#define NEWSLIST @"/api/news/lists"
//获取验证码
#define GETCODE @"/api/sys/sendSMS_app"
//检查token是否有效
#define IS_USERFUL @"/api/sys/checkToken"
//获取验证码的URL
#define GETLoginYanZhengma @"/api/sys/sendSMS"


//我的活动列表
#define ACTIVITY_ORDER @"/wap/activity/myactivity"
//取消活动订单
#define CANCEL_ACTIVITY_ORDER @"/api/activity/cancel"

//**************************** 订单 *****************************
//提交订单
#define ADD_ORDER @"/api/order/add"
//订单详情
#define ORDER_DETAIL @"/api/order/detail"
//我的订单
#define MY_ORDER @"/api/order/orders"
//取消订单
#define CANCEL_ORDER @"/api/order/cancel"
//未完成订单校验
#define UNCOMPLETE_ORDER @"/api/order/checkUnfinished"

//**************************** 支付模块 *****************************
//请求服务器数据
#define GET_DATA @"/api/wxpayapp/getPrepayInfo"

#endif /* Interface_h */
