//
//  DKLoginViewController.m
//  QiChegou
//
//  Created by Meng Fan on 16/7/7.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DKLoginViewController.h"
#import "CustomButtonView.h"
#import "DKRegistViewController.h"
#import "DKChangePWDViewController.h"
#import "DKBaseNaviController.h"
#import "UIButton+Extension.h"
#import "UserModel.h"
#import "AppDelegate.h"

@interface DKLoginViewController ()<CustomButtonProtocol>
{
    NSArray *titleArr;
    CGFloat buttonW;
    BOOL _index;
    
    NSString *_token;
}


@property (weak, nonatomic) IBOutlet CustomButtonView *controlView;
@property (weak, nonatomic) IBOutlet UITextField *telTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextFiled;

@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;


@end

@implementation DKLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpData];
    [self setUpViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setUp views
- (void)setUpData {
    titleArr = @[@"密码登录",@"动态登陆"];
    CGFloat x = self.controlView.frame.origin.x;
    buttonW = (kScreenWidth - x*2) / [titleArr count];
}

- (void)setUpViews {
    //控件视图
    self.controlView.myDelegate = self;
    [self.controlView createWithImgNameArr:nil selectImgNameArr:nil buttonW:buttonW];
    
    [self.controlView _initButtonViewWithMenuArr:titleArr
                                  textColor:GRAYCOLOR
                            selectTextColor:ITEMCOLOR
                             fontSizeNumber:16
                                   needLine:YES];
    
    self.telTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_tel"]];
    self.telTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextFiled.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_pwd"]];
    self.passwordTextFiled.leftViewMode = UITextFieldViewModeAlways;
}

#pragma mark - delegate
//代理协议
-(void)getTag:(NSInteger)tag {
    _index = tag - 1501;
    
    if (_index) {
        [self codeLogin];
        
    }else {
        [self pwdLogin];
    }
}

#pragma mark - 自定义
- (void)codeLogin
{
    self.getCodeBtn.hidden = NO;
    
    UIImageView *iconImgView = (UIImageView *)self.passwordTextFiled.leftView;
    iconImgView.image = [UIImage imageNamed:@"icon_code"];
    self.passwordTextFiled.text = nil;
    self.passwordTextFiled.secureTextEntry = NO;
    self.passwordTextFiled.keyboardType = UIKeyboardTypeNumberPad;
    self.passwordTextFiled.placeholder = @"请输入验证码";
}

- (void)pwdLogin
{
    self.getCodeBtn.hidden = YES;
    
    UIImageView *iconImgView = (UIImageView *)self.passwordTextFiled.leftView;
    iconImgView.image = [UIImage imageNamed:@"icon_pwd"];
    self.passwordTextFiled.text = nil;
    self.passwordTextFiled.secureTextEntry = YES;
    self.passwordTextFiled.keyboardType = UIKeyboardTypeDefault;
    self.passwordTextFiled.placeholder = @"请输入密码";
}

#pragma mark - button Action
- (IBAction)buttonAction:(UIButton *)sender {
    switch (sender.tag) {
        case 10:
        {
            NSLog(@"登录");
            [self LoginJudge];
            break;
        }
        case 11:
        {
            NSLog(@"注册");
            DKRegistViewController *registVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"DKRegistViewController"];
            DKBaseNaviController *navCtrller = [[DKBaseNaviController alloc] initWithRootViewController:registVC];
            [self presentViewController:navCtrller animated:YES completion:nil];

            break;
        }
        case 12:
        {
            NSLog(@"获取验证码");
            [self codeJudgeBtn:sender];
            break;
        }
        case 13:
        {
            NSLog(@"忘记密码");
            DKChangePWDViewController *changePwdVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"DKChangePWDViewController"];
            DKBaseNaviController *navCtrller = [[DKBaseNaviController alloc] initWithRootViewController:changePwdVC];
            [self presentViewController:navCtrller animated:YES completion:nil];

            break;
        }
        case 14:
        {
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
        default:
            break;
    }

}

#pragma mark - judge if it‘s null
- (void)LoginJudge {
    if (self.telTextField.text.length != 11) {
        NSLog(@"手机号不正确！");
        [PromtView showAlert:@"手机号不正确！" duration:1.5];
    }else if (self.passwordTextFiled.text.length == 0) {
        NSLog(@"验证码／密码不能为空！");
        [PromtView showAlert:@"验证码／密码不能为空！" duration:1.5];
    }else {
        
        if (_index) {
            //code login
            NSDictionary *params = [self setUpTheParamsWithType:0 token:nil];
            [self loginWithParams:params];
            
        }else {
        
            NSDictionary *params = [self setUpTheParamsWithType:1 token:nil];
            [self loginWithParams:params];
        }
    }
}


- (void)codeJudgeBtn:(UIButton *)button {
    if (self.telTextField.text.length == 11) {
        
        [button timerStartWithText:@"获取动态密码"];
        [button http_requestForCodeWithParams:self.telTextField.text];
        
    }else if (self.telTextField.text.length == 0){
        NSLog(@"手机号不能为空！");
        [PromtView showAlert:@"手机号不能为空！" duration:1.5];
    }else {
        NSLog(@"手机号格式错误！");
        [PromtView showAlert:@"手机号格式错误！" duration:1.5];
    }
}

#pragma mark - login
- (void)loginWithParams:(NSDictionary *)params {
    NSLog(@"login params:%@", params);
    
    [DataService http_Post:USERLOGIN
                parameters:params
                   success:^(id responseObject) {
                       NSLog(@"login result:%@", responseObject);
                       
                       if ([responseObject[@"status"] integerValue] == 1) {
                           
                           _token = [responseObject objectForKey:@"token"];

                           //存储
                           UserModel *userModel = [[UserModel alloc] initContentWithDic:responseObject];
                           userModel.sjhm = self.telTextField.text;
                           userModel.token = _token;
                           [AppDelegate APP].user = userModel;
                           
                           //发送登录成功通知
                           [NotificationCenters postNotificationName:LOGIN_SUCCESS object:nil userInfo:nil];

                           NSDictionary *params = [self setUpTheParamsWithType:2 token:responseObject[@"token"]];
                           [self requestUserInformationWithParams:params];
                       }else {
                           [PromtView showAlert:responseObject[@"msg"] duration:1.5];
                       }
                       
                   } failure:^(NSError *error) {
                       [PromtView showAlert:PromptWord duration:1.5];
                   }];

}

//get user information
- (void)requestUserInformationWithParams:(NSDictionary *)params {
    
    [DataService http_Post:USER_INFORMATION
     
                parameters:params
     
                   success:^(id responseObject) {

                       NSLog(@"userInformation success:%@", responseObject);
                       UserModel *userModel = [[UserModel alloc] initContentWithDic:responseObject];
                       userModel.token = _token;
                       [AppDelegate APP].user = userModel;
                       
                       //返回
                       [self dismissViewControllerAnimated:YES completion:nil];
                       
                   } failure:^( NSError *error) {
                       
                       NSLog(@"error:%@", error);
                       [PromtView showAlert:PromptWord duration:1.5];
                   }];
}


#pragma mark - params
- (NSDictionary *)setUpTheParamsWithType:(NSInteger)type token:(NSString *)token {
    
    NSString *randomString = [BaseFunction ret32bitString];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", [BaseFunction getTimeSp]];
    NSString *md5String = [[BaseFunction md5Digest:[NSString stringWithFormat:@"%@%@%@", timeSp, randomString, APPSIGN]] uppercaseString];
    
    NSDictionary *params = nil;
    
    switch (type) {
        case 0: //code login params
        {
            params = [[NSDictionary alloc] initWithObjectsAndKeys:randomString,@"nonce_str",
                      timeSp, @"time",
                      md5String, @"sign",
                      self.telTextField.text,@"tel",
                      self.passwordTextFiled.text, @"code",
                      @"", @"pass", nil];
            break;
        }
        case 1:
        {
            params = [[NSDictionary alloc] initWithObjectsAndKeys:randomString,@"nonce_str",
                      timeSp, @"time",
                      md5String, @"sign",
                      self.telTextField.text,@"tel",
                      self.passwordTextFiled.text, @"pass",
                      @"", @"code",nil];
            break;
        }
        case 2: // token
        {
            params = [[NSDictionary alloc] initWithObjectsAndKeys:randomString,@"nonce_str",
                      timeSp, @"time",
                      md5String, @"sign",
                      token,@"token",nil];
            break;
        }
        default:
            break;
    }
    
    return params;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


@end
