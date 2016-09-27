//
//  DataService.h
//  DKQiCheGou
//
//  Created by Song Gao on 16/1/8.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 常用json格式
 
 NSArray *g = @[@"fds",@"fds",@"fds"];
 
 NSDictionary *d = @{@"10":@"type"};
 
 BOOL b = @YES;
 
 NSNumber n = @1;
 
 备注：参数不对返回错误；
 */


/**
 @param operation  请求
 @param responseObject  请求返回的数据
 */
typedef void (^successBlock)(id responseObject);

/**
 @param operation 请求
 @param error  请求错误信息
 */
typedef void (^failureBlock)(NSError *error);



@interface DataService : NSObject



/**
 
 发送Post请求,使用AFHTTSessionManager
 
 @param urlStr 请求url
 
 @param params 请求参数
 
 @param blockS 请求成功block
 
 @param blockF 请求失败block
 
 */

+ (void)http_Post:(NSString *) urlStr

       parameters:(NSDictionary *) params

          success:(successBlock) blockS

          failure:(failureBlock) blockF;

#pragma mark - 监测网络状态
+ (void)reachability;

#pragma mark - 返回H5页面的网络请求
/*
 *  返回的是html 5 页面
 *  url :   URLString
 *  params  :   参数
 *  blockS  :   成功的block
 *  blockF  :   失败的block
 */
+ (void)request_post_html:(NSString *)url

                   params:(NSDictionary *)params

           completedBlock:(successBlock)blockS

                  failure:(failureBlock)blockF;


@end
