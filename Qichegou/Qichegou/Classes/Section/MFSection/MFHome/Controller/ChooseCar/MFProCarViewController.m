//
//  MFProCarViewController.m
//  Qichegou
//
//  Created by Meng Fan on 16/9/27.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "MFProCarViewController.h"
//#import "ProViewModel.h"
//#import "CarProTableViewCell.h"

#import "CarProTableViewCell.h"
#import "DKCarListViewController.h"

static NSString *const cellID = @"carProCellID";
@interface MFProCarViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

//@property (nonatomic, strong) ProViewModel *viewModel;

@end

@implementation MFProCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择车系";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupTableView];
    [self getNewData];
    
    
//    [self setUpNav];
//    [self setUpViews];
//    [self combineViewModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - setUpViews
//- (void)setUpNav {
//    [self navBack:YES];
//    
//    self.title = @"品牌或者条件选车";
//}
//
//- (void)setUpViews {
//    [self.view addSubview:self.tableview];
//    [self.tableview makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
//    }];
//    
//    self.tableview.tableFooterView = [[UIView alloc] init];
//}
//
//- (void)combineViewModel {
//    NSLog(@"pro iD:%@", self.proID);
//    
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"pid"] = self.proID;
//    params[@"cityid"] = [UserDefaults objectForKey:kLocationAction][@"cityid"];
//    NSLog(@"params: %@", params);
//    RACSignal *signal = [self.viewModel.carProCommand execute:params];
//    [signal subscribeNext:^(id x) {
//        NSLog(@"list action :%@", x);
//    }];
//}
//
//#pragma mark - lazyloading
//-(ProViewModel *)viewModel {
//    if (!_viewModel) {
//        _viewModel = [[ProViewModel alloc] init];
//    }
//    return _viewModel;
//}
//
//-(UITableView *)tableview {
//    if (!_tableview) {
//        _tableview = [[UITableView alloc] init];
//        
//        _tableview.delegate = self;
//        _tableview.dataSource = self;
//        
//    }
//    return _tableview;
//}
//
//#pragma mark - action
//
//
//
//#pragma mark - UITableViewDataSource
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 5;
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//    }
//    
//    cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
//    
//    return cell;
//}
//
//
//#pragma mark - UITableViewDelegate
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//}

- (void)setupTableView {
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = 100;
    
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - setting and getting

-(UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - tableview dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CarProTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"CarProTableViewCell" owner:self options:nil] lastObject];
    
    cell.model = self.dataArr[indexPath.row];
    
    return cell;
}

#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DKCarListViewController *carListVC = [[DKCarListViewController alloc] init];
    CarModel *model = self.dataArr[indexPath.row];
    carListVC.pid = model.pro_id;
    carListVC.title = model.pro_subject;
    [self.navigationController pushViewController:carListVC animated:YES];
}

#pragma mark - data
- (void)getNewData {
    //    [HttpTool requestPidCarWithbid:self.bid block:^(id json) {
    //        if (json != nil) {
    //            self.dataArr = json;
    //            [self.tableView reloadData];
    //        }
    //    }];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"6",@"cityid",
                            self.bid ,@"bid", nil];
    
    [DataService http_Post:CARPROS
                parameters:params
                   success:^(id responseObject) {
                       NSLog(@"pro list :%@", responseObject);
                       if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
                           NSArray *jsonArr = [responseObject objectForKey:@"products"];
                           NSMutableArray *mArr = [NSMutableArray array];
                           for (NSDictionary *jsonDic in jsonArr) {
                               CarModel *model = [[CarModel alloc] initContentWithDic:jsonDic];
                               [mArr addObject:model];
                           }
                           self.dataArr = mArr;
                           [self.tableView reloadData];
                       }else {
                           [PromtView showAlert:responseObject[@"msg"] duration:1.5];
                       }
                       
                   } failure:^(NSError *error) {
                       NSLog(@"pro list error:%@", error);
                       [PromtView showAlert:PromptWord duration:1.5];
                   }];
    
}

@end
