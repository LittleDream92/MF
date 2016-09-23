//
//  MFFindPwdViewController.m
//  Qichegou
//
//  Created by Meng Fan on 16/9/23.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "MFFindPwdViewController.h"

@interface MFFindPwdViewController ()

@end

@implementation MFFindPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setUp
- (void)setUpNav {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"修改密码";
    [self navBack:YES];
}
@end
