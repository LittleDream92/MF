//
//  DKCarListViewController.m
//  Qichegou
//
//  Created by Meng Fan on 16/4/20.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DKCarListViewController.h"
#import "CarListTableViewCell.h"
//#import "MFCarDetailViewController.h"
#import "MFDetailCarViewController.h"
#import "CarModel.h"

static NSString *const cellID = @"carListCellID";
@interface DKCarListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;
/** 当前页码 */
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation DKCarListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNav];
    [self setUpViews];
    [self setRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - setUpViews
- (void)setUpNav {
    [self navBack:YES];
    self.title = @"选车型";
}

- (void)setUpViews {
    
    [self.view addSubview:self.tableview];
    [self.tableview makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.tableview.tableFooterView = [UIView new];
    
    //注册单元格
    [self.tableview registerNib:[UINib nibWithNibName:@"CarListTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
}

- (void)setRefresh {
    
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getNewData)];
    [self.tableview.mj_header beginRefreshing];
    
    self.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
}

#pragma mark - setting and getting
-(UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] init];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        
        _tableview.rowHeight = 80;
        _tableview.pagingEnabled = YES;
        
        _tableview.showsVerticalScrollIndicator = NO;
    }
    return _tableview;
}

-(NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

#pragma mark -UITableView  DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArr count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CarListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.myModel = self.dataArr[indexPath.row];
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //push进入详细选车页面
    MFDetailCarViewController *detailCarVC = [[MFDetailCarViewController alloc] init];
    CarModel *model = self.dataArr[indexPath.row];
    detailCarVC.cid = model.car_id;
    [self.navigationController pushViewController:detailCarVC animated:YES];
}

#pragma mark - get data
- (void)getNewData {
    self.page = 1;
    //清空
    [self.dataArr removeAllObjects];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"cityid"] = [UserDefaults objectForKey:kLocationAction][@"cityid"];
    
    if (self.pid.length == 0) {
        params[@"min"] = self.minPrice;
        params[@"max"] = self.maxPrice;
        params[@"mid"] = self.modelID;
    }else {
        params[@"pid"] = self.pid;
    }
    
//    NSLog(@"params:%@", params);
    [DataService http_Post:CARLIST
                parameters:params
                   success:^(id responseObject) {
                       NSLog(@"list : %@", responseObject);
                       if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
                           NSArray *jsonArr = [responseObject objectForKey:@"cars"];
                           NSMutableArray *mArr = [NSMutableArray array];
                           for (NSDictionary *jsonDic in jsonArr) {
                               CarModel *model = [[CarModel alloc] initContentWithDic:jsonDic];
                               [mArr addObject:model];
                           }
                           if (mArr) {
                               self.dataArr = mArr;
                               [self.tableview reloadData];
                               [self.tableview.mj_header endRefreshing];
                           }
                       }else {
                           [self.tableview.mj_header endRefreshing];
                           [PromtView showAlert:responseObject[@"msg"] duration:1.5];
                       }
                   } failure:^(NSError *error) {
                       [self.tableview.mj_header endRefreshing];
                       [PromtView showAlert:PromptWord duration:1.5];
                   }];
}

- (void)getMoreData {
    self.page += 1;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"cityid"] = [UserDefaults objectForKey:kLocationAction][@"cityid"];
    params[@"page"] = [NSString stringWithFormat:@"%ld", (long)self.page];
    
    if (self.pid.length == 0) {
        params[@"min"] = self.minPrice;
        params[@"max"] = self.maxPrice;
        params[@"mid"] = self.modelID;
    }else {
        params[@"pid"] = self.pid;
    }
    
    NSLog(@"params:%@", params);
    [DataService http_Post:CARLIST
                parameters:params
                   success:^(id responseObject) {
//                       NSLog(@"list : %@", responseObject);
                       if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
                           NSArray *jsonArr = [responseObject objectForKey:@"cars"];
                           if ([jsonArr isKindOfClass:[NSArray class]] && jsonArr.count > 0) {
                               NSMutableArray *mArr = [NSMutableArray array];
                               for (NSDictionary *jsonDic in jsonArr) {
                                   CarModel *model = [[CarModel alloc] initContentWithDic:jsonDic];
                                   [mArr addObject:model];
                               }
                               NSArray *moreArr = mArr;
                               if (moreArr) {
                                   
                                   [self.dataArr addObjectsFromArray:moreArr];
                                   [self.tableview reloadData];
                                   [self.tableview.mj_footer endRefreshing];
                               }else {
                                   [self.tableview.mj_footer endRefreshing];
                                   [PromtView showMessage:@"加载完毕" duration:1.5];
                               }
                           }else {
                               
                               [PromtView showMessage:@"没有更多数据" duration:1.5];
                               [self.tableview.mj_footer endRefreshing];
                           }
                       }else {
                            [self.tableview.mj_header endRefreshing];
                           [PromtView showMessage:responseObject[@"msg"] duration:1.5];
                       }
                   } failure:^( NSError *error) {
                       [self.tableview.mj_header endRefreshing];
                       [PromtView showAlert:PromptWord duration:1.5];
                   }];

}

@end
