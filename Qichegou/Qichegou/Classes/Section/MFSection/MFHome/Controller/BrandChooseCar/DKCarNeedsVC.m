//
//  DKCarNeedsVC.m
//  DKQiCheGou
//
//  Created by Song Gao on 16/1/20.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DKCarNeedsVC.h"
#import "BuyCarNeedsTVC.h"
#import "BuyCarNeedsHeaderView.h"
#import "BuyCarNeedsFooterView.h"
#import "DKPayMoneyVC.h"
#import "DKMyOrderVC.h"
#import "DKNeedsTableViewController.h"
#import "AppDelegate.h"

@interface DKCarNeedsVC ()<UIGestureRecognizerDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
{
    NSArray *_keyArray;
}
@property (nonatomic, strong) UITableView *needsTV;

@property (nonatomic, strong) NSArray *imgNameArray;
@property (nonatomic, strong) NSArray *celltitleArray;
@property (nonatomic, strong) NSArray *pushArray;

@property (nonatomic, strong) NSArray *pushTitleArr;
@property (nonatomic, strong) BuyCarNeedsHeaderview *headerView;
@property (nonatomic, strong) BuyCarNeedsFooterView *footerView;

@end

@implementation DKCarNeedsVC

-(void)dealloc {
    //注销其他选项
    for (NSString *keyStr in self.pushArray) {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:keyStr];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNav];
    
    //注册手势
    UITapGestureRecognizer *oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)] ;
    oneTap.delegate = self;
    oneTap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:oneTap];
    
    [self data];
    [self setUpViews];
    [self http_request];
}

- (void)setUpNav {
    self.title = @"您的买车需求";
    [self navBack:YES];
}

- (void)setUpViews {
    
    [self.view addSubview:self.needsTV];
    [self.needsTV makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    //初始化表视图的头视图
    self.needsTV.tableHeaderView = self.headerView;
    
    //初始化表视图的尾视图
    self.needsTV.tableFooterView = self.footerView;
    UIButton *subMitBtn = [self.footerView viewWithTag:121];
    [subMitBtn addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - lazyloading
-(UITableView *)needsTV {
    if (!_needsTV) {
        _needsTV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _needsTV.delegate = self;
        _needsTV.dataSource = self;
        
        _needsTV.rowHeight = 49 *kHeightSale;
        _needsTV.scrollEnabled = NO;
    }
    return _needsTV;
}

-(BuyCarNeedsHeaderview *)headerView {
    if (_headerView == nil) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"BuyCarNeedsHeaderview" owner:self options:nil] lastObject];
        
        _headerView.height = 120*kHeightSale;
        _headerView.width = kScreenWidth;
        NSString *title = [NSString stringWithFormat:@"%@ %@", self.chooseModel.year, self.chooseModel.car_subject];
        [_headerView createHeaderViewWithImgName:self.chooseModel.main_photo title:title priceStr:self.chooseModel.guide_price];
    }
    return _headerView;
}

- (BuyCarNeedsFooterView *)footerView {
    if (_footerView == nil) {
        CGFloat footerheight = 0;
        if ([AppDelegate APP].user) {   //login
           
            footerheight = kScreenHeight - 120*kHeightSale - 12 * 2 *kHeightSale - 49 * 4 *kHeightSale - 64;
        }else {
            footerheight = kScreenHeight - 120*kHeightSale - 12 * 3 *kHeightSale - 49 * 7 *kHeightSale - 64;
        }
        _footerView = [[[NSBundle mainBundle] loadNibNamed:@"BuyCarNeedsFooterView" owner:nil options:nil] lastObject];
        _footerView.width = kScreenWidth;
        _footerView.height = footerheight;
    }
    return _footerView;
}



#pragma mark -data
- (void)data {
    _keyArray = @[@"WaiGuan", @"Neishi", @"Way", @"Time"];
    _getBackChooseDictionary = [NSMutableDictionary dictionary];
    self.pushTitleArr = @[@[@"无要求",@"深色",@"浅色"],
                          @[@"新车全款", @"新车分期", @"置换全新",@"置换分期"],
                          @[@"7天内", @"14天内",@"30天"],
                          @[@"上海",@"北京",@"南昌",@"哈尔滨"]];
    self.pushArray = @[@"外观颜色",@"内饰颜色",@"购车方式",@"购车时间"];
    self.celltitleArray = @[@[@"选择外观颜色",@"选择内饰颜色",@"新车或者置换",@"购车时间",@"上牌城市"],
                            @[@"我的姓名",@"我的手机",@"请输入验证码"]];
    self.imgNameArray = @[@[@"icon_1",@"icon_2",@"icon_3",@"icon_4"],
                          @[@"sale_my", @"sale_tel", @"sale_code"]];
}

#pragma mark -  UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([AppDelegate APP].user) {
        return 1;
    }else {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowNumber = (section == 0) ? 4 : 3;
    return rowNumber;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CarNeedsGetCellID"];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 20);

        cell.imageView.image = [UIImage imageNamed:self.imgNameArray[indexPath.section][indexPath.row]];
        
        NSString *keyString = _keyArray[indexPath.row];
        
        if ([[_getBackChooseDictionary allKeys] containsObject:keyString]) {
            [cell.textLabel createLabelWithFontSize:16 color:TEXTCOLOR];
            cell.textLabel.text = [_getBackChooseDictionary objectForKey:keyString];
        }else {
            [cell.textLabel createLabelWithFontSize:16 color:GRAYCOLOR];
            cell.textLabel.text = _celltitleArray[indexPath.section][indexPath.row];
        }
        
        return cell;
        
    }else {     //第二组
        BuyCarNeedsTVC *cell = [[[NSBundle mainBundle] loadNibNamed:@"BuyCarNeedsTVC" owner:nil options:nil] lastObject];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.iconImgView.image = [UIImage imageNamed:self.imgNameArray[indexPath.section][indexPath.row]];
        
        cell.writeTF.delegate = self;
        cell.writeTF.font = [UIFont systemFontOfSize:16];
        cell.writeTF.placeholder = _celltitleArray[indexPath.section][indexPath.row];
        
        if (indexPath.row != 2) {
            cell.lineView.hidden = YES;
            cell.getCodeBtn.hidden = YES;
        }
        [cell.getCodeBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
}


#pragma mark - tableView delelgate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat unLogin = (section == 1 ? 12.0 : CGFLOAT_MIN);
    if ([AppDelegate APP].user) {
        return 12.0;
    }else {
        return unLogin;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12 *kHeightSale;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        //第一组
        DKNeedsTableViewController *needsVC = [[DKNeedsTableViewController alloc] init];
        needsVC.title = self.pushArray[indexPath.row];
        
        if (indexPath.row == 0) {
            NSLog(@"%@", self.colorArr);
            needsVC.dataArray = (NSMutableArray *)self.colorArr;
        }else {
            needsVC.dataArray = self.pushTitleArr[indexPath.row - 1];
        }
        
        [needsVC returnText:^(NSString *chooseColor) {
            
            NSLog(@"chooseColor:%@", chooseColor);
            
            NSString *keyString = _keyArray[indexPath.row];
            [_getBackChooseDictionary setValue:chooseColor forKey:keyString];
            NSLog(@"cishi:%@", _getBackChooseDictionary);

            //刷新tableView,此处可以优化
            [self.needsTV reloadData];
        }];
        
        [self.navigationController pushViewController:needsVC animated:YES];
    }

}

#pragma mark - keyBoard
#pragma mark -textField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //开始编辑时触发，文本字段将成为first responder
    //开始编辑时，移动tableView
    CGRect frame = self.needsTV.frame;
    
    if (frame.origin.y== 0) {
        frame.origin.y -= 250;
    }

    [UIView beginAnimations:@"moveView" context:nil];
    [UIView setAnimationDuration:0.3];
    self.needsTV.frame = frame;
    [UIView commitAnimations];
}

#pragma mark -UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (![touch.view isKindOfClass: [UITextField class]]) {
        [self hideKeyBoard];
        return NO;
    }
    return YES;
}

- (void)hideKeyBoard {
    
    //收起键盘,发送resignFirstResponder.
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    //tableView回到原来的位置
    CGRect frame = self.needsTV.frame;
    if (frame.origin.y != 0) {
        frame.origin.y = 0;
    }else if (frame.origin.y == 0) {
        return;
    }
    
    [UIView beginAnimations:@"moveView" context:nil];
    [UIView setAnimationDuration:0.3];
    self.needsTV.frame = frame;
    [UIView commitAnimations];
}

#pragma mark - button methods
- (void)buttonAction:(UIButton *)button {   //验证码
    
    //拿到手机号的txtField
    UITableViewCell *cell = [self.needsTV cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:1]];
    UITextField *telTxtField = [cell viewWithTag:7000];
    
    //判断手机号
    if (telTxtField.text.length == 0) {
        
        NSLog(@"手机号不能为空");
        [PromtView showAlert:@"手机号不能为空" duration:1.5];
        
    }else if (telTxtField.text.length == 11) {
        
        [button timerStartWithText:@"获取验证码"];
        [button http_requestForCodeWithParams:telTxtField.text];
        
    }else {
        
        NSLog(@"手机号码错误");
        [PromtView showAlert:@"手机号格式错误" duration:1.5];
    }
    
}

- (void)buttonClickAction:(UIButton *)button {
    NSLog(@"提交");
    
    if ([AppDelegate APP].user) {
        
        //已登录提交，判断是否有未完成订单
        [self isHavintOrderComplete];
        
    }else {
        //未登录提交,先登录获取token值，然后判断是否有未完成订单
        [self textFieldStringIsNull];
        NSLog(@"还没有登录呢～");
    }
}

//判断第一组选择的选项是否为空
- (void)LabelTextIsNull {
    for (NSString *keyString in _keyArray) {
        if (![[_getBackChooseDictionary allKeys] containsObject:keyString]) {
            [PromtView showAlert:@"有选项为空" duration:2];
            return;
        }
    }
    
    //提交订单的网络请求
    [self submit_requestWithToken:[AppDelegate APP].user.token];

}

//判断要注册的信息是否为空
- (void)textFieldStringIsNull {
    NSMutableArray *mArray = [NSMutableArray array];
    
    for (int i = 0; i < 3; i++) {
        UITableViewCell *cell = [self.needsTV cellForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:1]];
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
    [self regist_requestWithName:mArray[0] tel:mArray[1] code:mArray[2]];
}


#pragma mark - http request
- (void)http_request {  //获取车型颜色
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.chooseModel.car_id ,@"cid", nil];
    
    [DataService http_Post:CHOOSE_COLOR
     
                parameters:params
     
                   success:^(id responseObject) {
                       NSLog(@"car colors:%@", responseObject);
                       if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
                           
                           
                           if ([[responseObject objectForKey:@"colors"] isKindOfClass:[NSArray class]] && [[responseObject objectForKey:@"colors"] count]>0) {
                               
                               NSArray *jsonArr = [responseObject objectForKey:@"colors"];
                               
                               NSMutableArray *mArr = [NSMutableArray array];
                               for (NSDictionary *jsonDic in jsonArr) {
                                   
                                   NSString *colorText = [jsonDic objectForKey:@"color"];
                                   [mArr addObject:colorText];
                               }
                               self.colorArr = mArr;
                               
                           }else {
                               [PromtView showAlert:@"此车还没有颜色可选" duration:1.5];
                           }
                           
                       }else {
                           NSLog(@"car colors:%@", [responseObject objectForKey:@"msg"]);
                           [PromtView showAlert:[responseObject objectForKey:@"msg"] duration:1.5];
                       }
                       
                   } failure:^(NSError *error) {
                       
                       NSLog(@"car colors error:%@", error);
                       [PromtView showAlert:PromptWord duration:1.5];
                   }];

}

- (void)isHavintOrderComplete { //查看订单状况，判断是否有未完成订单
    
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


- (void)submit_requestWithToken:(NSString *)tokenString {   //提交订单
    
    NSString *randomString = [BaseFunction ret32bitString];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", [BaseFunction getTimeSp]];
    NSString *md5String = [[BaseFunction md5Digest:[NSString stringWithFormat:@"%@%@%@", timeSp, randomString, APPSIGN]] uppercaseString];
    /*_keyArray = @[@"WaiGuan", @"Neishi", @"Way", @"Time"];*/
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"6",@"cityid",
                            
                            self.chooseModel.car_id,@"cid",
                            
                            [_getBackChooseDictionary objectForKey:@"WaiGuan"], @"color",
                            
                            [_getBackChooseDictionary objectForKey:@"Neishi"], @"neishi",
                            
                            [_getBackChooseDictionary objectForKey:@"Way"], @"gcsj",
                            
                            [_getBackChooseDictionary objectForKey:@"Time"], @"gcfs",
                            
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

- (void)regist_requestWithName:(NSString *)name tel:(NSString *)tel code:(NSString *)code { //注册
    
    NSString *randomString = [BaseFunction ret32bitString];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", [BaseFunction getTimeSp]];
    NSString *md5String = [[BaseFunction md5Digest:[NSString stringWithFormat:@"%@%@%@", timeSp, randomString, APPSIGN]] uppercaseString];
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:randomString,@"nonce_str",
                            timeSp, @"time",
                            md5String, @"sign",
                            tel,@"tel",
                            code, @"code",
                            name, @"name", nil];
    
    [DataService http_Post:ORDER_REGIST
                parameters:params
                   success:^(id responseObject) {
                       NSLog(@"order login:%@", responseObject);
                       if ([responseObject[@"status"] integerValue] == 1) {
                           
                           //存储
                           UserModel *userModel = [[UserModel alloc] initContentWithDic:responseObject];
                           userModel.sjhm = tel;
                           userModel.zsxm = name;
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
