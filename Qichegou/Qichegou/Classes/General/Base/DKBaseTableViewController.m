//
//  DKBaseTableViewController.m
//  Qichegou
//
//  Created by Meng Fan on 16/3/15.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DKBaseTableViewController.h"

@interface DKBaseTableViewController ()<UIGestureRecognizerDelegate>

@end

@implementation DKBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    

    //2、自定义UIBarButtonItem返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateHighlighted];
    [backBtn createButtonWithBGImgName:nil bghighlightImgName:nil titleStr:@"返回" fontSize:17];
    
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    [backBtn sizeToFit];
    [backBtn addTarget:self action:@selector(BackCtrlAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

- (void)setClose:(BOOL)close {
    if (close) {
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(0, 0, 44, 44);
        [closeBtn createButtonWithBGImgName:nil bghighlightImgName:nil titleStr:@"关闭" fontSize:17];
        [closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeBtn];
    }
}

#pragma mark - Click Action Methods
//返回按钮触发事件
- (void)BackCtrlAction:(UIButton *)backCtrl
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)closeAction:(UIButton *)closeBtn {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - HUD
//显示或者隐藏正在加载
- (void)showLoading:(BOOL)show
{
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
- (void)completeHUD:(NSString *)title
{
    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.labelText = title;
    
    [_hud hide:YES afterDelay:1];
}

//弹出提示框
- (void)presentAlertViewWithString:(NSString *)txtString
{
    //初始化提示框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:txtString preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
    
}

#pragma mark - 分割线
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
    {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


@end
