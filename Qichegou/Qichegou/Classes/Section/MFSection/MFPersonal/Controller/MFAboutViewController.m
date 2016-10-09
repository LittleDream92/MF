//
//  MFAboutViewController.m
//  Qichegou
//
//  Created by Meng Fan on 16/10/9.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "MFAboutViewController.h"

@interface MFAboutViewController ()

@end

@implementation MFAboutViewController

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
    self.title = @"关于";
}

- (void)setUpViews {
    
}

@end
