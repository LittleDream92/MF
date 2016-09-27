//
//  MFSaleDetailViewController.m
//  Qichegou
//
//  Created by Meng Fan on 16/9/27.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "MFSaleDetailViewController.h"

@interface MFSaleDetailViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *buyBtn;

@end

@implementation MFSaleDetailViewController

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
}

- (void)setUpViews {
    WEAKSELF
    [self.view addSubview:self.buyBtn];
    [self.buyBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.bottom.equalTo(-15);
        make.height.equalTo(40);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(0);
        make.bottom.equalTo(weakSelf.buyBtn.mas_top).offset(-20);
    }];
}


#pragma mark - lazyloading
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        
        _tableView.backgroundColor = BGGRAYCOLOR;
    }
    return _tableView;
}

-(UIButton *)buyBtn {
    if (!_buyBtn) {
        _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buyBtn setTitle:@"立即下单" forState:UIControlStateNormal];
        _buyBtn.backgroundColor = [UIColor blueColor];
        _buyBtn.titleLabel.font = H15;
    }
    return _buyBtn;
}

#pragma mark - action


@end
