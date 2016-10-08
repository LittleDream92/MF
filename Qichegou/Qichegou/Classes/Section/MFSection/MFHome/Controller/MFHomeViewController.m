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
        [self saleRequest];
        
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

#pragma mark - action
//location Action
- (void)locationSuccess:(NSNotification *)not {
    NSLog(@"title:%@", [UserDefaults objectForKey:kCITYNAME]);
    NSLog(@"lat:%f\n---lon:%f\n, address:%@", MyApp.latitude, MyApp.longitude, MyApp.address);
    
    NSString *city = [UserDefaults objectForKey:kCITYNAME];
    if ([city containsString:@"长沙"]) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"6",@"cityid",@"长沙",@"cityname", nil];
        [UserDefaults setObject:dic forKey:kLocationAction];
    }else if ([city containsString:@"南昌"]) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"12",@"cityid",@"南昌",@"cityname", nil];
        [UserDefaults setObject:dic forKey:kLocationAction];
    }else {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"6",@"cityid",@"长沙",@"cityname", nil];
        [UserDefaults setObject:dic forKey:kLocationAction];
        
        //提示所在城市没有业务，默认长沙
        [self presentAlertViewWithString:@"你所在的城市暂未开通，使用默认城市长沙市"];
    }
    
    self.cityDic = [UserDefaults objectForKey:kLocationAction];

}

//menu Action
- (void)menuActionWithCell:(HomeMenuCell *)cell {
    
    cell.clickBrandBtn = ^{
        NSLog(@"brandBtn");
        MFBrandViewController *brandVC = [[MFBrandViewController alloc] init];
        brandVC.cityDic = self.cityDic;
        [self.navigationController pushViewController:brandVC animated:YES];
    };
    
    cell.clickSaleBtn = ^ {
        NSLog(@"saleBtn");
        [self pushToSaleController];
    };
    
    cell.clickDaiBtn = ^ {
        NSLog(@"daiBtn");
        DKBaoDanViewController *xianVC = [[DKBaoDanViewController alloc] init];
        [self.navigationController pushViewController:xianVC animated:YES];
    };
    
    cell.clickXianBtn = ^ {
        NSLog(@"xianBtn");
        DKMainWebViewController *webViewController = [[DKMainWebViewController alloc] init];
        webViewController.title = @"洗车";
//            webViewController.webString = @"http://test.tangxinzhuan.com/api/XiChe";
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
//    saleVC.saleArray = self.saleArr;
    [self.navigationController pushViewController:saleVC animated:YES];
}

- (void)contrlClickAction:(CityControl *)cityCtrl {
    DKCityTableViewController *cityVC = [[DKCityTableViewController alloc] init];
    DKBaseNaviController *nav = [[DKBaseNaviController alloc] initWithRootViewController:cityVC];
    [self presentViewController:nav animated:YES completion:nil];
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

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 1 && indexPath.row != 0) {
//        NSLog(@"selected salecar");
//        
//        CarModel *model = self.saleArr[indexPath.row];
//        
//        MFSaleDetailViewController *saleDetailVC = [[MFSaleDetailViewController alloc] init];
//        saleDetailVC.title = [NSString stringWithFormat:@"%@%@", model.brand_name, model.pro_subject];
//        saleDetailVC.carID = model.car_id;
//        [self.navigationController pushViewController:saleDetailVC animated:YES];
//    }
//}

#pragma mark - saleRequest
- (void)saleRequest {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.cityDic[@"cityid"],@"cityid", nil];
    [DataService http_Post:SALECAR parameters:params success:^(id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
//                    NSLog(@"sale:%@", responseObject);
            NSArray *saleCars = responseObject[@"tejiache"];
            if ([saleCars isKindOfClass:[NSArray class]] && saleCars.count>0) {
                //
                NSMutableArray *mArr = [NSMutableArray array];
                for (NSDictionary *jsonDic in saleCars) {
                    
                    CarModel *model = [[CarModel alloc] initContentWithDic:jsonDic];
                    [mArr addObject:model];
                }
                self.saleArr = mArr;
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            }else {
                [PromtView showMessage:@"当前城市暂无特价车" duration:1.5];
            }
        }else {
            [PromtView showMessage:responseObject[@"msg"] duration:1.5];
        }
    } failure:^(NSError *error) {
        [PromtView showMessage:PromptWord duration:1.5];
    }];
}

@end
