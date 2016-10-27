//
//  DKMyOrderVC.m
//  Qichegou
//
//  Created by Meng Fan on 16/4/11.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DKMyOrderVC.h"
#import "MyOrderCell.h"
#import "OrderListViewModel.h"
#import "CarOrderModel.h"

#import "DKPayMoneyVC.h"
#import "DKDetailOrderVC.h"

static NSString *const cellID = @"myOrderCell";
@interface DKMyOrderVC ()
<UITableViewDataSource,
UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UILabel *promtLabel;

@property (nonatomic, strong) OrderListViewModel *viewModel;
@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation DKMyOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNav];
    [self setUpViews];
}

#pragma  mark - setUp
- (void)setUpNav {
    [self navBack:YES];
    self.title = @"我的订单";
}

- (void)setUpViews {
    
    @weakify(self);
    [self.view addSubview:self.promtLabel];
    [self.promtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.view.mas_top).with.offset(100);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 21));
    }];
    
    //设置header和footer
    self.tableView.sectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = 12;
    //调整inset
    self.tableView.contentInset = UIEdgeInsetsMake(-22, 0, 0, 0);
    
    //注册单元格
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyOrderCell class]) bundle:nil] forCellReuseIdentifier:cellID];
}

#pragma mark - lazyloading
-(UILabel *)promtLabel {
    if (_promtLabel == nil) {
        _promtLabel = [UILabel new];
        _promtLabel.hidden = YES;
        _promtLabel.textAlignment = NSTextAlignmentCenter;
        [_promtLabel createLabelWithFontSize:16 color:RGB(221, 221, 221)];
        _promtLabel.text = @"您还没有订单呢，快去下单吧";
    }
    return _promtLabel;
}

-(OrderListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[OrderListViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark - UITableView  Data  Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    cell.completeBtn.tag = indexPath.section + 10;
    [cell.completeBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    CarOrderModel *myOrderModel = self.dataArr[indexPath.section];
    cell.model = myOrderModel;
    
    return cell;
}

#pragma mark - UITableView  delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DKDetailOrderVC *detailOrderVC = [[DKDetailOrderVC alloc] init];
    CarOrderModel *model = self.dataArr[indexPath.section];
    detailOrderVC.orderIDString = model.order_id;
    [self.navigationController pushViewController:detailOrderVC animated:YES];
}

#pragma mark - action
- (void)buttonAction:(UIButton *)button {
    
    NSInteger sectionNumber = button.tag - 10;
    CarOrderModel *model = self.dataArr[sectionNumber];
    NSLog(@"tag : %ld, orderID : %@" , (long)sectionNumber, model.order_id);
    DKPayMoneyVC *paymoneyVC = [[DKPayMoneyVC alloc] init];
    paymoneyVC.title = @"支付订金";
    paymoneyVC.orderIDString = model.order_id;
    [self.navigationController pushViewController:paymoneyVC animated:YES];
}

#pragma mark - view methods
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    RACSignal *orderListSignal = [self.viewModel.orderListCommand execute:nil];
    @weakify(self);
    [orderListSignal subscribeNext:^(id x) {
        
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            NSArray *result = x;
            if ([result isKindOfClass:[NSArray class]] && result.count > 0) {
                self.tableView.hidden = NO;
                self.promtLabel.hidden = YES;
                
                self.dataArr = x;
                [self.tableView reloadData];
            }else {
                self.tableView.hidden = YES;
                self.promtLabel.hidden = NO;
            }
        });
    }];
}

@end
