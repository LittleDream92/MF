//
//  MFCarDetailViewController.m
//  Qichegou
//
//  Created by Meng Fan on 16/10/17.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "MFCarDetailViewController.h"
#import "CarDetailViewModel.h"

#import "DetailChooseCarHeader.h"

#import "DetailCarInformationCell.h"
#import "ChooseCarCommonCell.h"

#import "DKNeedsTableViewController.h"
#import "DKPayMoneyVC.h"
#import "DKMyOrderVC.h"
#import "AppDelegate.h"

static NSString *const informationCell = @"informationcellID";
static NSString *const commonCell = @"CommonCellID";
@interface MFCarDetailViewController ()
<UITableViewDelegate,
UITableViewDataSource>
//控件
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *submmitButton;

@property (nonatomic, strong) DetailChooseCarHeader *headerView;

//viewModel
@property (nonatomic, strong) CarDetailViewModel *viewModel;

@end

@implementation MFCarDetailViewController

-(void)dealloc {
    //注销其他选项
    for (NSString *keyStr in self.viewModel.pushArray) {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:keyStr];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNav];
    [self setUpViews];
    [self combineViewModel];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setUpViews
- (void)setUpNav {
    [self navBack:YES];
    self.title = @"您的买车需求";
}

- (void)setUpViews {
    [self.view addSubview:self.submmitButton];
    [self.view addSubview:self.tableView];
    
    WEAKSELF
    [self.submmitButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(40);
        make.right.equalTo(-40);
        make.height.equalTo(40);
        make.bottom.equalTo(-10);
    }];
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(0);
        make.bottom.equalTo(weakSelf.submmitButton.mas_top).offset(-10);
    }];
    
    self.tableView.tableHeaderView = self.headerView;
}

#pragma mark - lazyloading
-(CarDetailViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [CarDetailViewModel new];
    }
    return _viewModel;
}

-(UIButton *)submmitButton {
    if (!_submmitButton) {
        _submmitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submmitButton setTitle:@"立即下单" forState:UIControlStateNormal];
        _submmitButton.layer.cornerRadius = Button_H/8;
        _submmitButton.backgroundColor = kskyBlueColor;
        [_submmitButton addTarget:self action:@selector(submmitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submmitButton;
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

-(DetailChooseCarHeader *)headerView {
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"DetailChooseCarHeader" owner:self options:nil] lastObject];
        _headerView.height = 220;
    }
    return _headerView;
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [AppDelegate APP].user ? 3 : 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([AppDelegate APP].user) {
        if (section == 0) {
            return 4;
        }else if (section == 1) {
            return [self.viewModel.keyArr[0] count] +1;
        }else {
            return 1;
        }
    }else {
        if (section == 0) {
            return 3;
        }else if (section == 1) {
            return 4;
        }else if(section == 2) {
            return [self.viewModel.keyArr[0] count] +1;
        }else {
            return 1;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index = [AppDelegate APP].user ? 0 : 1;
    
    if (indexPath.section == (index-1)) {
        DetailCarInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:informationCell];
        if (cell == nil) {
            cell = [[DetailCarInformationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:informationCell];
        }
        
        if (indexPath.row != 2) {
            cell.lineView.hidden = YES;
            cell.getCodeBtn.hidden = YES;
        }
        
        [cell.getCodeBtn addTarget:self action:@selector(getCodeAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.iconImgView.image = [UIImage imageNamed:self.viewModel.imgNameArray[indexPath.row]];
        cell.writeTF.placeholder = self.viewModel.chooseTitleArray[indexPath.row];
        [cell.writeTF setValue:GRAYCOLOR forKeyPath:@"_placeholderLabel.textColor"];
        
        return cell;

    }else if (indexPath.section == index) {
        ChooseCarCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:commonCell];
        if (cell == nil) {
            cell = [[ChooseCarCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commonCell];
        }
        
        cell.imageView.image = [UIImage imageNamed:self.viewModel.imgNameArray[indexPath.row+3]];
        cell.textLabel.text = self.viewModel.chooseTitleArray[indexPath.row+3];
        
        NSString *keyString = self.viewModel.keyArray[indexPath.row];
        if ([[self.viewModel.getBackChooseDictionary allKeys] containsObject:keyString]) {
            [cell.textLabel createLabelWithFontSize:15 color:TEXTCOLOR];
            cell.textLabel.text = [self.viewModel.getBackChooseDictionary objectForKey:keyString];
        }else {
            [cell.textLabel createLabelWithFontSize:15 color:GRAYCOLOR];
            cell.textLabel.text = self.viewModel.chooseTitleArray[indexPath.row+3];
        }
        
        return cell;
    }else if (indexPath.section == (index+1)) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ParamsCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ParamsCell"];
            
            UIView *line = [UIView new];
            line.backgroundColor = BGGRAYCOLOR;
            [cell.contentView addSubview:line];
            [line makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(0);
                make.height.equalTo(1);
            }];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = H15;
        cell.detailTextLabel.font = H15;
        
        if (indexPath.row == 0) {
            cell.textLabel.textColor = TEXTCOLOR;
            cell.textLabel.text = @"参数配置";
            cell.detailTextLabel.text = @"";
        }else {
            cell.textLabel.textColor = GRAYCOLOR;
            cell.textLabel.text = self.viewModel.keyArr[0][indexPath.row-1];
            cell.detailTextLabel.text = self.viewModel.valueArr[0][indexPath.row-1];
        }
        
        return cell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        
        cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
        
        return cell;
    }
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if ([AppDelegate APP].user) {
        return (section == 0 || section == 1)? 12 : 40;
    }else {
        return section == 0 ? 12 : (section == 1 ? CGFLOAT_MIN : 40);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger index = [AppDelegate APP].user ? 0 : 1;
    
    if (indexPath.section == index) {       //选择
        DKNeedsTableViewController *needsVC = [[DKNeedsTableViewController alloc] init];
        
        needsVC.title = self.viewModel.pushArray[indexPath.row];
        
        if (indexPath.row == 0) {
            needsVC.dataArray = (NSMutableArray *)self.viewModel.colorArray;
        }else {
            needsVC.dataArray = self.viewModel.pushTitleArr[indexPath.row-1];
        }
        
        [needsVC returnText:^(NSString *chooseColor) {
            
            NSString *keyString = self.viewModel.keyArray[indexPath.row];
            [self.viewModel.getBackChooseDictionary setValue:chooseColor forKey:keyString];
            
            //刷新tableView,
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
        }];
        [self.navigationController pushViewController:needsVC animated:YES];
    }
}


#pragma mark - action
- (void)combineViewModel {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.cid, @"cid", nil];
    RACSignal *signal = [self.viewModel.carDetailCommand execute:params];
    [signal subscribeNext:^(id x) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.headerView createHeaderScrollViewWithModel:self.viewModel.carModel];
        });
    }];
    
//    self.submmitButton.rac_command = self.viewModel.submmitOrderCommand;
    
    NSInteger index = [AppDelegate APP].user ? 1 : 2;
    //参数
    RACSignal *paramSignal = [self.viewModel.carParamsCommand execute:params];
    [paramSignal subscribeNext:^(NSArray *result) {
//        dispatch_sync(dispatch_get_main_queue(), ^{
        
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
//        });
    }];
}

- (void)getCodeAction:(UIButton *)sender {
    DetailCarInformationCell *telCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
    NSString *tel = telCell.writeTF.text;
    
    NSLog(@"get code button");
    
    //此处优化：判断是否是11位 XXX 开头的手机号.
    if (tel.length == 0) {
        [PromtView showAlert:@"请输入11位手机号" duration:1.5];
    }else if (tel.length == 11) {
        [sender http_requestForCodeWithParams:tel];
    }else {
        [PromtView showAlert:@"手机号格式错误" duration:1.5];
    }
}

#pragma mark - 可以优化到View Model里的
- (void)submmitButtonAction:(UIButton *)sender {
    if ([AppDelegate APP].user) { //已登录，判断是否有未完成订单
        [self isHavintOrderComplete];
    }else { //先获取token值
        [self loginForToken];
    }
}

//登录
- (void)loginForToken {
    
    NSMutableArray *mArray = [NSMutableArray array];
    
    for (int i = 0; i < 3; i++) {
        DetailCarInformationCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
//        UITextField *mytf = [cell viewWithTag:7000];
        NSString *text = cell.writeTF.text;
        [mArray addObject:text];
    }
    
    for (NSString *tfString in mArray) {
        if (tfString.length <= 0) {
            [PromtView showAlert:@"信息不完全" duration:1.5];
            return;
        }
    }
    
    NSString *randomString = [BaseFunction ret32bitString];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", [BaseFunction getTimeSp]];
    NSString *md5String = [[BaseFunction md5Digest:[NSString stringWithFormat:@"%@%@%@", timeSp, randomString, APPSIGN]] uppercaseString];
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:randomString,@"nonce_str",
                            timeSp, @"time",
                            md5String, @"sign",
                            mArray[1],@"tel",
                            mArray[2], @"code",
                            mArray[0], @"name", nil];
    
    [DataService http_Post:ORDER_REGIST
                parameters:params
                   success:^(id responseObject) {
                       NSLog(@"order login:%@", responseObject);
                       if ([responseObject[@"status"] integerValue] == 1) {
                           
                           //存储
                           UserModel *userModel = [[UserModel alloc] initContentWithDic:responseObject];
                           userModel.sjhm = mArray[1];
                           userModel.zsxm = mArray[0];
                           userModel.token = responseObject[@"token"];
                           [AppDelegate APP].user = userModel;
                           //发送登录成功通知
                           [NotificationCenters postNotificationName:LOGIN_SUCCESS object:nil userInfo:nil];
                           
                           [self isHavintOrderComplete];
                       }else {
                           [PromtView showAlert:@"注册登录失败" duration:1.5];
                       }
                   } failure:^(NSError *error) {
                       NSLog(@"order login error:%@", error);
                       [PromtView showAlert:PromptWord duration:1.5];
                   }];

}

//判断未完成订单
- (void)isHavintOrderComplete {
    //拿到token值
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [AppDelegate APP].user.token, @"token",nil];
    
    [DataService http_Post:UNCOMPLETE_ORDER
                parameters:params
                   success:^(id responseObject) {
                       
                       NSLog(@"%@:%@", responseObject, [responseObject objectForKey:@"msg"]);
                       
                       //判断有没有未完成订单
                       if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
                           
                           //有未完成订单
                           [self payPromoutView];
                           
                       }else if ([[responseObject objectForKey:@"status"] integerValue] == 0){
                           
                           //没有待付款订单，提交订单
                           [self LabelTextIsNull];
                           
                       }else {
                           //其他
                           [PromtView showAlert:@"请求失败" duration:1.5];
                       }
                       
                   } failure:^(NSError *error) {
                       //
                       NSLog(@"order status error:%@", error);
                       [PromtView showAlert:PromptWord duration:1.5];
                   }];
}

//判断第一组选择的选项是否为空
- (void)LabelTextIsNull {

    if ([self.viewModel.getBackChooseDictionary allKeys].count < 4) {
        [PromtView showAlert:@"有选项为空" duration:1.5];
    }else {
        //提交订单的网络请求
        [self submmitOrder];
    }
}

//提交订单
- (void)submmitOrder {
    NSString *randomString = [BaseFunction ret32bitString];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", [BaseFunction getTimeSp]];
    NSString *md5String = [[BaseFunction md5Digest:[NSString stringWithFormat:@"%@%@%@", timeSp, randomString, APPSIGN]] uppercaseString];
    /*_keyArray = @[@"WaiGuan", @"Neishi", @"Way", @"Time"];*/
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[UserDefaults objectForKey:kLocationAction][@"cityid"],@"cityid",
                            
                            self.cid,@"cid",
                            
                            [self.viewModel.getBackChooseDictionary objectForKey:@"WaiGuan"], @"color",
                            
                            [self.viewModel.getBackChooseDictionary objectForKey:@"Neishi"], @"neishi",
                            
                            [self.viewModel.getBackChooseDictionary objectForKey:@"Way"], @"gcsj",
                            
                            [self.viewModel.getBackChooseDictionary objectForKey:@"Time"], @"gcfs",
                            
                            [AppDelegate APP].user.token, @"token",
                            
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
