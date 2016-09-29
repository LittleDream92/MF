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

@interface DKRegistViewController ()
{
       __weak IBOutlet UIButton *_registBtn;
}

@property (weak, nonatomic) IBOutlet DKTextField *telTF;
@property (weak, nonatomic) IBOutlet DKTextField *pwdTF;
@property (weak, nonatomic) IBOutlet DKTextField *rePwdTF;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;

@end

@implementation DKRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNav];
    [self setUpView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - setUp
- (void)setUpNav {
    self.title = @"注册账号";
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateHighlighted];
    [backBtn createButtonWithBGImgName:nil bghighlightImgName:nil titleStr:@"返回" fontSize:17];
    
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    [backBtn sizeToFit];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
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
    self.codeTF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_code"]];
    self.codeTF.leftViewMode = UITextFieldViewModeAlways;
}

#pragma mark - Click Action Methods
//返回按钮触发事件
- (void)backAction:(UIButton *)backCtrl {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)buttonAction:(UIButton *)sender {
    
    switch (sender.tag) {
        case 20:
        {
            NSLog(@"获取验证码");
            [self codeJudgeBtn:sender];
            break;
        }
        case 21:
        {
            NSLog(@"完成注册");
            [self registJudge];
            break;
        }
        case 22:
        {
            NSLog(@"直接登录");
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
        default:
            break;
    }
}

#pragma mark - judge if it‘s null
- (void)registJudge {
    if (_telTF.text.length != 11) {
        NSLog(@"手机号不正确！");
        [PromtView showAlert:@"手机号不正确！" duration:1.5];
    }else if (_pwdTF.text.length == 0) {
        NSLog(@"密码不能为空！");
        [PromtView showAlert:@"密码不能为空！" duration:1.5];
    }else if (![_rePwdTF.text isEqualToString:_pwdTF.text]) {
        NSLog(@"两次密码不一致");
        [PromtView showAlert:@"两次密码不一致" duration:1.5];
    }else if (_nameTF.text.length == 0) {
        NSLog(@"姓名不能为空！");
        [PromtView showAlert:@"姓名不能为空！" duration:1.5];
    }else if (_codeTF.text.length == 0) {
        NSLog(@"验证码不能为空！");
        [PromtView showAlert:@"验证码不能为空！" duration:1.5];
    }else {
        [self registAction];
    }
}


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

#pragma mark - #pragma mark - 网络请求
- (void)registAction {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:_telTF.text,@"tel",
                            _codeTF.text,@"code",
                            _nameTF.text,@"name",
                            _pwdTF.text,@"pass",nil];
    
    [DataService http_Post:REGIST
                parameters:params
                   success:^(id responseObject) {
                       
                       NSLog(@"register result:%@ __ msg:%@", responseObject, [responseObject objectForKey:@"msg"]);
                       
                       NSDictionary *jsonDic = responseObject;
                       if ([[jsonDic objectForKey:@"status"] integerValue] == 1) {
                           NSLog(@"注册成功！");
                           //去登录
                           [self dismissViewControllerAnimated:YES completion:nil];
                           
                       }else {
                           //提示失败
                           NSLog(@"%@", [jsonDic objectForKey:@"msg"]);
                           [PromtView showAlert:[jsonDic objectForKey:@"msg"] duration:1.5];
                       }
                       
                   } failure:^(NSError *error) {
                       NSLog(@"regist error:%@", error);
                       [PromtView showAlert:PromptWord duration:1.5];
                   }];
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


@end
