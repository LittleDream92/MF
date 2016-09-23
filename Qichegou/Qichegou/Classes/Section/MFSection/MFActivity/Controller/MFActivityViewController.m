//
//  MFActivityViewController.m
//  Qichegou
//
//  Created by Meng Fan on 16/9/21.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "MFActivityViewController.h"
#import "ActivityViewModel.h"

@interface MFActivityViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) ActivityViewModel *viewModel;

@end

@implementation MFActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    [self setUpViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setUp
- (void)setNav {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //设置标题和背景
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"团购";
}

- (void)setUpViews {
    [self.view addSubview:self.webView];
    [self.webView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
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

-(ActivityViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ActivityViewModel alloc] init];
    }
    return _viewModel;
}

@end
