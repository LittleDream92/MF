//
//  MFRegistViewController.m
//  Qichegou
//
//  Created by Meng Fan on 16/9/23.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "MFRegistViewController.h"

@interface MFRegistViewController ()

//控件
@property (nonatomic, strong) UITextField *userNameTextField;
@property (nonatomic, strong) UITextField *accountTextField;
@property (nonatomic, strong) UITextField *pwdTextField;
@property (nonatomic, strong) UITextField *rePwdTextField;
@property (nonatomic, strong) UITextField *codeTextField;

@property (nonatomic, strong) UIButton *registBtn;
@property (nonatomic, strong) UIButton *getCodeBtn;
@property (nonatomic, strong) UIButton *protocolBtn;

@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *pwdLabel;
@property (nonatomic, strong) UILabel *protocolLabel;

@end

@implementation MFRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNav];
    [self setUpViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setUp
- (void)setUpNav {
    self.view.backgroundColor = BGGRAYCOLOR;
    
    self.title = @"注册";
    [self navBack:YES];
}

- (void)setUpViews {
    WEAKSELF
    CGFloat padding = 20;
    
    [self.view addSubview:self.userNameTextField];
    [self.userNameTextField makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.left.equalTo(0);
        make.height.equalTo(2*padding);
        make.top.equalTo(10);
    }];
    
    [self.view addSubview:self.userNameLabel];
    [self.userNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.left.equalTo(0);
        make.height.equalTo(20);
        make.top.equalTo(weakSelf.userNameTextField.mas_bottom);
    }];
    
    [self.view addSubview:self.accountTextField];
    [self.accountTextField makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.left.equalTo(0);
        make.height.equalTo(weakSelf.userNameTextField);
        make.top.equalTo(weakSelf.userNameLabel.mas_bottom);
    }];
    
    [self.view addSubview:self.pwdTextField];
    [self.pwdTextField makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.left.equalTo(0);
        make.height.equalTo(weakSelf.userNameTextField);
        make.top.equalTo(weakSelf.accountTextField.mas_bottom).offset(padding);
    }];
    
    [self.view addSubview:self.pwdLabel];
    [self.pwdLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.left.equalTo(0);
        make.height.equalTo(20);
        make.top.equalTo(weakSelf.pwdTextField.mas_bottom);
    }];
    
    [self.view addSubview:self.rePwdTextField];
    [self.rePwdTextField makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.left.equalTo(0);
        make.height.equalTo(weakSelf.userNameTextField);
        make.top.equalTo(weakSelf.pwdLabel.mas_bottom);
    }];
    
    [self.view addSubview:self.codeTextField];
    [self.codeTextField makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.left.equalTo(0);
        make.height.equalTo(weakSelf.userNameTextField);
        make.top.equalTo(weakSelf.rePwdTextField.mas_bottom).offset(padding);
    }];
    
    [self.view addSubview:self.registBtn];
    [self.registBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.left.equalTo(2*padding);
        make.right.equalTo(-2*padding);
        make.top.equalTo(weakSelf.codeTextField.mas_bottom).offset(2*padding);
        make.height.equalTo(35);
    }];
    
    [self.view addSubview:self.getCodeBtn];
    [self.getCodeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-padding);
        make.width.equalTo(100);
        make.top.equalTo(weakSelf.codeTextField).offset(5);
        make.bottom.equalTo(weakSelf.codeTextField).offset(-5);
    }];
}


#pragma mark - lazyloading
-(UITextField *)userNameTextField {
    if (!_userNameTextField) {
        _userNameTextField = [[UITextField alloc] init];
        _userNameTextField.backgroundColor = white_color;
        _userNameTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"account"]];
        _userNameTextField.leftViewMode = UITextFieldViewModeAlways;
        _userNameTextField.placeholder = @"请输入用户名";
    }
    return _userNameTextField;
}

-(UITextField *)accountTextField {
    if (!_accountTextField) {
        _accountTextField = [[UITextField alloc] init];
        _accountTextField.backgroundColor = white_color;
        _accountTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"account"]];
        _accountTextField.leftViewMode = UITextFieldViewModeAlways;
        _accountTextField.placeholder = @"请输入11位手机号";
        //        _accountTextFiled.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _accountTextField;
}

-(UITextField *)pwdTextField {
    if (!_pwdTextField) {
        _pwdTextField = [[UITextField alloc] init];
        _pwdTextField.backgroundColor = white_color;
        _pwdTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pwd"]];
        _pwdTextField.leftViewMode = UITextFieldViewModeAlways;
        _pwdTextField.placeholder = @"请输入密码";
    }
    return _pwdTextField;
}

-(UITextField *)rePwdTextField {
    if (!_rePwdTextField) {
        _rePwdTextField = [[UITextField alloc] init];
        _rePwdTextField.backgroundColor = white_color;
        _rePwdTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pwd"]];
        _rePwdTextField.leftViewMode = UITextFieldViewModeAlways;
        _rePwdTextField.placeholder = @"请再次输入密码";
    }
    return _rePwdTextField;
}

-(UITextField *)codeTextField {
    if (!_codeTextField) {
        _codeTextField = [[UITextField alloc] init];
        _codeTextField.backgroundColor = white_color;
        _codeTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pwd"]];
        _codeTextField.leftViewMode = UITextFieldViewModeAlways;
        _codeTextField.placeholder = @"请输入动态验证码";
    }
    return _codeTextField;
}

-(UIButton *)registBtn {
    if (!_registBtn) {
        _registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _registBtn.titleLabel.font = H15;
        [_registBtn setTitle:@"注册" forState:UIControlStateNormal];
        [_registBtn setBackgroundColor:blue_color];
    }
    return _registBtn;
}

-(UIButton *)getCodeBtn {
    if (!_getCodeBtn) {
        _getCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _getCodeBtn.titleLabel.font = H14;
        [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _getCodeBtn.backgroundColor = GRAYCOLOR;
    }
    return _getCodeBtn;
}

-(UILabel *)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.font = H10;
        _userNameLabel.textColor = GRAYCOLOR;
        _userNameLabel.text = @"   不能超过20字符";
//        _userNameLabel.backgroundColor = white_color;
    }
    return _userNameLabel;
}

-(UILabel *)pwdLabel {
    if (!_pwdLabel) {
        _pwdLabel = [[UILabel alloc] init];
        _pwdLabel.font = H10;
        _pwdLabel.textColor = GRAYCOLOR;
        _pwdLabel.text = @"   6-12字符";
//        _pwdLabel.backgroundColor = white_color;
    }
    return _pwdLabel;
}

@end
