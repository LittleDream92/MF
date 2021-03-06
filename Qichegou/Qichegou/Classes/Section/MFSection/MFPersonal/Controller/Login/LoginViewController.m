//
//  LoginViewController.m
//  Qichegou
//
//  Created by Meng Fan on 16/10/13.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "LoginViewController.h"
#import "CustomButtonView.h"
#import "DKRegistViewController.h"
#import "DKChangePWDViewController.h"
#import "DKBaseNaviController.h"
#import "UIButton+Extension.h"
#import "UserModel.h"
#import "AppDelegate.h"

#import "LoginViewModel.h"

@interface LoginViewController ()<CustomButtonProtocol>
{
    NSArray *titleArr;
    CGFloat buttonW;
}


@property (weak, nonatomic) IBOutlet CustomButtonView *controlView;
@property (weak, nonatomic) IBOutlet UITextField *telTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextFiled;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *findPwdBtn;

//ViewModel
@property (nonatomic, strong) LoginViewModel *viewModel;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //通知
    [NotificationCenters addObserver:self selector:@selector(loginSuccess:) name:LOGIN_SUCCESS object:nil];
    
    self.title = @"登录";
    [self navBack:YES];
    
    [self setUpData];
    [self setUpViews];
    [self combineViewModel];
    
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
    self.controlView.isCondationChooseCar = YES;
    [self.controlView _initButtonViewWithMenuArr:titleArr
                                       textColor:GRAYCOLOR
                                 selectTextColor:kskyBlueColor
                                  fontSizeNumber:16
                                        needLine:YES];
    
    self.telTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_tel"]];
    self.telTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextFiled.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_pwd"]];
    self.passwordTextFiled.leftViewMode = UITextFieldViewModeAlways;
}

#pragma mark - viewModel
- (void)combineViewModel {
    self.viewModel.isPwdLogin = YES;
    RAC(self.viewModel, account) = self.telTextField.rac_textSignal;
    RAC(self.viewModel, pwd) = self.passwordTextFiled.rac_textSignal;
    self.loginBtn.rac_command = self.viewModel.loginCommand;
}

#pragma mark - lazyloading
-(LoginViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[LoginViewModel alloc] init];
    }
    return _viewModel;
}


#pragma mark - delegate
//代理协议
-(void)getTag:(NSInteger)tag {
    NSInteger index = tag - 1501;
    
    if (index == 0) {
        self.viewModel.isPwdLogin = YES;
        [self pwdLogin];
    }else {
        self.viewModel.isPwdLogin = NO;
        [self codeLogin];
    }
}

- (void)codeLogin {
    self.getCodeBtn.hidden = NO;
    
    self.viewModel.pwd = @"";
    self.passwordTextFiled.text = nil;
    self.passwordTextFiled.secureTextEntry = NO;
    self.passwordTextFiled.keyboardType = UIKeyboardTypeNumberPad;
    self.passwordTextFiled.placeholder = @"请输入验证码";
    self.findPwdBtn.hidden = YES;
}

- (void)pwdLogin {
    self.getCodeBtn.hidden = YES;
    
    self.viewModel.pwd = @"";
    self.passwordTextFiled.text = nil;
    self.passwordTextFiled.secureTextEntry = YES;
    self.passwordTextFiled.keyboardType = UIKeyboardTypeDefault;
    self.passwordTextFiled.placeholder = @"请输入密码";
    self.findPwdBtn.hidden = NO;
}

#pragma mark - action
//notification
- (void)loginSuccess:(NSNotification *)notification {
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)buttonAction:(UIButton *)sender {
    switch (sender.tag) {
        case 11:
        {
            NSLog(@"注册");
            DKRegistViewController *registVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"DKRegistViewController"];
            [self.navigationController pushViewController:registVC animated:YES];
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
            [self.navigationController pushViewController:changePwdVC animated:YES];
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


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


@end
