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
#define PROTOCOL_QICHEGOU   @"http://www.qichegou.com/Wap/help/detail/catid/87"
//iTunes
#define QCGURL              @"https://itunes.apple.com/cn/app/qi-che-gou/id1080573042?mt=8"


#define CITY_LIST       @"/api/sys/citys"               //城市列表

#define BRABD_LIST      @"/api/car/brands"              //品牌
#define CAR_TYPE        @"/api/car/models"              //车辆类型（SUV ， ID）
#define HOTCAR          @"/api/car/rexiaoche"           //热销车
#define SALECAR         @"/api/car/tejiache"            //特价车
#define ACTIVITYLIST    @"/wap/activity/index"          //活动列表
#define CARPROS         @"/api/car/pros"                //车系列表
#define DETAIL_CAR      @"/api/car/car"                 //具体车型
#define IMGS            @"/api/car/images"              //车型图片
#define PARAMSLIST      @"/api/car/params"              //车辆参数
#define CHOOSE_COLOR    @"/api/car/getcolors"           //外观颜色
#define CARLIST         @"/api/car/cars"                //车型列表


#define USERLOGIN       @"/api/user/login"               //验证码／密码登录
#define REGIST          @"/api/user/register"            //注册
#define ORDER_REGIST    @"/api/user/loginOrRegister"     //提交订单页面的注册
#define CANCEL_LOGIN    @"/api/user/logout"              //退出登录
#define RESET_PWD       @"/api/user/findpass"            //重置密码
#define USER_INFORMATION @"/api/user/getUserInfo"       //用户信息
#define NEWSLIST        @"/api/news/lists"              //新闻
#define GETCODE         @"/api/sys/sendSMS_app"         //获取验证码
#define IS_USERFUL      @"/api/sys/checkToken"          //检查token是否有效
#define GETLoginYanZhengma @"/api/sys/sendSMS"          //获取验证码



#define ACTIVITY_ORDER  @"/wap/activity/myactivity"     //我的活动列表
#define CANCEL_ACTIVITY_ORDER @"/api/activity/cancel"   //取消活动订单

#define kBaoXian        @"/api/insure/coms"             //车险

//**************************** 订单 *****************************
#define ADD_ORDER       @"/api/order/add"       //提交订单
#define ORDER_DETAIL    @"/api/order/detail"    //订单详情
#define MY_ORDER        @"/api/order/orders"    //我的订单
#define CANCEL_ORDER    @"/api/order/cancel"    //取消订单
#define UNCOMPLETE_ORDER @"/api/order/checkUnfinished"  //未完成订单校验

//**************************** 支付模块 *****************************
#define GET_DATA    @"/api/wxpayapp/getPrepayInfo"     //请求服务器数据

#endif /* Interface_h */
