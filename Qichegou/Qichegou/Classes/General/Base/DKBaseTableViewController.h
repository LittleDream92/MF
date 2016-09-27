//
//  DKBaseTableViewController.h
//  Qichegou
//
//  Created by Meng Fan on 16/3/15.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DKBaseTableViewController : UITableViewController
{
    UIView *_tipView;
    MBProgressHUD *_hud;    //hud提示加载视图
    
//    AFHTTPRequestOperation *operation;  //网络请求对象
}

@property (nonatomic, strong) NSMutableArray *dataArray;

//显示或者隐藏正在加载
- (void)showLoading:(BOOL)show;

//显示加载视图（HUD）
- (void)showHUD:(NSString *)title;

//隐藏HUD
- (void)hideHUD;

//加载完成提示HUD
- (void)completeHUD:(NSString *)title;

//弹出提示框
- (void)presentAlertViewWithString:(NSString *)txtString;

- (void)setClose:(BOOL)close;


@end
