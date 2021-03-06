//
//  MFHomeViewController.m
//  QiChegou
//
//  Created by Meng Fan on 16/9/12.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "MFHomeViewController.h"
#import "AppDelegate.h"

#import "HomeHeaderView.h"
#import "HomeMenuCell.h"
#import "HomeCarCell.h"
#import "HomeOperationCell.h"

#import "DKMainWebViewController.h"
#import "DKBaoDanViewController.h"
#import "MFBrandViewController.h"
#import "MFSaleViewController.h"
#import "MFSaleDetailViewController.h"

#import "DKBaseNaviController.h"
#import "DKCityTableViewController.h"

#import "CityControl.h"
#import "CarModel.h"

#import "HomeViewModel.h"

static NSString *const homeMenuCellID = @"homeMenuCellID";
static NSString *const homeCarCellID = @"homeCarCellID";

@interface MFHomeViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) HomeHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CityControl *cityCtrl;

@property (nonatomic, strong) NSArray *saleArr;
@property (nonatomic, strong) NSDictionary *cityDic;

@property (nonatomic, strong) HomeViewModel *viewModel;

@end

@implementation MFHomeViewController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    [NotificationCenters removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //接收通知
    [NotificationCenters addObserver:self selector:@selector(locationSuccess:) name:kLocationSuccess object:nil];
    
    [self setUpNav];
    [self setUpViews];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSDictionary *newDic = [UserDefaults objectForKey:kLocationAction];
    if (![newDic isEqual:self.cityDic]) {
        self.cityDic = newDic;
        //网络请求新城市的特价车
         NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.cityDic[@"cityid"],@"cityid", nil];
         RACSignal *signal = [self.viewModel.saleCatListCommand execute:params];
        [signal subscribeNext:^(NSArray *x) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.saleArr = x;
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            });
        }];
        
        if (self.navigationItem.leftBarButtonItem.customView) {
            //取到城市label，重新赋值
            CityControl *cityCtrl = (CityControl *)self.navigationItem.leftBarButtonItem.customView;
            cityCtrl.cityLabel.text = [newDic objectForKey:@"cityname"];
        }
    }
}

#pragma mark - setUpViews
- (void)setUpNav {
    self.title = @"首页";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.cityCtrl];
}

- (void)setUpViews {
    
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    NSArray *images = @[@"home_header1", @"home_header2", @"home_header3", @"home_header4"];
    
    self.headerView = [[HomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 155)];
    [self.headerView createHeaderViewWithImages:images];
    self.tableView.tableHeaderView = self.headerView;
}

#pragma mark - lazyloading
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

-(HomeHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[HomeHeaderView alloc] init];
    }
    return _headerView;
}

-(CityControl *)cityCtrl {
    if (!_cityCtrl) {
        NSString *cityStr = [UserDefaults objectForKey:kLocationAction][@"cityname"];
        if (!cityStr) {
            cityStr = @"长沙";
        }
        
        _cityCtrl = [[CityControl alloc] initWithFrame:CGRectMake(0, 0, 90, 30) cityString:cityStr];
        [_cityCtrl addTarget:self action:@selector(contrlClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cityCtrl;
}

-(HomeViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [HomeViewModel new];
    }
    return _viewModel;
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger secondRows = MIN(8, self.saleArr.count);
    return (section == 0 ? 1 : secondRows);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
       
        HomeMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:homeMenuCellID];
        
        if (cell == nil) {
            cell = [[HomeMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:homeMenuCellID];
        }
        
        //action
        [self menuActionWithCell:cell];
        
        return cell;
        
    }else {
        if (indexPath.row == 0) {
            HomeOperationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moreCellID"];
            
            if (cell == nil) {
                cell = [[HomeOperationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"moreCellID"];
            }
            
            cell.clickMoreSaleBtn = ^ {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self pushToSaleController];
                });
            };
            
            return cell;

        }else {
            HomeCarCell *cell = [tableView dequeueReusableCellWithIdentifier:homeCarCellID];
            
            if (cell == nil) {
                cell = [[HomeCarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:homeCarCellID];
            }
            
            cell.model = self.saleArr[indexPath.row];
            
            cell.buyBtn.tag = indexPath.row;
            [cell.buyBtn addTarget:self action:@selector(saleCarDetailAction:) forControlEvents:UIControlEventTouchUpInside];
        
            return cell;
        }
   }
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 100;
    }else {
        return indexPath.row == 0 ? 40 : 115;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? CGFLOAT_MIN : 10;
}


#pragma mark - action
//location Action
- (void)locationSuccess:(NSNotification *)not {
    self.cityDic = [UserDefaults objectForKey:kLocationAction];
    
    if (![[self.cityDic objectForKey:@"cityname"] isEqualToString:@"长沙"]) {
        //拿到cityCtrl，如果不一样，重新赋值
        if (self.navigationItem.leftBarButtonItem.customView) {
            //取到城市label，重新赋值
            CityControl *cityCtrl = (CityControl *)self.navigationItem.leftBarButtonItem.customView;
            cityCtrl.cityLabel.text = [self.cityDic objectForKey:@"cityname"];
        }
    }
}

//menu Action
- (void)menuActionWithCell:(HomeMenuCell *)cell {
    
    cell.clickBrandBtn = ^{
        MFBrandViewController *brandVC = [[MFBrandViewController alloc] init];
        brandVC.cityDic = self.cityDic;
        [self.navigationController pushViewController:brandVC animated:YES];
    };
    
    cell.clickSaleBtn = ^ {
        [self pushToSaleController];
    };
    
    cell.clickDaiBtn = ^ {
        DKBaoDanViewController *xianVC = [[DKBaoDanViewController alloc] init];
        [self.navigationController pushViewController:xianVC animated:YES];
    };
    
    cell.clickXianBtn = ^ {
        DKMainWebViewController *webViewController = [[DKMainWebViewController alloc] init];
        webViewController.title = @"洗车";
        //            webViewController.webString = [NSString stringWithFormat:@"%@/api/XiChe", URL_String];
        //            webViewController.isRequest = YES;
        webViewController.webString = @"http://open.chediandian.com/xc/index?ApiKey=25fea4fca5d54a91ad935814980dd787&ApiST=1467609844&ApiSign=962ad4b142ae429ac5bdb051b958e0e8";
        webViewController.isRequest = NO;
        [self.navigationController pushViewController:webViewController animated:YES];
    };
}

- (void)saleCarDetailAction:(UIButton *)sender {
    CarModel *model = self.saleArr[sender.tag];
    
    MFSaleDetailViewController *saleDetailVC = [[MFSaleDetailViewController alloc] init];
    saleDetailVC.title = [NSString stringWithFormat:@"%@%@", model.brand_name, model.pro_subject];
    saleDetailVC.carID = model.car_id;
    [self.navigationController pushViewController:saleDetailVC animated:YES];
}

- (void)pushToSaleController {
    MFSaleViewController *saleVC = [[MFSaleViewController alloc] init];
    [self.navigationController pushViewController:saleVC animated:YES];
}

- (void)contrlClickAction:(CityControl *)cityCtrl {
    DKCityTableViewController *cityVC = [[DKCityTableViewController alloc] init];
    DKBaseNaviController *nav = [[DKBaseNaviController alloc] initWithRootViewController:cityVC];
    [self presentViewController:nav animated:YES completion:nil];
}


@end
