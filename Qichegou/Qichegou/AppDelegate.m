//
//  AppDelegate.m
//  Qichegou
//
//  Created by Meng Fan on 16/9/21.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "AppDelegate.h"
#import "DKBaseTabbarController.h"
#import <CoreLocation/CoreLocation.h>
#import "WXApi.h"

@interface AppDelegate ()<CLLocationManagerDelegate, WXApiDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;   //定位

@end

@implementation AppDelegate

//单例,存储用户信息
+ (AppDelegate *)APP {
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //定位
    [self location];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [DKBaseTabbarController new];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    /*
     * @”firstLaunch” 用来开发者在程序的其他部分判断
     */
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"6",@"cityid",@"长沙",@"cityname", nil];
        [UserDefaults setObject:dic forKey:kLocationAction];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }
    
    // 注册微信
    [WXApi registerApp:WECHAT_ID withDescription:@"demo 2.0"];

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    //当有电话进来或者锁屏，这时你的应用程会挂起，在这时，UIApplicationDelegate委托会收到通知，调用 applicationWillResignActive 方法，你可以重写这个方法，做挂起前的工作，比如关闭网络，保存数据。
    NSLog(@"挂起");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSLog(@"app进入后台");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    NSLog(@"app开始活动");
    //定位
    [self location];
    
    if (self.user) {    //have login    :判断登录是否过期
        [self judgeTokenTime];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    //终止:当用户按下按钮，或者关机，程序都会被终止。当一个程序将要正常终止时会调用 applicationWillTerminate 方法。但是如果长主按钮强制退出，则不会调用该方法。这个方法该执行剩下的清理工作，比如所有的连接都能正常关闭，并在程序退出前执行任何其他的必要的工作：
}

/**
 *  wechatPay
 */

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    //这里判断是否发起的请求为微信支付，如果是的话，用WXApi的方法调起微信客户端的支付页面（://pay 之前的那串字符串就是你的APPID，）
    if ([[NSString stringWithFormat:@"%@",url] rangeOfString:[NSString stringWithFormat:@"%@://pay",WECHAT_ID]].location != NSNotFound) {   //是
        return  [WXApi handleOpenURL:url delegate:self];
    }else{
        return YES;
    }
}

#pragma mark - IOS9.0以后废弃了这两个方法的调用  改用上边这个方法了，请注意、
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    //这里判断是否发起的请求为微信支付，如果是的话，用WXApi的方法调起微信客户端的支付页面（://pay 之前的那串字符串就是你的APPID，）
    if ([[NSString stringWithFormat:@"%@",url] rangeOfString:[NSString stringWithFormat:@"%@://pay",WECHAT_ID]].location != NSNotFound) {
        return  [WXApi handleOpenURL:url delegate:self];
    }else{
        return YES;
    }
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    
    //这里判断是否发起的请求为微信支付，如果是的话，用WXApi的方法调起微信客户端的支付页面（://pay 之前的那串字符串就是你的APPID，）
    if ([[NSString stringWithFormat:@"%@",url] rangeOfString:[NSString stringWithFormat:@"%@://pay",WECHAT_ID]].location != NSNotFound) {
        return  [WXApi handleOpenURL:url delegate:self];
    }else {
        return YES;
    }
}

//微信SDK自带的方法，处理从微信客户端完成操作后返回程序之后的回调方法
-(void) onResp:(BaseResp*)resp {
    //这里判断回调信息是否为 支付
    if([resp isKindOfClass:[PayResp class]]){
        switch (resp.errCode) {
            case WXSuccess:
                //如果支付成功的话，全局发送一个通知，支付成功
                [[NSNotificationCenter defaultCenter] postNotificationName:@"weixin_pay_result" object:@"成功"];
                break;
                
            default:
                //如果支付失败的话，全局发送一个通知，支付失败
                [[NSNotificationCenter defaultCenter] postNotificationName:@"weixin_pay_result" object:@"失败"];
                break;
        }
    }
}


#pragma mark - location
- (void)location {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        //未开启定位
        NSLog(@"未开启定位");
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您没有开启定位功能,前去打开" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //跳转设置开启定位页面
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        
        [alert addAction:cancel];
        [alert addAction:sure];
        
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
        
    } else if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        NSLog(@"使用时定位");
        //使用时定位
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager startUpdatingLocation];
    } else {
        NSLog(@"始终定位");
        //始终定位
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager startUpdatingLocation];
    }
}

-(CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            [_locationManager requestWhenInUseAuthorization];
        }
        //设置代理
        [_locationManager setDelegate:self];
        //设置定位精度
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyThreeKilometers];
        //设置距离筛选
        [_locationManager setDistanceFilter:100];
    }
    return _locationManager;
}

#pragma mark CoreLocation delegate
//定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    [self.locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    
    // 获取经纬度
    NSString *lat= [NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude];
    NSString *lon = [NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude];
    
    self.latitude = [lat doubleValue];
    self.longitude = [lon doubleValue];
    
    NSLog(@"lon:%f, lat:%f", self.longitude, self.latitude);
    
    //反编码
    [self reverseGeocoder:currentLocation];
}

#pragma mark - 反编码
- (void)reverseGeocoder:(CLLocation *)currentLocation {
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error || placemarks.count == 0) {
            NSLog(@"error == %@", error);
        }else {
            CLPlacemark *placemark = placemarks.firstObject;
            
            NSString *locationCity = [[placemark addressDictionary] objectForKey:@"City"];
            if (![locationCity isEqualToString:self.cityName]) {
                self.cityName = locationCity;
                
                if ([locationCity containsString:@"长沙"]) {
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"6",@"cityid",@"长沙",@"cityname", nil];
                    [UserDefaults setObject:dic forKey:kLocationAction];
                }else if ([locationCity containsString:@"南昌"]) {
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"12",@"cityid",@"南昌",@"cityname", nil];
                    [UserDefaults setObject:dic forKey:kLocationAction];
                }else {
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"6",@"cityid",@"长沙",@"cityname", nil];
                    [UserDefaults setObject:dic forKey:kLocationAction];
                    
                    [PromtView showAlert:@"你所在的城市暂未开通，使用默认城市长沙市" duration:1.5];
                }
            }
            
            //定位成功，发送通知
            [NotificationCenters postNotificationName:kLocationSuccess object:nil];
        }
    }];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"定位失败");
    [PromtView showAlert:@"定位失败，使用默认城市长沙市" duration:1.5];
}

#pragma mark - 判断登录是否过期
- (void)judgeTokenTime {
    /*	status:	状态
     msg:	消息内容
     token:	新的用户token，保持用户登录状态，你懂的*/
    
    NSString *tokenStr = self.user.token;
    
    NSString *randomString = [BaseFunction ret32bitString];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", [BaseFunction getTimeSp]];
    NSString *md5String = [[BaseFunction md5Digest:[NSString stringWithFormat:@"%@%@%@", timeSp, randomString, APPSIGN]] uppercaseString];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:tokenStr,@"token",
                            md5String,@"sign",
                            timeSp,@"time",
                            randomString,@"nonce_str",nil];
    
    [DataService http_Post:IS_USERFUL parameters:params success:^(id responseObject) {
        if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
            //替换token值
            NSString *tokenString = [responseObject objectForKey:@"token"];
            self.user.token = tokenString;
        }else {
            //改变登录状态,保存token值
            self.user = nil;
            [PromtView showMessage:@"登录已失效" duration:1.5];
        }
    } failure:^(NSError *error) {
        self.user = nil;
        [PromtView showMessage:@"似乎已断开与互联网的连接，请检查网络！" duration:1.5];
    }];
}


@end
