//
//  MFActivityViewController.m
//  Qichegou
//
//  Created by Meng Fan on 16/9/21.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "MFActivityViewController.h"
#import "ActivityViewModel.h"
#import "MFActivityDetailViewController.h"
#import "AppDelegate.h"

@interface MFActivityViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) ActivityViewModel *viewModel;

@end

@implementation MFActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    [self setUpViews];
    [self setUpViewModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setUp
- (void)setNav {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //设置标题和背景
    self.navigationItem.title = @"团购";
}

- (void)setUpViews {
    [self.view addSubview:self.webView];
    [self.webView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)setUpViewModel {
    
    NSString *tokenStr = [AppDelegate APP].user.token;
    
    if (tokenStr.length == 0) {
        tokenStr = TOKEN_PROMISE;
    }
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"6",@"cityid",
                            @"IOS",@"platform",
                            tokenStr,@"token", nil];
    RACSignal *webViewSignal = [self.viewModel.webViewCommand execute:params];
    [webViewSignal subscribeNext:^(id x) {
        [self.webView loadHTMLString:x baseURL:[NSURL URLWithString:URL_String]];
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

#pragma mark - webView delegate
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"webView error:%@", error);
    
    /*一个页面没有被完全加载之前收到下一个请求，此时迅速会出现此error,error=-999
     此时可能已经加载完成，则忽略此error，继续进行加载。
     http: //stackoverflow.com/questions/1024748/how-do-i-fix-nsurlerrordomain-error-999-in-iphone-3-0-os */
    if([error code] == NSURLErrorCancelled) {
        return;
    }
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"list webView start load");
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"list webView finish load");
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"list %@， %ld", [request URL], (long)navigationType);
    NSString *nestString = [[request URL] absoluteString];
    if ([nestString containsString:@"aid"]) {
        
        MFActivityDetailViewController *activityDetailVC = [[MFActivityDetailViewController alloc] init];
        activityDetailVC.title = @"活动详情";
        activityDetailVC.detailURL = [[request URL] absoluteString];
        [self.navigationController pushViewController:activityDetailVC animated:YES];
        
        return NO;
    }
    
    return YES;
}

@end
