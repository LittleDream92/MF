//
//  DKBaoDanViewController.m
//  Qichegou
//
//  Created by Meng Fan on 16/6/16.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DKBaoDanViewController.h"
#import "BaoDanTableViewCell.h"
#import "DKBaoDetailViewController.h"
#import "InsuranceModel.h"

#import "PurchesProcessView.h"

@interface DKBaoDanViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *titleArr;
    NSArray *imgArr;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footerView;

@end

@implementation DKBaoDanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpData];
    [self setNav];
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - lazyloading
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.scrollEnabled = NO;
        
        _tableView.rowHeight = 75;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

-(UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] init];
        
        _footerView.backgroundColor = white_color;
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 6, 0, 0)];
        textLabel.font = [UIFont boldSystemFontOfSize:15];
        textLabel.textColor = TEXTCOLOR;
        textLabel.text = @"购买流程";
        [textLabel sizeToFit];
        [_footerView addSubview:textLabel];
        
        PurchesProcessView *prossView = [[[NSBundle mainBundle] loadNibNamed:@"PurchesProcessView" owner:self options:nil] lastObject];
        prossView.frame = CGRectMake(0, 30, kScreenWidth, 100);
        [_footerView addSubview:prossView];
    }
    return _footerView;
}

#pragma mark - setupView
- (void)setUpData {
    titleArr = @[@"24小时服务热线95511", @"24小时服务热线95519", @"24小时服务热线95518"];
    imgArr = @[@"baodan_P", @"baodan_R", @"baodan_Z"];
}

- (void)setNav {
    self.title = @"保单查询";
    [self navBack:YES];
}

- (void)setupView {
    [self.view addSubview:self.footerView];
    [self.view addSubview:self.tableView];
    
    WEAKSELF
    [self.footerView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.height.equalTo(130);
    }];
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(0);
        make.bottom.equalTo(weakSelf.footerView.mas_top);
    }];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaoDanTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"BaoDanTableViewCell" owner:self options:nil] lastObject];
    
    cell.imageView.image = [UIImage imageNamed:imgArr[indexPath.row]];
    cell.label.text = titleArr[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DKBaoDetailViewController *detailVC = [[DKBaoDetailViewController alloc] init];
    detailVC.title = @"保单查询";
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
