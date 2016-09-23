//
//  MFLoginViewController.m
//  Qichegou
//
//  Created by Meng Fan on 16/9/23.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "MFLoginViewController.h"
#import "MFRegistViewController.h"
#import "MFFindPwdViewController.h"
#import "LoginViewModel.h"

@interface MFLoginViewController ()

//控件
@property (nonatomic, strong) UIButton *changeBtn;

@property (nonatomic, strong) UITextField *accountTextFiled;
@property (nonatomic, strong) UITextField *passwordTextFiled;

@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *registBtn;
@property (nonatomic, strong) UIButton *findPwdBtn;
@property (nonatomic, strong) UIButton *getCodeBtn;

@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIView *line2;

//ViewModel
@property (nonatomic, strong) LoginViewModel *viewModel;

@end

@implementation MFLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNav];
    [self setUpViews];
    [self setUpAction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setUp
- (void)setUpNav {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"登录";
    [self navBack:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.changeBtn];
}

- (void)setUpViews {
    
    WEAKSELF
    CGFloat padding = 50;
    CGFloat height = 30;
    
    [self.view addSubview:self.accountTextFiled];
    [self.accountTextFiled makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.left.equalTo (padding);
        make.right.equalTo(-padding);
        make.top.equalTo(padding+12);
        make.height.equalTo(height);
    }];
    
    [self.view addSubview:self.passwordTextFiled];
    [self.passwordTextFiled makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.left.equalTo (padding);
        make.right.equalTo(-padding);
        make.top.equalTo(weakSelf.accountTextFiled.mas_bottom).offset(height);
        make.height.equalTo(height);
    }];
    
    [self.accountTextFiled addSubview:self.line1];
    [self.line1 makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(UIEdgeInsetsMake(height-1, 0, 0, 0));
    }];
    [self.passwordTextFiled addSubview:self.line2];
    [self.line2 makeConstraints:^(MASConstraintMaker *make) {
       make.edges.offset(UIEdgeInsetsMake(height-1, 0, 0, 0));
    }];
    
    [self.view addSubview:self.findPwdBtn];
    [self.findPwdBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-padding);
        make.top.equalTo(weakSelf.passwordTextFiled.mas_bottom);
    }];
    
    [self.view addSubview:self.loginBtn];
    [self.loginBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.accountTextFiled);
        make.height.equalTo(35);
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.passwordTextFiled.mas_bottom).offset(65);
    }];
    
    [self.view addSubview:self.registBtn];
    [self.registBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.accountTextFiled);
        make.centerX.equalTo(weakSelf.view);
        make.height.equalTo(35);
        make.top.equalTo(weakSelf.loginBtn.mas_bottom).offset(40);
    }];
    
    [self.view addSubview:self.getCodeBtn];
    [self.getCodeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.passwordTextFiled);
        make.top.equalTo(weakSelf.passwordTextFiled);
        make.height.equalTo(weakSelf.passwordTextFiled);
    }];
}

- (void)setUpAction {
    //切换登录
    [[self.changeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"切换登录");
    }];
    
    //获取验证码
    [[self.getCodeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"获取验证码");
        
    }];
    
    //忘记密码
    [[self.findPwdBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        MFFindPwdViewController *findPwdVC = [[MFFindPwdViewController alloc] init];
        [self.navigationController pushViewController:findPwdVC animated:YES];
    }];
    
    //注册
    [[self.registBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        MFRegistViewController *registVC = [[MFRegistViewController alloc] init];
        [self.navigationController pushViewController:registVC animated:YES];
    }];
}

#pragma mark - lazyloading
-(UIButton *)changeBtn {
    if (!_changeBtn) {
        _changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeBtn setTitle:@"切换" forState:UIControlStateNormal];
        _changeBtn.frame = CGRectMake(0, 0, 40, 30);
        _changeBtn.titleLabel.font = H15;
    }
    return _changeBtn;
}

-(UITextField *)accountTextFiled {
    if (!_accountTextFiled) {
        _accountTextFiled = [[UITextField alloc] init];
//        _accountTextFiled.backgroundColor = yellow_color;
        _accountTextFiled.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"account"]];
        _accountTextFiled.leftViewMode = UITextFieldViewModeAlways;
        _accountTextFiled.placeholder = @"请输入11位手机号";
//        _accountTextFiled.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _accountTextFiled;
}

-(UITextField *)passwordTextFiled {
    if (!_passwordTextFiled) {
        _passwordTextFiled = [[UITextField alloc] init];
//        _passwordTextFiled.backgroundColor = yellow_color;
        _passwordTextFiled.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pwd"]];
        _passwordTextFiled.leftViewMode = UITextFieldViewModeAlways;
        _passwordTextFiled.placeholder = @"请输入密码";
    }
    return _passwordTextFiled;
}

-(UIButton *)findPwdBtn {
    if (!_findPwdBtn) {
        _findPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _findPwdBtn.titleLabel.font = H14;
        [_findPwdBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_findPwdBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    }
    return _findPwdBtn;
}

-(UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.titleLabel.font = H15;
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        _loginBtn.backgroundColor = [UIColor blueColor];
//        _loginBtn.layer.cornerRadius = 5;
    }
    return _loginBtn;
}

-(UIButton *)registBtn {
    if (!_registBtn) {
        _registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _registBtn.titleLabel.font = H15;
        [_registBtn setTitle:@"注册" forState:UIControlStateNormal];
        [_registBtn setBackgroundColor:GRAYCOLOR];
    }
    return _registBtn;
}

-(UIButton *)getCodeBtn {
    if (!_getCodeBtn) {
        _getCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _getCodeBtn.titleLabel.font = H15;
        [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _getCodeBtn.backgroundColor = [UIColor grayColor];
    }
    return _getCodeBtn;
}

-(UIView *)line1 {
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = GRAYCOLOR;
    }
    return _line1;
}

-(UIView *)line2 {
    if (!_line2) {
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = GRAYCOLOR;
    }
    return _line2;
}

-(LoginViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[LoginViewModel alloc] init];
    }
    return _viewModel;
}

@end
