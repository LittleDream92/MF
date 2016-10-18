//
//  DKRegistViewController.m
//  QiChegou
//
//  Created by Meng Fan on 16/7/8.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DKRegistViewController.h"
#import "DKTextField.h"
#import "UIButton+Extension.h"
#import "RegistViewModel.h"

@interface DKRegistViewController ()
{
       __weak IBOutlet UIButton *_registBtn;
}

@property (weak, nonatomic) IBOutlet DKTextField *telTF;
@property (weak, nonatomic) IBOutlet DKTextField *pwdTF;
@property (weak, nonatomic) IBOutlet DKTextField *rePwdTF;
@property (weak, nonatomic) IBOutlet DKTextField *nameTF;
@property (weak, nonatomic) IBOutlet DKTextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;

@property (nonatomic, strong) RegistViewModel *viewModel;

@end

@implementation DKRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNav];
    [self setUpView];
    [self bindWithViewModel];
}

#pragma mark - setUp
- (void)setUpNav {
    self.title = @"注册账号";
    [self navBack:YES];
    self.viewModel = [RegistViewModel new];
}

- (void)setUpView {
    self.telTF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_tel"]];
    self.telTF.leftViewMode = UITextFieldViewModeAlways;
    
    self.pwdTF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_pwd"]];
    self.pwdTF.leftViewMode = UITextFieldViewModeAlways;
    
    self.rePwdTF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_pwd"]];
    self.rePwdTF.leftViewMode = UITextFieldViewModeAlways;
    
    self.nameTF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_my"]];
    self.nameTF.leftViewMode = UITextFieldViewModeAlways;
    
    self.codeTF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_pwd"]];
    self.codeTF.leftViewMode = UITextFieldViewModeAlways;
}

- (void)bindWithViewModel {
    RAC(self.viewModel, account) = self.telTF.rac_textSignal;
    RAC(self.viewModel, pwd) = self.pwdTF.rac_textSignal;
    RAC(self.viewModel, rePwd) = self.rePwdTF.rac_textSignal;
    RAC(self.viewModel, name) = self.nameTF.rac_textSignal;
    RAC(self.viewModel, code) = self.codeTF.rac_textSignal;
    
    _registBtn.rac_command = self.viewModel.registCommand;
    
    [self.viewModel.registCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"网络请求返回了数据");
        if ([x isEqualToString:@"注册成功"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - action

- (IBAction)buttonAction:(UIButton *)sender {
    
    switch (sender.tag) {
        case 20: {
            NSLog(@"获取验证码");
            [self codeJudgeBtn:sender];
            break;
        }
        case 22: {
            NSLog(@"直接登录");
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark - judge if it‘s null
- (void)codeJudgeBtn:(UIButton *)button {
    if (self.telTF.text.length == 11) {
        
        [button timerStartWithText:@"获取验证码"];
        [button http_requestForCodeWithParams:self.telTF.text];
        
    }else if (self.telTF.text.length == 0){
        NSLog(@"手机号不能为空！");
        [PromtView showAlert:@"手机号不能为空！" duration:1.5];
    }else {
        NSLog(@"手机号格式错误！");
        [PromtView showAlert:@"手机号格式错误！" duration:1.5];
    }
}
#pragma mark - keyBoard methods
- (IBAction)telTextField_DidEndOnExit:(id)sender {
    
    // 将焦点移至下一个文本框.
    [_pwdTF becomeFirstResponder];
    
}

- (IBAction)pwdTextField_DidEndOnExit:(id)sender {
    
    // 将焦点移至下一个文本框.
    [_rePwdTF becomeFirstResponder];
}

- (IBAction)rePwdTextField_DidEndOnExit:(id)sender {
    
    // 将焦点移至下一个文本框.
    [_nameTF becomeFirstResponder];
}

- (IBAction)nameTextField_DidEndOnExit:(id)sender {
    
    // 将焦点移至下一个文本框.
    [_codeTF becomeFirstResponder];
}

- (IBAction)codeTextField_DidEndOnExit:(id)sender {
    
    // 隐藏键盘.
    [sender resignFirstResponder];
    
    // 触发登陆按钮的点击事件.
    [_registBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    
}

- (IBAction)view_TouchDown:(id)sender {
    
    // 发送resignFirstResponder.
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}


#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
