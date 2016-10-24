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
#import "DetailCarInformationCell.h"
#import "DKMyOrderVC.h"
#import "DKPayMoneyVC.h"

#import "SubmmitOrderViewModel.h"

static NSString *const headerCell = @"HeaderCellID";
@interface MFSaleDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    BOOL isShow;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *buyBtn;

@property (nonatomic, strong) SubmmitOrderViewModel *viewModel;

@end

@implementation MFSaleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNav];
    [self setUpViews];
    [self combineViewModel];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - setUpViews
- (void)setUpNav {
    [self navBack:YES];
}

- (void)setUpViews {
    [self.view addSubview:self.buyBtn];
    [self.view addSubview:self.tableView];
    
    WEAKSELF
    [self.buyBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(40);
        make.right.equalTo(-40);
        make.bottom.equalTo(-10);
        make.height.equalTo(40);
    }];
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(0);
        make.bottom.equalTo(weakSelf.buyBtn.mas_top).offset(-10);
    }];
}

- (void)combineViewModel {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.carID, @"cid", nil];
    
    //请求具体车型
    @weakify(self);
    RACSignal *carDetailSignal = [self.viewModel.carDetailCommand execute:params];
    [carDetailSignal subscribeNext:^(id x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        });
    }];
 
    
    [self.viewModel.submmitOrderCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"sale ViewModel : %@", x);
        
        @strongify(self);
        if ([x isEqualToString:@"YES"]) {       //有未完成订单
            [self payPromoutView];
        }else {     //提交订单成功
            NSString *orderIDStr = x;
            [self submitOrderSuccessWithOrderID:orderIDStr];
        }
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

-(SubmmitOrderViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SubmmitOrderViewModel alloc] initWithCarID:self.carID];
    }
    return _viewModel;
}

#pragma mark - action
- (void)buttonAction:(UIButton *)sender {
    NSLog(@"获取验证码");
    [self.view endEditing:YES];
    
    //拿到手机号的txtField
    DetailCarInformationCell *cell = (DetailCarInformationCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:1]];
    UITextField *telTxtField = cell.writeTF;
    
    //判断手机号
    if (telTxtField.text.length == 0) {
        [PromtView showAlert:@"手机号不能为空" duration:1.5];
        
    }else if (telTxtField.text.length == 11) {
        
        [sender timerStartWithText:@"获取验证码"];
        [sender http_requestForCodeWithParams:telTxtField.text];
        
    }else {
        [PromtView showAlert:@"手机号格式错误" duration:1.5];
    }
}

- (void)buyCarAction:(UIButton *)sender {
    NSLog(@"下单");
    NSLog(@"self.tableView.contentOffset.y:%f", self.tableView.contentOffset.y);
    
#warning - crash
    //此处应该获取输入框对应在self view上的Y
    if (self.tableView.contentOffset.y > 151) {
        self.tableView.contentOffset = CGPointMake(0, 35);
    }
    
    NSMutableArray *mArray = [NSMutableArray array];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    for (int i = 1; i < 4; i++) {
        DetailCarInformationCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:1]];
        NSString *text = cell.writeTF.text;
        [mArray addObject:text];
    }
    for (NSString *tfString in mArray) {
        if (tfString.length <= 0) {
            [PromtView showAlert:@"信息不完全" duration:1.5];
            return;
        }
    }
    
    dic[@"name"] = mArray[0];
    dic[@"tel"] = mArray[1];
    dic[@"code"] = mArray[2];
    dic[@"waiguan"] = @"默认";
    dic[@"neishi"] = @"默认";
    dic[@"gcfs"] = @"默认";
    dic[@"gcsj"] = @"默认";
    
    [self.viewModel.submmitOrderCommand execute:dic];
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
        cell.model = self.viewModel.carModel;
        
        return cell;
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"commonCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            cell.textLabel.text = @"下单";
            [cell.textLabel createLabelWithFontSize:13 color:TEXTCOLOR];
            
            return cell;
        }else {
            DetailCarInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"informationCell"];
            if (cell == nil) {
                cell = [[DetailCarInformationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"informationCell"];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.iconImgView.image = [UIImage imageNamed:self.viewModel.imgNameArray[indexPath.row-1]];
            cell.writeTF.placeholder = self.viewModel.chooseTitleArray[indexPath.row-1];
            
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
        
        return cell;
    }else {
        CarDetailThirdCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"CarDetailThirdCell" owner:nil options:nil] lastObject];
        cell.isShowing = isShow;
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
        
        cell.clickMoreBtn = ^{      //more

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

#pragma mark - 提交订单成功
- (void)submitOrderSuccessWithOrderID:(NSString *)orderID {
    //初始化提示框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"提交订单成功" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        DKPayMoneyVC *payMoeyVC = [[DKPayMoneyVC alloc] init];
        payMoeyVC.title = @"支付订金";
        payMoeyVC.orderIDString = orderID;
        [self.navigationController pushViewController:payMoeyVC animated:YES];
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

#pragma mark - 有未完成订单
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

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
