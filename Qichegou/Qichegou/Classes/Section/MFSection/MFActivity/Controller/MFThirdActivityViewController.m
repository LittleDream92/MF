//
//  MFThirdActivityViewController.m
//  Qichegou
//
//  Created by Meng Fan on 16/9/27.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "MFThirdActivityViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "LoginViewController.h"
#import "DKActivityPayMoneyVC.h"
#import "DKMyActivityOrderVC.h"

@interface MFThirdActivityViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSArray *activityArr;

@end

@implementation MFThirdActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self setUpViews];
    //交互
    [self jsAndOC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setUpViews
- (void)setNav {
    [self navBack:YES];
}

- (void)setUpViews {
    [self.view addSubview:self.webView];
    [self.webView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.chooseURLStr]]];
}

#pragma mark - lazyloading
-(UIWebView *)webView {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] init];
        
        _webView.scalesPageToFit = YES;
        //设置代理
        _webView.delegate = self;
    }
    return _webView;
}

#pragma mark - jsAndOC
- (void)jsAndOC
{
    //js交互
    JSContext *context = [self.webView  valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    //调用APP的活动订单列表界面
    context[@"toActivityOrderListByAPP"] = ^() {
        NSLog(@"+++++++Begin toActivityOrderListByAPP+++++++");
        NSArray *args = [JSContext currentArguments];
        for (JSValue *jsVal in args) {
            NSLog(@"toActivityOrderListByAPP：%@", jsVal);
        }
        JSValue *this = [JSContext currentThis];
        NSLog(@"toActivityOrderListByAPP——this: %@",this);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //跳转我的活动列表页面
            NSLog(@"跳转我的活动列表页面");
            DKMyActivityOrderVC *activityOrderVC = [[DKMyActivityOrderVC alloc] init];
            [self.navigationController pushViewController:activityOrderVC animated:YES];
        });
        
        NSLog(@"-------End toActivityOrderListByAPP-------");
    };
    
    //支付定金 toPayByAPP()
    context[@"toPayByAPP"] = ^() {
        NSLog(@"+++++++Begin toPayByAPP+++++++");
        NSArray *args = [JSContext currentArguments];
        self.activityArr = args;
        NSLog(@"%@", self.activityArr);
        
        JSValue *this = [JSContext currentThis];
        NSLog(@"toPayByAPP——this: %@",this);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更UI,不写在这里边的话报错
            /*
             This application is modifying the autolayout engine from a background thread, which can lead to engine corruption and weird crashes.  This will cause an exception in a future release.
             */
//            //跳转到支付页面
            NSLog(@"跳转到支付页面");
            DKActivityPayMoneyVC *activityPayVC = [[DKActivityPayMoneyVC alloc] init];
            activityPayVC.array = self.activityArr;
            [self.navigationController pushViewController:activityPayVC animated:YES];
        });
        
        NSLog(@"-------End toPayByAPP-------");
    };
    
    //未登录或者token失效，请求登录
    context[@"toLoginByAPP"] = ^() {
        
        NSLog(@"+++++++Begin toLoginByAPP+++++++");
        NSArray *args = [JSContext currentArguments];
        for (JSValue *jsVal1 in args) {
            NSLog(@"toLoginByAPP：%@", jsVal1);
        }
        JSValue *this = [JSContext currentThis];
        NSLog(@"toLoginByAPP——this: %@",this);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //登录
            LoginViewController *loginVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
            [self.navigationController pushViewController:loginVC animated:YES];
        });
        
        NSLog(@"+++++++end toLoginByAPP+++++++");
    };
}

@end
