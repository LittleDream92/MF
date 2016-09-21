//
//  MFHomeViewController.m
//  Qichegou
//
//  Created by Meng Fan on 16/9/21.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "MFHomeViewController.h"
#import "AppDelegate.h"


@interface MFHomeViewController ()

@end

@implementation MFHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //接收通知
    [NotificationCenters addObserver:self selector:@selector(locationSuccess:) name:kLocationSuccess object:nil];
}



#pragma mark - action
//location Action
- (void)locationSuccess:(NSNotification *)not {
    NSLog(@"title:%@", [UserDefaults objectForKey:kCITYNAME]);
    NSLog(@"lat:%f\n---lon:%f\n, address:%@", MyApp.latitude, MyApp.longitude, MyApp.address);
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
