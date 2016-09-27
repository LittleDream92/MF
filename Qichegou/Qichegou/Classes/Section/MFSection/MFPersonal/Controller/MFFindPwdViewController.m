//
//  MFFindPwdViewController.m
//  Qichegou
//
//  Created by Meng Fan on 16/9/23.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "MFFindPwdViewController.h"

@interface MFFindPwdViewController ()

//控件
@property (nonatomic, strong) UIButton *alertBtn;
@property (nonatomic, strong) UIButton *getCodeBtn;

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UITextField *accountTextFiled;
@property (nonatomic, strong) UITextField *codeTextFiled;
@property (nonatomic, strong) UITextField *pwdTextFiled;
@property (nonatomic, strong) UITextField *rePwdTextFiled;

@end

@implementation MFFindPwdViewController

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
    
    self.title = @"修改密码";
    [self navBack:YES];
}

- (void)setUpViews {
    WEAKSELF
    CGFloat padding = 20;
    
    [self.view addSubview:self.accountTextFiled];
    [self.accountTextFiled makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(10);
        make.width.equalTo(weakSelf.view);
        make.left.equalTo(0);
        make.height.equalTo(2*padding);
    }];
    
    [self.view addSubview:self.codeTextFiled];
    [self.codeTextFiled makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.top.equalTo(weakSelf.accountTextFiled.mas_bottom).offset(padding);
        make.height.equalTo(2*padding);
    }];
    
    [self.view addSubview:self.pwdTextFiled];
    [self.pwdTextFiled makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.top.equalTo(weakSelf.codeTextFiled.mas_bottom).offset(padding);
        make.height.equalTo(2*padding);
    }];
    
    [self.view addSubview:self.textLabel];
    [self.textLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.equalTo(weakSelf.pwdTextFiled.mas_bottom);
        make.size.equalTo(CGSizeMake(kScreenWidth, 20));
    }];
    
    [self.view addSubview:self.rePwdTextFiled];
    [self.rePwdTextFiled makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.height.equalTo(2*padding);
        make.top.equalTo(weakSelf.pwdTextFiled.mas_bottom).offset(padding);
    }];
    
    [self.view addSubview:self.alertBtn];
    [self.alertBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.left.equalTo(2*padding);
        make.right.equalTo(-2*padding);
        make.top.equalTo(weakSelf.rePwdTextFiled.mas_bottom).offset(2*padding);
        make.height.equalTo(35);
    }];
}

#pragma mark - lazyloading
-(UIButton *)alertBtn {
    if (!_alertBtn) {
        _alertBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _alertBtn.titleLabel.font = H15;
        [_alertBtn setTitle:@"确认修改" forState:UIControlStateNormal];
        [_alertBtn setBackgroundColor:blue_color];
    }
    return _alertBtn;
}

-(UIButton *)getCodeBtn {
    if (!_getCodeBtn) {
        _getCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _getCodeBtn.titleLabel.font = H15;
        [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _getCodeBtn.backgroundColor = GRAYCOLOR;
    }
    return _getCodeBtn;
}

-(UITextField *)accountTextFiled {
    if (!_accountTextFiled) {
        _accountTextFiled = [[UITextField alloc] init];
        _accountTextFiled.backgroundColor = white_color;
        _accountTextFiled.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"account"]];
        _accountTextFiled.leftViewMode = UITextFieldViewModeAlways;
        _accountTextFiled.placeholder = @"请输入11位手机号";
//        _accountTextFiled.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _accountTextFiled;
}

-(UITextField *)codeTextFiled {
    if (!_codeTextFiled) {
        _codeTextFiled = [[UITextField alloc] init];
        _codeTextFiled.backgroundColor = white_color;
        _codeTextFiled.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pwd"]];
        _codeTextFiled.leftViewMode = UITextFieldViewModeAlways;
        _codeTextFiled.placeholder = @"请输入动态验证码";
    }
    return _codeTextFiled;
}

-(UITextField *)pwdTextFiled {
    if (!_pwdTextFiled) {
        _pwdTextFiled = [[UITextField alloc] init];
        _pwdTextFiled.backgroundColor = white_color;
        _pwdTextFiled.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pwd"]];
        _pwdTextFiled.leftViewMode = UITextFieldViewModeAlways;
        _pwdTextFiled.placeholder = @"请输入密码";
    }
    return _pwdTextFiled;
}

-(UITextField *)rePwdTextFiled {
    if (!_rePwdTextFiled) {
        _rePwdTextFiled = [[UITextField alloc] init];
        _rePwdTextFiled.backgroundColor = white_color;
        _rePwdTextFiled.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pwd"]];
        _rePwdTextFiled.leftViewMode = UITextFieldViewModeAlways;
        _rePwdTextFiled.placeholder = @"请再次输入密码";
    }
    return _rePwdTextFiled;
}

-(UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = H10;
        _textLabel.textColor = GRAYCOLOR;
        _textLabel.text = @"   6-12字符";
//        _textLabel.backgroundColor = white_color;
    }
    return _textLabel;
}

@end
