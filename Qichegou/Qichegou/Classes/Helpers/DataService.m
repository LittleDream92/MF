//
//  DataService.m
//  DKQiCheGou
//
//  Created by Song Gao on 16/1/8.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DataService.h"

@implementation DataService


+ (AFHTTPSessionManager *)requestManager

{
    
    static dispatch_once_t onceToken;
    
    static
    AFHTTPSessionManager *ma;
    
    dispatch_once(&onceToken, ^{
        
        ma = [AFHTTPSessionManager
              manager];
        
        ma.responseSerializer = [AFJSONResponseSerializer
                                 serializer];

    });
    
    return ma;
    
}

//post
+ (void)http_Post:(NSString *)urlStr

       parameters:(NSDictionary *)params

          success:(successBlock)blockS

          failure:(failureBlock)blockF

{
    //显示状态栏的网络指示器
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //拼接URL
    NSString *urlString = [NSString stringWithFormat:@"%@%@", URL_String, urlStr];
    
    AFHTTPSessionManager *manager = [DataService requestManager];
    [manager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        blockS(responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        blockF(error);
    }];
    
}

#pragma mark - 监测网络状态
+ (void)reachability
{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                NSLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                NSLog(@"没有网络(断网)");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                NSLog(@"手机自带网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                NSLog(@"WIFI");
                break;
        }
    }];
    // 3.开始监控
    [mgr startMonitoring];
}

#pragma mark - 返回H5页面的网络请求
+ (void)request_post_html:(NSString *)url

                   params:(NSDictionary *)params

           completedBlock:(successBlock)blockS

                  failure:(failureBlock)blockF
{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //增加这几行代码；
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //这里进行设置；
    [manager setSecurityPolicy:securityPolicy];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

        NSString *htmlStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"成功: %@", htmlStr);
        blockS(htmlStr);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

        blockF(error);
    }];

}

@end
