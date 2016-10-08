//
//  MFSaleViewController.m
//  QiChegou
//
//  Created by Meng Fan on 16/9/26.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "MFSaleViewController.h"
#import "SaleDetailCell.h"
#import "MFSaleDetailViewController.h"
#import "SaleViewModel.h"
#import "CarModel.h"

static NSString *const saleCellID = @"saleCellID";
@interface MFSaleViewController ()<UITableViewDelegate, UITableViewDataSource>

/** 当前页码 */
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataArr;


@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) SaleViewModel *viewModel;

@end

@implementation MFSaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self setUpViewModel];
    [self setUpNav];
    [self setUpViews];
    [self setRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setUpViews
//- (void)setUpViewModel {
//    NSLog(@"%@", self.dataArr);
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
//}

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

- (void)setRefresh {
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getNewData)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
}

#pragma mark - lazyloading 
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.rowHeight = 145;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
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
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SaleDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:saleCellID];
    
    if (cell == nil) {
        cell = [[SaleDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:saleCellID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.carModel = self.dataArr[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MFSaleDetailViewController *saleDetailVC = [[MFSaleDetailViewController alloc] init];
    CarModel *model = self.dataArr[indexPath.row];
    saleDetailVC.title = [NSString stringWithFormat:@"%@%@", model.brand_name, model.pro_subject];
    saleDetailVC.carID = model.car_id;
    [self.navigationController pushViewController:saleDetailVC animated:YES];
}


#pragma mark - get data
- (void)getNewData {
    self.page = 1;
    //清空
    [self.dataArr removeAllObjects];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"cityid"] = [UserDefaults objectForKey:kLocationAction][@"cityid"];;
    
    NSLog(@"params:%@", params);
    [DataService http_Post:SALECAR
                parameters:params
                   success:^(id responseObject) {
//                       NSLog(@"list : %@", responseObject);
                       if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
                           NSArray *jsonArr = [responseObject objectForKey:@"tejiache"];
                           if ([jsonArr isKindOfClass:[NSArray class]] && jsonArr.count>0) {
                               NSMutableArray *mArr = [NSMutableArray array];
                               for (NSDictionary *jsonDic in jsonArr) {
                                   CarModel *model = [[CarModel alloc] initContentWithDic:jsonDic];
                                   [mArr addObject:model];
                               }
                               if (mArr) {
                                   self.dataArr = mArr;
                                   [self.tableView reloadData];
                                   [self.tableView.mj_header endRefreshing];
                               }
                           }else {
                               [PromtView showMessage:@"当前城市暂无特价车" duration:1.5];
                               [self.tableView.mj_header endRefreshing];
                           }
                       }else {
                           [PromtView showAlert:responseObject[@"msg"] duration:1.5];
                           [self.tableView.mj_header endRefreshing];
                       }
                   } failure:^(NSError *error) {
                       [PromtView showAlert:PromptWord duration:1.5];
                       [self.tableView.mj_header endRefreshing];
                   }];
}

- (void)getMoreData {
    self.page += 1;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"cityid"] = [UserDefaults objectForKey:kLocationAction][@"cityid"];
    params[@"page"] = [NSString stringWithFormat:@"%ld", (long)self.page];
    
//    NSLog(@"params:%@", params);
    [DataService http_Post:SALECAR
                parameters:params
                   success:^(id responseObject) {
//                      NSLog(@"特价车more : %@", responseObject);
                       if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
                           NSArray *jsonArr = [responseObject objectForKey:@"tejiache"];
                           if ([jsonArr isKindOfClass:[NSArray class]] && jsonArr.count>0) {
                               NSMutableArray *mArr = [NSMutableArray array];
                               for (NSDictionary *jsonDic in jsonArr) {
                                   CarModel *model = [[CarModel alloc] initContentWithDic:jsonDic];
                                   [mArr addObject:model];
                               }
                               NSArray *moreArr = mArr;
                               if (moreArr) {
                                   [self.dataArr addObjectsFromArray:moreArr];
                                   [self.tableView reloadData];
                               }else {
                                   [PromtView showAlert:@"加载完毕" duration:1.5];
                               }
                               [self.tableView.mj_footer endRefreshing];
                           }
                       }else {
                           [PromtView showMessage:responseObject[@"msg"] duration:1.5];
                       }
                   } failure:^( NSError *error) {
                       [PromtView showAlert:PromptWord duration:1.5];
                   }];
    
}

@end
