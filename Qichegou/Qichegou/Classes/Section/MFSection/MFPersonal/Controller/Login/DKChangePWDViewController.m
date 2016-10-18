//
//  DKChangePWDViewController.m
//  QiChegou
//
//  Created by Meng Fan on 16/7/8.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DKChangePWDViewController.h"
#import "DKTextField.h"
#import "UIButton+Extension.h"
#import "RegistViewModel.h"

@interface DKChangePWDViewController ()
{
    __weak IBOutlet UIButton *_changeBtn;
}
@property (weak, nonatomic) IBOutlet DKTextField *telTF;
@property (weak, nonatomic) IBOutlet DKTextField *setPWD;
@property (weak, nonatomic) IBOutlet DKTextField *reNewPwdTF;
@property (weak, nonatomic) IBOutlet DKTextField *codeTF;

@property (nonatomic, strong) RegistViewModel *viewModel;

@end

@implementation DKChangePWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNav];
    [self setUpViews];
    [self bindViewModel];
}

#pragma mark - setUpViews
- (void)setUpNav {
    self.title = @"重置密码";
    [self navBack:YES];
    self.viewModel = [RegistViewModel new];
}

- (void)setUpViews {
    self.telTF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_tel"]];
    self.telTF.leftViewMode = UITextFieldViewModeAlways;
    
    self.setPWD.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_pwd"]];
    self.setPWD.leftViewMode = UITextFieldViewModeAlways;
    
    self.reNewPwdTF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_pwd"]];
    self.reNewPwdTF.leftViewMode = UITextFieldViewModeAlways;
    
    self.codeTF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_pwd"]];
    self.codeTF.leftViewMode = UITextFieldViewModeAlways;
}

- (void)bindViewModel {
    RAC(self.viewModel, account) = self.telTF.rac_textSignal;
    RAC(self.viewModel, pwd) = self.setPWD.rac_textSignal;
    RAC(self.viewModel, rePwd) = self.reNewPwdTF.rac_textSignal;
    RAC(self.viewModel, code) = self.codeTF.rac_textSignal;
    
    _changeBtn.rac_command = self.viewModel.changePwdCommand;
    
    [self.viewModel.changePwdCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"网络请求返回了数据");
        if ([x isEqualToString:@"修改成功"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];

}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action
- (IBAction)buttonAction:(UIButton *)sender {
    
    switch (sender.tag) {
        case 30:
        {
            NSLog(@"获取验证码");
            [self codeJudgebtn:sender];
            break;
        }
        case 32:
        {
            NSLog(@"直接登录");
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark - judge if it‘s null

- (void)codeJudgebtn:(UIButton *)button {
    if (_telTF.text.length == 11) {
        [button timerStartWithText:@"获取验证码"];
        [button http_requestForCodeWithParams:_telTF.text];
    }else if (_telTF.text.length == 0) {
        NSLog(@"手机号不能为空！");
        [PromtView showAlert:@"手机号不能为空！" duration:1.5];
    }else {
        NSLog(@"手机号格式错误");
        [PromtView showAlert:@"手机号格式错误" duration:1.5];
    }
}

#pragma mark - keyBoard methods
- (IBAction)view_touchDown:(id)sender {
    // 发送resignFirstResponder.
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}


- (IBAction)telTextField_DidEndExit:(id)sender {
    
    // 将焦点移至下一个文本框.
    [_codeTF becomeFirstResponder];
}

- (IBAction)codeTextField_DidEndOnExit:(id)sender {
    
    // 将焦点移至下一个文本框.
    [self.setPWD becomeFirstResponder];
}

- (IBAction)newPwd_DidEndOnExit:(id)sender {
    
    // 将焦点移至下一个文本框.
    [_reNewPwdTF becomeFirstResponder];
}

- (IBAction)reNewPwd_DidEndOnExit:(id)sender {
    
    // 隐藏键盘.
    [sender resignFirstResponder];
    
    // 触发登陆按钮的点击事件.
//    [_changeBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
}


@end
