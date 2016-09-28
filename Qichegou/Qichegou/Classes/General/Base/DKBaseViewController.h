//
//  DKBaseViewController.h
//  Qichegou
//
//  Created by Meng Fan on 16/9/21.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DKBaseViewController : UIViewController
{
    UIView *_tipView;
    MBProgressHUD *_hud;    //hud提示加载视图
}

- (void)navBack:(BOOL)back;

//
- (void)backAction:(UIButton *)sender;

//弹出提示框
- (void)presentAlertViewWithString:(NSString *)txtString;


//-----------------HUD
//显示或者隐藏正在加载
- (void)showLoading:(BOOL)show;

//显示加载视图（HUD）
- (void)showHUD:(NSString *)title;

//隐藏HUD
- (void)hideHUD;

//加载完成提示HUD
- (void)completeHUD:(NSString *)title;

@end
