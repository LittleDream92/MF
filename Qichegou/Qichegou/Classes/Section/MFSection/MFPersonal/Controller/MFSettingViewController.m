//
//  MFSettingViewController.m
//  Qichegou
//
//  Created by Meng Fan on 16/9/29.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "MFSettingViewController.h"

@interface MFSettingViewController ()

@end

@implementation MFSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNav];
    [self setUpViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setUpViews
- (void)setUpNav {
    [self navBack:YES];
    self.title = @"设置";
}

- (void)setUpViews {
    
}

@end
