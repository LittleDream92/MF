//
//  DKCarProViewController.m
//  Qichegou
//
//  Created by Meng Fan on 16/4/15.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DKCarProViewController.h"
#import "CarProTableViewCell.h"
#import "DKCarListViewController.h"

@interface DKCarProViewController ()


@end

@implementation DKCarProViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择车系";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupTableView];
    [self getNewData];
    
}

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
