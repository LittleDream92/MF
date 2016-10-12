//
//  DKBaseViewController.m
//  Qichegou
//
//  Created by Meng Fan on 16/9/21.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DKBaseViewController.h"

@interface DKBaseViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIButton *backBtn;

@end

@implementation DKBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.view.backgroundColor = white_color;
    
    //**************方法一****************//
    //设置滑动回退
    __weak typeof(self) weakSelf = self;
    self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    //判断是否为第一个view
    if (self.navigationController && [self.navigationController.viewControllers count] == 1) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }

}

#pragma mark- UIGestureRecognizerDelegate
//**************方法一****************//
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)navBack:(BOOL)back {
    if (back) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
//        
//        [[self.backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }];
    }
}

#pragma mark - lazyloading
-(UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
        [_backBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateHighlighted];
        [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
        _backBtn.titleLabel.font = H16;
        _backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
        _backBtn.frame = CGRectMake(0, 0, 50, 44);
        [_backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

//弹出提示框
- (void)presentAlertViewWithString:(NSString *)txtString {
    //初始化提示框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:txtString preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
    
}
#pragma mark - action
- (void)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - HUD
//显示或者隐藏正在加载
- (void)showLoading:(BOOL)show {
    if (_tipView == nil) {
        _tipView = [[UIView alloc] initWithFrame:self.view.bounds];
        _tipView.backgroundColor = [UIColor whiteColor];
        
        UILabel *loadLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (_tipView.height - 20)/2 - 100, _tipView.width, 20)];
        loadLabel.text = @"正在加载...";
        loadLabel.backgroundColor = [UIColor clearColor];
        loadLabel.textAlignment = NSTextAlignmentCenter;
        [_tipView addSubview:loadLabel];
        
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityView startAnimating];
        activityView.frame = CGRectMake(100, loadLabel.top, 20, 20);
        [_tipView addSubview:activityView];
    }
    
    if (show) {
        [self.view addSubview:_tipView];
    }else {
        [_tipView removeFromSuperview];
    }
}

//显示加载视图（HUD）
- (void)showHUD:(NSString *)title
{
    if (_hud == nil) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    //让背景变暗
    _hud.dimBackground = YES;
    //设置文本
    _hud.labelText = title;
}

//隐藏HUD
- (void)hideHUD
{
    [_hud hide:YES afterDelay:1];
}

//加载完成提示HUD
- (void)completeHUD:(NSString *)title {
    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.labelText = title;
    
    [_hud hide:YES afterDelay:1];
}



@end
