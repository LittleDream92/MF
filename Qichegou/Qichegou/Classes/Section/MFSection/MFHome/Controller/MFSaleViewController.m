//
//  MFSaleViewController.m
//  QiChegou
//
//  Created by Meng Fan on 16/9/26.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "MFSaleViewController.h"
#import "SaleDetailCell.h"

#import "SaleViewModel.h"

static NSString *const saleCellID = @"saleCellID";
@interface MFSaleViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) SaleViewModel *viewModel;

@end

@implementation MFSaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpViewModel];
    [self setUpNav];
    [self setUpViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setUpViews
- (void)setUpViewModel {
    NSLog(@"%@", self.saleArray);
//    if (![self.saleArray isKindOfClass:[NSArray class]]) {
//        NSLog(@"null");
//        
//        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"6",@"cityid", nil];
//        RACSignal *saleSignal = [self.viewModel.saleCommand execute:params];
//        [saleSignal subscribeNext:^(id x) {
//            NSLog(@"x: %@", x);
//            self.saleArray = x;
//            [self.tableView reloadData];
//        }];
//    }
}

- (void)setUpNav {
    self.title = @"特价购车";
    [self navBack:YES];
}

- (void)setUpViews {
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark - lazyloading 
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.rowHeight = 160;
    }
    return _tableView;
}

-(SaleViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SaleViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark - action


#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.saleArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SaleDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:saleCellID];
    
    if (cell == nil) {
        cell = [[SaleDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:saleCellID];
    }
    
    cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    cell.carModel = self.saleArray[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate


@end
