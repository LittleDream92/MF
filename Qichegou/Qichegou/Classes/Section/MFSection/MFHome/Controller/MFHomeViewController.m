//
//  MFHomeViewController.m
//  Qichegou
//
//  Created by Meng Fan on 16/9/21.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "MFHomeViewController.h"
#import "AppDelegate.h"

#import "HomeBannerCell.h"
#import "HomeMenuCell.h"
#import "HomeCarCell.h"
#import "HomeOperationCell.h"

static NSString *const homeBannerCellID = @"homeBannerCellID";
static NSString *const homeMenuCellID = @"homeMenuCellID";
static NSString *const homeCarCellID = @"homeCarCellID";

@interface MFHomeViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MFHomeViewController

-(void)dealloc {
    [NotificationCenters removeObserver:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //接收通知
    [NotificationCenters addObserver:self selector:@selector(locationSuccess:) name:kLocationSuccess object:nil];
    
    [self setUpViews];
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
        _tableView.backgroundColor = [UIColor darkGrayColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}


#pragma mark - action
//location Action
- (void)locationSuccess:(NSNotification *)not {
    NSLog(@"title:%@", [UserDefaults objectForKey:kCITYNAME]);
    NSLog(@"lat:%f\n---lon:%f\n, address:%@", MyApp.latitude, MyApp.longitude, MyApp.address);
}

//menu Action
- (void)menuActionWithCell:(HomeMenuCell *)cell {
    
    cell.clickBrandBtn = ^{
        NSLog(@"brandBtn");
    };
    
    cell.clickSaleBtn = ^ {
        NSLog(@"saleBtn");
    };
    
    cell.clickDaiBtn = ^ {
        NSLog(@"daiBtn");
    };
    
    cell.clickXianBtn = ^ {
        NSLog(@"xianBtn");
    };
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0 ? 2 : 10);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            HomeBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:homeBannerCellID];
            
            if (cell == nil) {
                cell = [[HomeBannerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:homeBannerCellID];
            }
            
            
            return cell;
        }else {
            HomeMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:homeMenuCellID];
            
            if (cell == nil) {
                cell = [[HomeMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:homeMenuCellID];
            }
            
            //action
            [self menuActionWithCell:cell];
            
            return cell;
        }
    }else {
        if (indexPath.row == 0) {
            HomeOperationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moreCellID"];
            
            if (cell == nil) {
                cell = [[HomeOperationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"moreCellID"];
            }
            
            [[cell.moreBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                NSLog(@"moreBtn");
            }];
            
            return cell;
            
        }else {
            HomeCarCell *cell = [tableView dequeueReusableCellWithIdentifier:homeCarCellID];
            
            if (cell == nil) {
                cell = [[HomeCarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:homeCarCellID];
            }
            
            cell.model = nil;
            
            [[cell.buyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                NSLog(@"buyCar");
            }];
            
            return cell;
            
        }
    }
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return indexPath.row == 0 ? 180 : 80;
    }else {
        return indexPath.row == 0 ? 50 : 100;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? CGFLOAT_MIN : 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row != 0) {
        NSLog(@"selected salecar");
    }
}


#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
