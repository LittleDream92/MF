//
//  MFSaleDetailViewController.m
//  Qichegou
//
//  Created by Meng Fan on 16/9/27.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "MFSaleDetailViewController.h"
#import "SaleDetalHeaderTableViewCell.h"
#import "CarDetailThirdCell.h"
#import "CarDetailFourCell.h"
#import "BuyCarNeedsTVC.h"
#import "CarModel.h"
#import "SubmmitViewModel.h"
#import "DKMyOrderVC.h"
#import "DKPayMoneyVC.h"
#import "UserModel.h"
#import "AppDelegate.h"


#import "SaleCarSubmmitViewModel.h"

static NSString *const headerCell = @"HeaderCellID";
@interface MFSaleDetailViewController ()<UITextFieldDelegate , UITableViewDelegate, UITableViewDataSource>
{
    NSArray *_celltitleArray;
    BOOL isShow;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *accountTextField;
@property (nonatomic, strong) UITextField *codeTextField;
@property (nonatomic, strong) UIButton *buyBtn;


@property (nonatomic, strong) NSArray *imgNameArray;
@property (nonatomic, strong) CarModel *detailModel;


@property (nonatomic, strong) SaleCarSubmmitViewModel *viewModel;

@end

@implementation MFSaleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpData];
    
    [self setUpNav];
    [self setUpViews];
    [self autoLayout];
    [self combineViewModel];

    //监听键盘隐藏
    [[NSNotificationCenter defaultCenter]addObserver:self
                                                   selector:@selector(keybaordhide:)
                                                       name:UIKeyboardWillHideNotification object:nil];
    
    //设置点击手势，当点击空白处，结束编辑，收回键盘
    UITapGestureRecognizer *tapp=[[UITapGestureRecognizer alloc]
                                         initWithTarget:self action:@selector(tapAction:)];
    self.view.userInteractionEnabled=YES;
    [self.view addGestureRecognizer:tapp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpData {
    _celltitleArray = @[@"", @"请输入真实姓名", @"请输入11位手机号", @"请输入验证码"];
    self.imgNameArray = @[@"", @"sale_my", @"sale_tel", @"sale_code"];
}

#pragma mark - setUpViews
- (void)setUpNav {
    [self navBack:YES];
}

- (void)setUpViews {
    
    [self.view addSubview:self.buyBtn];
    [self.view addSubview:self.tableView];
}

- (void)autoLayout {
    WEAKSELF
    
    [self.buyBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(40);
        make.right.equalTo(-40);
        make.bottom.equalTo(-15);
        make.height.equalTo(40);
//        make.left.equalTo(15);
//        make.right.equalTo(-15);
//        make.bottom.equalTo(-15);
//        make.height.equalTo(40);
    }];
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(0);
        make.bottom.equalTo(weakSelf.buyBtn.mas_top).offset(-20);
    }];
}

- (void)combineViewModel {
    //请求特价车型数据
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.carID, @"cid", nil];
    RACSignal *signal = [self.viewModel.saleCarDetailCommand execute:params];
    [signal subscribeNext:^(CarModel *carModel) {
        self.detailModel = carModel;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - lazyloading
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.sectionHeaderHeight = CGFLOAT_MIN;
        _tableView.sectionFooterHeight = 10;
        
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.contentInset = UIEdgeInsetsMake(-35, 0, -50, 0);
    }
    return _tableView;
}

-(UIButton *)buyBtn {
    if (!_buyBtn) {
        _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buyBtn setTitle:@"立即下单" forState:UIControlStateNormal];
        _buyBtn.backgroundColor = kskyBlueColor;
        _buyBtn.titleLabel.font = H15;
        
        _buyBtn.layer.cornerRadius = 20;
        
        [_buyBtn addTarget:self action:@selector(buyCarAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyBtn;
}

-(SaleCarSubmmitViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SaleCarSubmmitViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark - action
//点击手势方法
-(void)tapAction:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

//当键盘隐藏时候，视图回到原定
-(void)keybaordhide:(NSNotification *)sender {
    
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
    }];
}


- (void)buttonAction:(UIButton *)sender {
    NSLog(@"获取验证码");
    [self.view endEditing:YES];
    
    //拿到手机号的txtField
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:1]];
    UITextField *telTxtField = [cell viewWithTag:7000];
    
    //判断手机号
    if (telTxtField.text.length == 0) {
        
        NSLog(@"手机号不能为空");
        [PromtView showAlert:@"手机号不能为空" duration:1.5];
        
    }else if (telTxtField.text.length == 11) {
        
        [sender timerStartWithText:@"获取验证码"];
        [sender http_requestForCodeWithParams:telTxtField.text];
        
    }else {
        
        NSLog(@"手机号码错误");
        [PromtView showAlert:@"手机号格式错误" duration:1.5];
    }
}

- (void)buyCarAction:(UIButton *)sender {
    NSLog(@"下单");
    
    [self textFieldStringIsNull];
}


#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 1) ? 4 : 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        SaleDetalHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:headerCell];
        
        if (cell == nil) {
            cell = [[SaleDetalHeaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headerCell];
        }
        
        cell.model = self.detailModel;
        
        return cell;
        
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"commonCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.textLabel.text = @"下单";
            [cell.textLabel createLabelWithFontSize:13 color:TEXTCOLOR];
            
            return cell;
        }else {
            BuyCarNeedsTVC *cell = [[[NSBundle mainBundle] loadNibNamed:@"BuyCarNeedsTVC" owner:nil options:nil] lastObject];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.iconImgView.image = [UIImage imageNamed:self.imgNameArray[indexPath.row]];
            
            cell.writeTF.delegate = self;
            cell.writeTF.font = H13;
            cell.writeTF.placeholder = _celltitleArray[indexPath.row];
            
            if (indexPath.row != 3) {
                cell.lineView.hidden = YES;
                cell.getCodeBtn.hidden = YES;
            }
            
            [cell.getCodeBtn setTitleColor:kskyBlueColor forState:UIControlStateNormal];
            [cell.getCodeBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }
    }else if(indexPath.section == 3) {
        CarDetailFourCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"CarDetailFourCell" owner:nil options:nil] lastObject];
        
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        return cell;
    }else {
        CarDetailThirdCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"CarDetailThirdCell" owner:nil options:nil] lastObject];
//        cell.isShowing = isShow;
        if (isShow) {
            cell.thirdLabel.hidden = NO;
            cell.thirdDetailLabel.hidden = NO;
            cell.fourLabel.hidden = NO;
            cell.fourDetailLabel.hidden = NO;
            cell.fiveLabel.hidden = NO;
            cell.fiveDetailLabel.hidden = NO;
            [cell.moreBtn setTitle:@"收起" forState:UIControlStateNormal];
        }else {
            cell.thirdLabel.hidden = YES;
            cell.thirdDetailLabel.hidden = YES;
            cell.fourLabel.hidden = YES;
            cell.fourDetailLabel.hidden = YES;
            cell.fiveLabel.hidden = YES;
            cell.fiveDetailLabel.hidden = YES;
            [cell.moreBtn setTitle:@"更多" forState:UIControlStateNormal];
        }
        
        cell.clickMoreBtn = ^{
            NSLog(@"more");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                isShow = !isShow;
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
            });
        };
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 225;
    }else if (indexPath.section == 2) {
        if (isShow) {
            return 400;
        }else {
            return 245;
        }
   }else if (indexPath.section == 3) {
        return 140;
    }
    return 44;
}

#pragma mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(-35*3);
    }];
}


#pragma mark - requestData
//判断要注册的信息是否为空
- (void)textFieldStringIsNull {
    NSMutableArray *mArray = [NSMutableArray array];
    
    for (int i = 1; i < 4; i++) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:1]];
        UITextField *mytf = [cell viewWithTag:7000];
        [mArray addObject:mytf.text];
    }
    
    for (NSString *tfString in mArray) {
        if (tfString.length <= 0) {
            [PromtView showAlert:@"信息不完全" duration:2];
            return;
        }
    }
    
    //注册
    [SubmmitViewModel registAndLoginWithtel:mArray[1] name:mArray[0] code:mArray[2] Block:^(NSString *token) {
        NSLog(@"token:%@", token);
        [SubmmitViewModel ifHaveUmCompleteOrderWithBlock:^(BOOL have) {
            if (have) {
                [self payPromoutView];
            }else {
                //提交订单
                NSLog(@"提交订单");
                //提交订单的网络请求
                [self submit_requestWithToken:token];
            }
        }];
    }];
}


- (void)submit_requestWithToken:(NSString *)tokenString {   //提交订单
    
    NSString *randomString = [BaseFunction ret32bitString];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", [BaseFunction getTimeSp]];
    NSString *md5String = [[BaseFunction md5Digest:[NSString stringWithFormat:@"%@%@%@", timeSp, randomString, APPSIGN]] uppercaseString];
    /*_keyArray = @[@"WaiGuan", @"Neishi", @"Way", @"Time"];*/
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"6",@"cityid",
                            
                            self.carID,@"cid",
                            
                            @"", @"color",
                            
                            @"", @"neishi",
                            
                            @"", @"gcsj",
                            
                            @"", @"gcfs",
                            
                            tokenString, @"token",
                            
                            md5String,@"sign",
                            
                            timeSp,@"time",
                            
                            randomString,@"nonce_str",nil];
    
    [DataService http_Post:ADD_ORDER
                parameters:params
                   success:^(id responseObject) {
                       //
                       NSLog(@"submmit order:%@", responseObject);
                       
                       if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
                           //获取订单号
                           NSString *orderID = [responseObject objectForKey:@"oid"];
                           NSString *orderIDStr = orderID;
                           [self submitOrderSuccessWithOrderID:orderIDStr];
                       }else {
                           
                           NSLog(@"%@",[responseObject objectForKey:@"msg"]);
                           [PromtView showAlert:[responseObject objectForKey:@"msg"] duration:1.5];
                       }
                       
                   } failure:^( NSError *error) {
                       NSLog(@"submmit order error:%@", error);
                       [PromtView showAlert:PromptWord duration:1.5];
                   }];
    
}

#pragma mark -提交订单成功
- (void)submitOrderSuccessWithOrderID:(NSString *)orderID {
    //初始化提示框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"提交订单成功" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        [self pushToPaymoneyVCWithOrderID:orderID];
        
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
    
}

//push到支付订金页面
- (void)pushToPaymoneyVCWithOrderID:(NSString *)orderID {
    DKPayMoneyVC *payMoeyVC = [[DKPayMoneyVC alloc] init];
    
    payMoeyVC.title = @"支付订金";
    payMoeyVC.orderIDString = orderID;
    
    [self.navigationController pushViewController:payMoeyVC animated:YES];
}



#pragma mark -有未完成订单
- (void)payPromoutView {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"您有未付款订单，请先付款" preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"取消");
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"确定支付未完成订单");
        
        DKMyOrderVC *myOrderVC = [[DKMyOrderVC alloc] init];
        [self.navigationController pushViewController:myOrderVC animated:YES];
        
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
