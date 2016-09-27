//
//  DKDetailOrderVC.m
//  Qichegou
//
//  Created by Song Gao on 16/1/27.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DKDetailOrderVC.h"
#import "CarInformationView.h"
#import "DKPayMoneyVC.h"
#import "CarHeaderView.h"
#import "AppDelegate.h"

@interface DKDetailOrderVC ()

@end

@implementation DKDetailOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"订单详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createViews];
    
//    [self showHUD:@"正在加载"];
    
    [self dataRequest];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - createViews
- (void)createViews
{
    //初始化表视图
    [self createTableView];
    
    //初始化继续完成按钮
    continueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    continueBtn.frame = CGRectMake(0, self.detailOrderTV.bottom, kScreenWidth, 50);
    [continueBtn createButtonWithBGImgName:@"btn_big_continue"
                        bghighlightImgName:@"btn_big_continue.2"
                                  titleStr:@"继续完成订单"
                                  fontSize:16];
    [continueBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:continueBtn];
}

- (void)createTableView
{
    self.detailOrderTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 50) style:UITableViewStyleGrouped];
    
    self.detailOrderTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.detailOrderTV.dataSource = self;
    self.detailOrderTV.delegate = self;
    
    [self.view addSubview:self.detailOrderTV];

}

#pragma mark - buttonAction
- (void)buttonClickAction:(UIButton *)btn {
    if ([btn.titleLabel.text isEqualToString:@"申请退款"]) {
        [self presentAlertViewWithString:@"请联系客服退款：400-169-0399"];
    }else if ([btn.titleLabel.text isEqualToString:@"取消订单"]) {
        [self cancelOrder];
        
    }
    
}

//弹出确定取消订单
- (void)cancelOrder {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"确定取消订单" preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"取消");
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"确定取消");
        [self cancelOrderRequest];
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)buttonAction:(UIButton *)button {
    NSLog(@"继续完成订单");
    
    //判断是为支付去支付
    if ([self.myModel.zt integerValue] == 0) {
        //未支付
        DKPayMoneyVC *payMoeyVC = [[DKPayMoneyVC alloc] init];
        payMoeyVC.title = @"支付订金";
        payMoeyVC.orderIDString = self.myModel.order_id;
        [self.navigationController pushViewController:payMoeyVC animated:YES];

    }else if ([self.myModel.zt integerValue] == 2) {
        
        //已支付
        //判断是否已经提车
        [PromtView showAlert:@"订单已支付请提车" duration:2];
    }else {
        [PromtView showAlert:@"订单" duration:2];
    }
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *detailOrderCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DetailOrderCellID"];
    detailOrderCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        //
        CarHeaderView *carView = [[CarHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
        carView.backgroundColor = [UIColor whiteColor];
        [carView createViewWithModel:self.myModel];
        [detailOrderCell.contentView addSubview:carView];
        
    }if (indexPath.section == 1) {
        CarInformationView *carView = [[[NSBundle mainBundle] loadNibNamed:@"CarInformationView" owner:nil options:nil] lastObject];
        [carView createCellViewWithModel:self.myModel];
        
        UIButton *cancelBtn = [carView viewWithTag:2323];
        [cancelBtn addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [detailOrderCell.contentView addSubview:carView];
    }
    
    return detailOrderCell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? CGFLOAT_MIN : 12;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = kScreenHeight - 64 - 50 - 12-80;
    return indexPath.section == 0 ? 80 : rowHeight;
}

#pragma mark - http_request
//订单详情
- (void)dataRequest
{
    //订单详情
    /*
     返回JSON对象：
     {
         status:	状态
         msg:		消息
         data:[
             {
                 order_id:		订单ID
                 create_time:	下单时间
                 ding_jin:		订金
                 guide_price:	指导价
                 brand_name:	品牌
                 pro_subject: 	车系名称
                 main_photo:	车系图片
                 car_subject:	车型名称
                 color: 		外观颜色
                 neishi: 		内饰颜色
                 gcsj:			购车时间
                 gcfs:			购车方式
                 zt:			订单状态	0待付款，1已取消，2已支付，3已退款
                 rebate_zt int： 返现状态
             }
         ]
     }
     */
    //获取token值
    NSString *tokenStr = [AppDelegate APP].user.token;
    NSString *randomString = [BaseFunction ret32bitString];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", [BaseFunction getTimeSp]];
    NSString *md5String = [[BaseFunction md5Digest:[NSString stringWithFormat:@"%@%@%@", timeSp, randomString, APPSIGN]] uppercaseString];
    
//    NSLog(@"oid:%@", self.orderIDString);
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.orderIDString,@"oid",
                            
                            tokenStr,@"token",
                            
                            md5String,@"sign",
                            
                            timeSp,@"time",
                            
                            randomString,@"nonce_str",nil];
    
    //订单详情请求
    [DataService http_Post:ORDER_DETAIL
     
                parameters:params
     
                   success:^(id responseObject) {
                       //
                       if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
                           NSLog(@"success%@", responseObject);

                           //处理数据，封装 model
                           if ([responseObject objectForKey:@"data"] != NULL) {
                               NSDictionary *jsonDic = [responseObject objectForKey:@"data"];
                               
                               self.myModel = [[ChooseCarModel alloc] initContentWithDic:jsonDic];
                               
                               //刷新表视图
                               [self.detailOrderTV reloadData];
                               [self completeHUD:@"加载完成"];
                               
                               NSInteger index = [self.myModel.zt integerValue];
                               if (index == 1 || index == 3 || index == 4) {
                                   continueBtn.hidden = YES;
                               }
                               
                           }else {
                               NSLog(@"返回数据出错！");
                               [self completeHUD:@"加载出错"];
                           }
                           
                       }else {
                           NSLog(@"failt:%@", [responseObject objectForKey:@"msg"]);
                           NSString *hudStr = [responseObject objectForKey:@"msg"];
                           [self completeHUD:hudStr];
                       }
                       
                   } failure:^(NSError *error) {
                       //
                       NSLog(@"error:%@", error);
                       [self completeHUD:@"加载失败"];
                   }];
}

//取消订单
- (void)cancelOrderRequest
{

    //获取token值
    NSString *tokenStr = [AppDelegate APP].user.token;
    NSString *randomString = [BaseFunction ret32bitString];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", [BaseFunction getTimeSp]];
    NSString *md5String = [[BaseFunction md5Digest:[NSString stringWithFormat:@"%@%@%@", timeSp, randomString, APPSIGN]] uppercaseString];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.orderIDString,@"oid",
                            
                            tokenStr,@"token",
                            
                            md5String,@"sign",
                            
                            timeSp,@"time",
                            
                            randomString,@"nonce_str",nil];
    
    [DataService http_Post:CANCEL_ORDER
     
                parameters:params
     
                   success:^(id responseObject) {

                       NSLog(@"resposeObject:%@", responseObject);
                       
                       [PromtView showAlert:@"订单已取消" duration:1.5];
                       //关闭页面
                       [self.navigationController popViewControllerAnimated:YES];
                       
                   } failure:^(NSError *error) {
    
                       NSLog(@"cancer order error:%@", error);
                       [PromtView showAlert:PromptWord duration:1.5];
                   }];
}

@end