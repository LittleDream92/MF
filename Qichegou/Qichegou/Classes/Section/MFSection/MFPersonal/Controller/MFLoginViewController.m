//
//  MFLoginViewController.m
//  Qichegou
//
//  Created by Meng Fan on 16/9/23.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "MFLoginViewController.h"

@interface MFLoginViewController ()

@property (nonatomic, strong) UIButton *changeBtn;

@end

@implementation MFLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNav];
    [self setUpViews];
    [self setUpAction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setUp
- (void)setUpNav {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"登录";
    [self navBack:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.changeBtn];
}

- (void)setUpViews {
    
}

- (void)setUpAction {
    [[self.changeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"验证码登录");
    }];
}

#pragma mark - lazyloading
-(UIButton *)changeBtn {
    if (!_changeBtn) {
        _changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeBtn setTitle:@"切换" forState:UIControlStateNormal];
        _changeBtn.frame = CGRectMake(0, 0, 40, 30);
        _changeBtn.titleLabel.font = H15;
    }
    return _changeBtn;
}

@end
