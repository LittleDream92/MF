//
//  DKMyActivityOrderVC.m
//  Qichegou
//
//  Created by Meng Fan on 16/3/2.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DKMyActivityOrderVC.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "MFPayActivityOrderViewController.h"
#import "MFActivityDetailViewController.h"
#import "UIView+Extension.h"
#import "AppDelegate.h"

@interface DKMyActivityOrderVC ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *myListWebView;

@property (nonatomic, strong) NSArray *arr;

@end

@implementation DKMyActivityOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的活动列表";
    [self navBack:YES];
    
    [self createView];
    
    //网络请求数据
    [self dataRequest];
}

#pragma mark - setting and getting
-(UIWebView *)myListWebView {
    if (_myListWebView == nil) {
        _myListWebView = [[UIWebView alloc] init];
        _myListWebView.scalesPageToFit = YES;
        //设置代理
        _myListWebView.delegate = self;
        _myListWebView.backgroundColor = [UIColor grayColor];
    }
    return _myListWebView;
}

#pragma mark - createView
- (void)createView {

    [self.view addSubview:self.myListWebView];
    [self.myListWebView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    //js交互
    JSContext *context = [self.myListWebView  valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //支付定金 toPayByAPP()
    context[@"toPayByAPP"] = ^() {
    
        NSArray *args = [JSContext currentArguments];
        self.arr = args;
        
        // 更UI,不写在这里边的话报错
        /*
         This application is modifying the autolayout engine from a background thread, which can lead to engine corruption and weird crashes.  This will cause an exception in a future release.*/
        dispatch_async(dispatch_get_main_queue(), ^{
            //跳转到支付页面
            MFPayActivityOrderViewController *activityPayVC = [[MFPayActivityOrderViewController alloc] init];
            activityPayVC.array = self.arr;
            [self.navigationController pushViewController:activityPayVC animated:YES];
        });
    };
    
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
    NSLog(@"my order webView start load");
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"my order webView finish load");
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"my order %@", request);
    NSLog(@"my order %ld",(long)navigationType);
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        if([[UIApplication sharedApplication] canOpenURL:[request URL]]) {
            //push
            NSLog(@"my order push");
            MFActivityDetailViewController *activityDetailVC = [[MFActivityDetailViewController alloc] init];
            activityDetailVC.title = @"活动详情";
            activityDetailVC.detailURL = [[request URL] absoluteString];
            [self.navigationController pushViewController:activityDetailVC animated:YES];
        }
        return NO;
    }

    return YES;
}

#pragma mark - dataRequest
- (void)dataRequest {
//    [HttpTool requestActivityListblock:^(NSString *result) {
//        if (self.myListWebView) {
//            [self.myListWebView loadHTMLString:result baseURL:[NSURL URLWithString:URL_String]];
//        }
//    }];
    
    /*
     HTML5网页
     */
    NSString *tokenStr = [AppDelegate APP].user.token;
    
    if (tokenStr.length == 0) {
        tokenStr = TOKEN_PROMISE;
    }
    
    NSLog(@"token action list:%@", tokenStr);
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[UserDefaults objectForKey:kLocationAction][@"cityid"],@"cityid",
                            @"IOS",@"platform",
                            tokenStr,@"token", nil];
    [DataService request_post_html:[NSString stringWithFormat:@"%@%@", URL_String, ACTIVITY_ORDER]
                            params:params completedBlock:^(id responseObject) {
                                NSString *htmlStr = responseObject;
                                NSLog(@"%@", htmlStr);
//                                if (self.myListWebView) {
                                    [self.myListWebView loadHTMLString:htmlStr baseURL:[NSURL URLWithString:URL_String]];
//                                }

                            } failure:^(NSError *error) {
                                [PromtView showAlert:PromptWord duration:1.5];
                            }];
    
}


@end
