//
//  DKBaseTabbarController.m
//  Qichegou
//
//  Created by Meng Fan on 16/9/21.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DKBaseTabbarController.h"

#import "DKBaseNaviController.h"

#import "MFHomeViewController.h"
#import "MFActivityViewController.h"
#import "MFPersonalViewController.h"

#import "FirstOpenView.h"

@interface DKBaseTabbarController ()

@end

@implementation DKBaseTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.translucent = NO;
    
    //获取沙盒目录
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/qichegou.plist"];
    //区分第一次启动还是以后启动的
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    if (dic == nil) {
        //第一次运行
        [self initFirstOpenView];
        dic = @{@"first": @"YES"};
        //把一个字典写入到文件
        [dic writeToFile:filePath atomically:YES];
    }

    
    //初始化子控制器
    [self initialControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//初始化子控制器
-(void)initialControllers {
    
    MFHomeViewController *homeVC = [[MFHomeViewController alloc] init];
    MFActivityViewController *activityVC = [[MFActivityViewController alloc] init];
    MFPersonalViewController *personalVC = [[MFPersonalViewController alloc] init];
    
    [self setupController:homeVC image:@"Menu1" selectedImage:@"Menu1-1" title:@"首页"];
    [self setupController:activityVC image:@"Menu2" selectedImage:@"Menu2-2" title:@"活动"];
    [self setupController:personalVC image:@"Menu3" selectedImage:@"Menu3-3" title:@"我的"];
}

//设置控制器
-(void)setupController:(UIViewController *)childVc image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title {
    
    UIViewController *viewVc = (UIViewController *)childVc;
    viewVc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewVc.tabBarItem.title = title;
    DKBaseNaviController *navi = [[DKBaseNaviController alloc]initWithRootViewController:viewVc];
    [self addChildViewController:navi];
}


//先对tabbar做一些属性设置.这个initialize方法,只会走一次,所以我们把tabbar初始化的一些方法放在这里面
+(void)initialize{
    //通过apperance统一设置UITabBarItem的文字属性
    //后面带有UI_APPEARANCE_SELECTOR的方法, 都可以通过appearance对象来统一设置
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = SYSTEMFONT(10);
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectedAtts = [NSMutableDictionary dictionary];
    selectedAtts[NSFontAttributeName] = SYSTEMFONT(10);
    selectedAtts[NSForegroundColorAttributeName] = kskyBlueColor;
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAtts forState:UIControlStateSelected];
}

#pragma mark - 开机启动图
- (void)initFirstOpenView {
    NSLog(@"这是第一次启动app");
    FirstOpenView *firstOpenView = [[FirstOpenView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    firstOpenView.backgroundColor = [UIColor redColor];
    [self.view addSubview:firstOpenView];
}

@end
