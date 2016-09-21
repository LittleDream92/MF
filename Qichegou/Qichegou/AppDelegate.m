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

@interface AppDelegate ()

@property (nonatomic, strong) CLLocationManager *locationManager;   //定位

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [DKBaseTabbarController new];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //定位
    [self location];
    
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
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    //终止:当用户按下按钮，或者关机，程序都会被终止。当一个程序将要正常终止时会调用 applicationWillTerminate 方法。但是如果长主按钮强制退出，则不会调用该方法。这个方法该执行剩下的清理工作，比如所有的连接都能正常关闭，并在程序退出前执行任何其他的必要的工作：
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
            //            [self location];
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
        self.locationManager = [[CLLocationManager alloc] init];
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            [_locationManager requestWhenInUseAuthorization];
        }
        //设置代理
        [self.locationManager setDelegate:self];
        //设置定位精度
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyThreeKilometers];
        //设置距离筛选
        [self.locationManager setDistanceFilter:100];
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
    [NotificationCenters postNotificationName:kLocationSuccess object:nil];
    
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
            NSLog(@"placemarks:%@ %@", [[placemark addressDictionary] objectForKey:@"City"], [[[placemark addressDictionary] objectForKey:@"FormattedAddressLines"] objectAtIndex:0]);
            
            [UserDefaults setObject:[[placemark addressDictionary] objectForKey:@"City"] forKey:kCITYNAME];
            self.address = [NSString stringWithFormat:@"%@", [[[placemark addressDictionary] objectForKey:@"FormattedAddressLines"] objectAtIndex:0]];
//            [NotificationCenters postNotificationName:kLocationSuccess object:nil];
        }
        
    }];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"定位失败");
}


@end
