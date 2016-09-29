//
//  MFActivityDetailViewController.m
//  Qichegou
//
//  Created by Meng Fan on 16/9/27.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "MFActivityDetailViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "DKLoginViewController.h"
#import "MFThirdActivityViewController.h"
#import "AppDelegate.h"

@interface MFActivityDetailViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation MFActivityDetailViewController

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
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.detailURL]]];
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


#pragma mark - 
- (void)jsAndOC
{
    JSContext *context = [self.webView  valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
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
            DKLoginViewController *loginVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"DKLoginViewController"];
            [self presentViewController:loginVC animated:YES completion:nil];
        });
        
        NSLog(@"+++++++end toLoginByAPP+++++++");
    };
}


#pragma mark - webView delegate
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"webView error:%@", error);
    /*一个页面没有被完全加载之前收到下一个请求，此时迅速会出现此error,error=-999
     此时可能已经加载完成，则忽略此error，继续进行加载。
     http: //stackoverflow.com/questions/1024748/how-do-i-fix-nsurlerrordomain-error-999-in-iphone-3-0-os */
    
    if([error code] == NSURLErrorCancelled)
    {
        NSLog(@"detail cancel");
        return;
    }
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"detail webView start load");
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"detail webView finish load");
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"detail %@, %ld", request, (long)navigationType);
    NSLog(@"detail- > choose %@", [request URL].absoluteString);
    
    NSString *nextURLStr = [request URL].absoluteString;
    NSArray *nextArr = [nextURLStr componentsSeparatedByString:@"/"];
    NSLog(@"nextArr:%@", nextArr);
    if ([nextArr containsObject:@"product"]) {
        NSLog(@"detail push");
        
        MFThirdActivityViewController *chooseVC = [[MFThirdActivityViewController alloc] init];
        chooseVC.title = @"选择车系";
        chooseVC.chooseURLStr = nextURLStr;
        [self.navigationController pushViewController:chooseVC animated:YES];
        
        return NO;
    }
    
    return YES;
}


#pragma mark - view system methods
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //拿到存储的token
    NSString *currentToken = [AppDelegate APP].user.token;
    NSString *tokenStr = [[self.detailURL componentsSeparatedByString:@"/"] lastObject];
    if (currentToken.length > 0 && ![tokenStr isEqualToString:currentToken]) {
        //不一样替换
        self.detailURL = [self.detailURL stringByReplacingOccurrencesOfString:tokenStr withString:currentToken];
        
        NSLog(@"-----%@", self.detailURL);
        NSURL *url = [NSURL URLWithString:self.detailURL];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        if (self.webView) {
            [self.webView loadRequest:request];
        }
    }
}

@end
