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
#import "OrderDetailViewModel.h"

#import "CarOrderModel.h"

@interface DKDetailOrderVC ()
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, strong) UIButton *continueBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) OrderDetailViewModel *viewModel;

@end

@implementation DKDetailOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpNav];
    [self setUpViews];
    [self bindViewModel];
    
//    [self dataRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setUp
- (void)setUpNav {
    self.title = @"订单详情";
    [self navBack:YES];
}

- (void)setUpViews {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.continueBtn];
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(0);
    }];
    [self.continueBtn makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-10);
        make.height.equalTo(Button_H);
        make.left.equalTo(40);
        make.right.equalTo(-40);
    }];
}

- (void)bindViewModel {
    RACSignal *orderDetailSignal = [self.viewModel.orderDetailCommand execute:nil];
    @weakify(self);
    [orderDetailSignal subscribeNext:^(id x) {
        NSLog(@"x:%@", x);
        
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            if ([x isKindOfClass:[CarOrderModel class]]) {
                self.myModel = x;
                if ([self.myModel.zt integerValue] == 0) {    //待付款
                    self.continueBtn.hidden = NO;
                }else {
                    self.continueBtn.hidden = YES;
                }
                [self.tableView reloadData];
            }
        });
    }];
}

#pragma mark - lazyloading
-(OrderDetailViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[OrderDetailViewModel alloc] initWithOrderID:self.orderIDString];
    }
    return _viewModel;
}

-(UIButton *)continueBtn {
    if (!_continueBtn) {
        _continueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _continueBtn.layer.cornerRadius = Button_H/2;
        [_continueBtn setTitle:@"继续完成订单" forState:UIControlStateNormal];
        _continueBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _continueBtn.backgroundColor = ITEMCOLOR;
        _continueBtn.hidden = YES;
        [_continueBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _continueBtn;
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
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
        [PromtView showAlert:@"订单已支付请提车" duration:1.5];
    }else {
        [PromtView showAlert:@"订单" duration:1.5];
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
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DetailOrderCellID"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        
        CarHeaderView *carView = [[CarHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
        carView.backgroundColor = [UIColor whiteColor];
        [carView createViewWithModel:self.myModel];
        [cell.contentView addSubview:carView];
        
    }if (indexPath.section == 1) {
        CarInformationView *carView = [[[NSBundle mainBundle] loadNibNamed:@"CarInformationView" owner:nil options:nil] lastObject];
        carView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-50-80-20);
        [carView createCellViewWithModel:self.myModel];
        
        UIButton *cancelBtn = [carView viewWithTag:2323];
        [cancelBtn addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:carView];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? CGFLOAT_MIN : 12;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = kScreenHeight -64-12-80;
    return indexPath.section == 0 ? 80 : rowHeight;
}

#pragma mark - http_request
//取消订单
- (void)cancelOrderRequest {
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
