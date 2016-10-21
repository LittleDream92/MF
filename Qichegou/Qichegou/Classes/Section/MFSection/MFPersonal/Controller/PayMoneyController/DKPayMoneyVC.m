//
//  DKPayMoneyVC.m
//  DKQiCheGou
//
//  Created by Song Gao on 16/1/18.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DKPayMoneyVC.h"
#import "UIViewController+WeChatAndAliPayMethod.h"
#import "PayOrderCell.h"
#import "DKDetailOrderVC.h"
#import "AppDelegate.h"
#import "WXApi.h"
#import "PaymoneyTopView.h"
#import "PayMoneyFooterView.h"
#import "CarOrderModel.h"

@interface DKPayMoneyVC ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *titleArr;
    NSArray *imgNameArr;
    
    NSInteger payWay;
}

@property (nonatomic, strong) UITableView *payOrderTV;
@property (nonatomic, strong) PaymoneyTopView *headerView;
@property (nonatomic, strong) PayMoneyFooterView *footerView;

@property (nonatomic, strong) UIButton *submitBtn;

@end

@implementation DKPayMoneyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBack:YES];
    
    titleArr = @[@"支付宝",@"微信"];
    imgNameArr = @[@"apliy_icon",@"wechat_icon"];
    
    [self createViews];
    
    [self showHUD:@"正在加载"];
    [self data_Request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - layloading
- (UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitBtn setTitle:@"立即支付定金" forState:UIControlStateNormal];
        _submitBtn.backgroundColor = ITEMCOLOR;
        _submitBtn.layer.cornerRadius = 20;
        [_submitBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

-(UITableView *)payOrderTV {
    if (_payOrderTV == nil) {
        //初始化表视图
        _payOrderTV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _payOrderTV.delegate = self;
        _payOrderTV.dataSource = self;
        
        _payOrderTV.showsVerticalScrollIndicator = NO;
        _payOrderTV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _payOrderTV.scrollEnabled = NO;
    }
    return _payOrderTV;
}

#pragma mark - createViews
- (void)createViews {
    
    WEAKSELF
    [self.view addSubview:self.submitBtn];
    [self.submitBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(40);
        make.right.equalTo(-40);
        make.height.equalTo(40);
        make.bottom.equalTo(-10);
    }];
    
    [self.view addSubview:self.payOrderTV];
    [self.payOrderTV makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(0);
        make.bottom.equalTo(weakSelf.submitBtn.mas_top);
    }];
    
    //初始化头视图
    self.headerView = [[[NSBundle mainBundle] loadNibNamed:@"PaymoneyTopView" owner:self options:nil] lastObject];
    self.headerView.frame = CGRectMake(0, 0, kScreenWidth, 260);    //302*kHeightSale
//    self.headerView.height = 260;
    self.payOrderTV.tableHeaderView = self.headerView;
    
    //初始化尾视图
//    CGFloat footerViewH = kScreenHeight - 64 - self.headerView.height - 12*kHeightSale - 44*kHeightSale - 50*2;
    CGFloat footerViewH = kScreenHeight - 64 - 260 - 12*kHeightSale - 44*kHeightSale - 50*2;
    
    self.footerView = [[[NSBundle mainBundle] loadNibNamed:@"PayMoneyFooterView" owner:self options:nil] lastObject];
    self.footerView.frame = CGRectMake(0, 0, kScreenWidth, footerViewH);
    self.payOrderTV.tableFooterView = self.footerView;
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *identifier = @"OrderDetailCellID";
        UITableViewCell *orderCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        orderCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        [orderCell.textLabel createLabelWithFontSize:14 color:TEXTCOLOR];
        orderCell.textLabel.text = @"支付方式";
    
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 44*kHeightSale-1, kScreenWidth - 30, 1)];
        lineView.backgroundColor = kplayceGrayColor;
        [orderCell.contentView addSubview:lineView];
        
        return orderCell;
    }else {
        PayOrderCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"PayOrderCell" owner:nil options:nil] lastObject];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.icon_View.image = [UIImage imageNamed:imgNameArr[indexPath.row - 1]];
        cell.payLabel.text = titleArr[indexPath.row - 1];
        
        return cell;
    }
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12*kHeightSale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 0 ? 44*kHeightSale : 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        payWay = 1;
        
        //拿到button，设置背景
        PayOrderCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        UIButton *btn = [selectedCell viewWithTag:110];
        [btn setImage:[UIImage imageNamed:@"icon_check"] forState:UIControlStateNormal];
        
        //设置另外一个没有对号
        PayOrderCell *otherCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        UIButton *otherBtn = [otherCell viewWithTag:110];
        [otherBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
    }else if (indexPath.row == 2) {
        payWay = 2;
        
        //拿到button，设置背景
        PayOrderCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        UIButton *btn = [selectedCell viewWithTag:110];
        [btn setImage:[UIImage imageNamed:@"icon_check"] forState:UIControlStateNormal];
        
        //设置另外一个没有对号
        PayOrderCell *otherCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        UIButton *otherBtn = [otherCell viewWithTag:110];
        [otherBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
}



#pragma mark - http_request
- (void)data_Request {
    //获取token值
    NSString *tokenStr = [AppDelegate APP].user.token;
    
    NSString *randomString = [BaseFunction ret32bitString];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", [BaseFunction getTimeSp]];
    NSString *md5String = [[BaseFunction md5Digest:[NSString stringWithFormat:@"%@%@%@", timeSp, randomString, APPSIGN]] uppercaseString];

    NSLog(@"oid:%@", self.orderIDString);
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.orderIDString,@"oid",
                            tokenStr,@"token",
                            md5String,@"sign",
                            timeSp,@"time",
                            randomString,@"nonce_str",nil];
    
    //订单详情请求
    [DataService http_Post:ORDER_DETAIL parameters:params success:^(id responseObject) {
        if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
            NSLog(@"order detail result : %@", responseObject);
            //处理数据，封装 model
            if ([responseObject objectForKey:@"data"] != NULL) {
                NSDictionary *jsonDic = [responseObject objectForKey:@"data"];
                
                NSLog(@"%@", jsonDic);
                
                self.myModel = [[CarOrderModel alloc] initContentWithDic:jsonDic];
                if (!self.myModel.color.length) {
                    self.myModel.color = @"默认";
                }
                if (!self.myModel.neishi.length) {
                    self.myModel.neishi = @"默认";
                }
                if (!self.myModel.gcfs.length) {
                    self.myModel.gcfs = @"默认";
                }
                if (!self.myModel.gcsj.length) {
                    self.myModel.gcsj = @"默认";
                }
                
                
                [self.headerView createTopViewWithChooseCarModel:self.myModel];
                [self.submitBtn setTitle:[NSString stringWithFormat:@"立即支付%@订金", self.myModel.ding_jin] forState:UIControlStateNormal];
                
                [self completeHUD:@"加载完成"];
                
            }else {
                NSLog(@"返回数据出错！");
                [self completeHUD:@"加载出错"];
            }
        }else {
            NSString *hudStr = [responseObject objectForKey:@"msg"];
            [self completeHUD:hudStr];
        }
    } failure:^(NSError *error) {
        NSLog(@"error:%@", error);
        [self completeHUD:PromptWord];
    }];
}

- (void)getData {
    /*
     返回JSON对象：
     {
         appid：		APPID
         partnerid：	商户ID
         noncestr：  随机数
         timestamp： unix时间戳
         package:	值固定为"Sign=WXPay"
         prepayid：	预支付编号prepay_id
         sign:		签名
     }
     */
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.orderIDString,@"oid",
                            @"1",@"orderType", nil];
    
    [DataService http_Post:GET_DATA
     
                parameters:params
     
                   success:^(id responseObject) {
                       //
                       NSLog(@"success:%@", responseObject);
                       
                       [self payTheMoneyUseWeChatPayWithPrepay_id:[responseObject objectForKey:@"prepayid"]
                        
                                                        partnerID:[responseObject objectForKey:@"partnerid"]
                        
                                                        nonce_str:[responseObject objectForKey:@"noncestr"]
                        
                                                        timeStamp:[responseObject objectForKey:@"timestamp"]
                        
                                                          package:[responseObject objectForKey:@"package"]
                        
                                                             sign:[responseObject objectForKey:@"sign"]];

                       
                   } failure:^(NSError *error) {
                       //
                       NSLog(@"error:%@", error);
                       //请求网络失败
                       [PromtView showAlert:@"微信支付失败" duration:1.5f];

                   }];
}

#pragma mark - buttonAction
- (void)buttonAction:(UIButton *)button {
    
    NSLog(@"支付:%ld", (long)payWay);
    
    if (payWay == 0) {
        
        [self presentAlertViewWithString:@"请选择一种支付方式"];
        NSLog(@"请选择一种支付方式");
        
    }else if (payWay == 1) {
        NSLog(@"支付宝支付");
        [self payMoneyWithAlipay];
        
    }else if (payWay == 2) {
        NSLog(@"微信支付");
        [self payWithWechatPay];
    }
    
}

#pragma mark - Alipay methods
/*支付宝支付*/
- (void)payMoneyWithAlipay {
    //这里调用我自己写的catagoary中的方法，方法里集成了支付宝支付的步骤，并会发送一个通知，用来传递是否支付成功的信息
    [self payTHeMoneyUseAliPayWithOrderId:self.orderIDString
                               totalMoney:self.myModel.ding_jin
                                 payTitle:self.myModel.car_subject];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AliPayResultNoti:) name:ALI_PAY_RESULT object:nil];
    
}

//支付宝支付成功失败
-(void)AliPayResultNoti:(NSNotification *)noti {
    NSLog(@"%@",noti);
    if ([[noti object] isEqualToString:ALIPAY_SUCCESSED]) {
        [PromtView showAlert:@"支付成功" duration:1.5f];
        //在这里填写支付成功之后你要做的事情
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }else{
        [PromtView showAlert:@"支付宝支付失败" duration:1.5f];
    }
    //上边添加了监听，这里记得移除
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ALI_PAY_RESULT object:nil];
}

#pragma mark - WechatPay methods
- (void)payWithWechatPay {
    //判断用户是否安装微信
    if ([WXApi isWXAppInstalled]) {
        //安装
        NSLog(@"正在微信支付");
        
        //获取prepay_id和随机字符串
        [self getData];
        
        //所以这里添加一个监听，用来接收是否成功的消息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weChatPayResultNoti:) name:WX_PAY_RESULT object:nil];
        
    }else {
        //没安装
        [PromtView showAlert:@"您没有安装微信" duration:1.5f];
    }

}

//微信支付付款成功失败
-(void)weChatPayResultNoti:(NSNotification *)noti {
    NSLog(@"%@",noti);
    if ([[noti object] isEqualToString:IS_SUCCESSED]) {
        [PromtView showAlert:@"微信支付成功" duration:1.5f];
        //在这里填写支付成功之后你要做的事情
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }else{
        [PromtView showAlert:@"微信支付失败" duration:1.5f];
    }
    //上边添加了监听，这里记得移除
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WX_PAY_RESULT object:nil];
}


@end
