//
//  InsuranceModel.h
//  Qichegou
//
//  Created by Meng Fan on 16/6/21.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "BaseModel.h"

@interface InsuranceModel : BaseModel

/* ID */
@property (nonatomic, copy) NSString *insID;
/* 保险公司名称 */
@property (nonatomic, copy) NSString *name;
/* 保险公司LOGO图片链接 */
@property (nonatomic, copy) NSString *logo;


/*
 chechuan2 = "1000.00";
 chengke2 = "1000.00";
 "chengke_baoe" = 5000;
 "chengke_buji2" = "1000.00";
 "chesun_baoe" = 100000;
 "chesun_boli2" = "1000.00";
 "chesun_buji2" = "1000.00";
 "chesun_huahen2" = "<null>";
 "chesun_sanfang2" = "<null>";
 "chesun_sheshui2" = "<null>";
 "chesun_zhuanxiu2" = "1000.00";
 "chesun_ziran2" = "<null>";

 daoqiang2 = "1000.00";
 "daoqiang_buji2" = "100.00";

 jiaoqiang2 = "1000.00";
 sanzhe2 = "1000.00";
 "sanzhe_baoe" = 50000;
 "sanzhe_buji2" = "1000.00";
 siji2 = "1000.00";
 "siji_baoe" = 5000;
 "siji_buji2" = "1000.00";
 "total_money2" = "10000.00";

 */


/* 车辆信息 */
@property (nonatomic, copy) NSString *car;

/* 车架号 */
@property (nonatomic, copy) NSString *chejia;

/* 发动机号 */
@property (nonatomic, copy) NSString *fadongji;

/* 登记日期 */
@property (nonatomic, copy) NSString *dengji;

/* 车主姓名 */
@property (nonatomic, copy) NSString *user_name;
/* 手机 */
@property (nonatomic, copy) NSString *user_phone;
/* 证件类型 */
@property (nonatomic, copy) NSString *zheng_jian_type;
/* 证件号码 */
@property (nonatomic, copy) NSString *zheng_jian;


/* 交强险 jiaoqiang = "1000.00 */
@property (nonatomic, copy) NSString *jiaoqiang;

/* 交强险保单号  */
@property (nonatomic, copy) NSString *jiaoqiang_NO;
/* 交强险生效日期  */
@property (nonatomic, copy) NSString *jiaoqiang_date;
/* 商业险保单号  */
@property (nonatomic, copy) NSString *business_NO;
/* 商业险生效日期  */
@property (nonatomic, copy) NSString *business_date;


/* 车船税 chechuan = "1000.00"*/
@property (nonatomic, copy) NSString *chechuan;


/* 乘客座位责任险保费 chengke = "1000.00" */
@property (nonatomic, copy) NSString *chengke;
/* 乘客座位责任险保额 "chengke_baoe" = 5000; */
@property (nonatomic, copy) NSString *chengke_baoe;

/* 第三者责任险保费 sanzhe = "1000.00" */
@property (nonatomic, copy) NSString *sanzhe;
/* 第三者责任险保额 "sanzhe_baoe" = 50000; */
@property (nonatomic, copy) NSString *sanzhe_baoe;

/* 司机座位责任险保费 siji = "1000.00"; */
@property (nonatomic, copy) NSString *siji;
/* 司机座位责任险保额 "siji_baoe" = 5000; */
@property (nonatomic, copy) NSString *siji_baoe;

/* 车损险保费 chesun */
@property (nonatomic, copy) NSString *chesun;
/* 车损险保额 "chesun_baoe" = 100000; */
@property (nonatomic, copy) NSString *chesun_baoe;



/* 不计免赔（司机）保费 "siji_buji" = "1000.00"; */
@property (nonatomic, copy) NSString *siji_buji;
/* 不计免赔（乘客）保费 "chengke_buji" = "1000.00" */
@property (nonatomic, copy) NSString *chengke_buji;
/* 车损之玻璃破损险保费 "chesun_boli" = "1000.00" */
@property (nonatomic, copy) NSString *chesun_boli;
/* 不计免赔（车损）保费 "chesun_buji" = "1000.00"; */
@property (nonatomic, copy) NSString *chesun_buji;
/* 车损之车身划痕险保费 "chesun_huahen" = "<null>" */
@property (nonatomic, copy) NSString *chesun_huahen;
/* 车损之无法找到第三方特约险保费 "chesun_sanfang" = "<null>" */
@property (nonatomic, copy) NSString *chesun_sanfang;
/* 车损之发动机涉水险保费 "chesun_sheshui" = "<null>" */
@property (nonatomic, copy) NSString *chesun_sheshui;
/* 车损之4S店专修险保费 chesun_zhuanxiu" = "1000.00 */
@property (nonatomic, copy) NSString *chesun_zhuanxiu;
/* 车损之车身自燃险保费 chesun_ziran" = "<null> */
@property (nonatomic, copy) NSString *chesun_ziran;
/* 全车盗抢险保费 daoqiang = "1000.00" */
@property (nonatomic, copy) NSString *daoqiang;
/* 不计免赔（盗抢）保费 daoqiang_buji" = "100.00 */
@property (nonatomic, copy) NSString *daoqiang_buji;
/* 不计免赔（三者）保费 "sanzhe_buji" = "1000.00"; */
@property (nonatomic, copy) NSString *sanzhe_buji;
/* 新车重置险保费 */
@property (nonatomic, copy) NSString *xinche_chongzhi;



/* 乘客座位数 "chengke_zuowei" = 4 */
@property (nonatomic, copy) NSString *chengke_zuowei;
/* '1、国产玻璃   2、进口玻璃', "chesun_boli_type" = "\U56fd\U4ea7" */
@property (nonatomic, copy) NSString *chesun_boli_type;
/* 购买年数  years = 3; */
@property (nonatomic, assign) NSInteger *years;

/* 保费总额 */
@property (nonatomic, copy) NSString *total_money;




/* 保险公司 */
@property (nonatomic, copy) NSString *com_name;
/* 保险公司LOGO */
@property (nonatomic, copy) NSString *com_logo;
/* 电话 */
@property (nonatomic, copy) NSString *com_phone;
/* 条款链接 */
@property (nonatomic, copy) NSString *tiaokuan_url;

@end

