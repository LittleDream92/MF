//
//  MFSettingViewController.m
//  Qichegou
//
//  Created by Meng Fan on 16/9/29.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "MFSettingViewController.h"
#import "MFFeedBackViewController.h"
#import "MFAboutViewController.h"
#import "AppDelegate.h"

#import "SettingViewModel.h"

static NSString *const cellID = @"settingCellID";
@interface MFSettingViewController ()<UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SettingViewModel *viewModel;

@end

@implementation MFSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNav];
    [self setUpViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setUpViews
- (void)setUpNav {
    [self navBack:YES];
    self.title = @"设置";
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

-(SettingViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SettingViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if ([AppDelegate APP].user) {
        return 2;
    }else {
      return 1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 4 : 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"clearCahceCell"];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"clearCahceCell"];
            }
            
            cell.separatorInset = UIEdgeInsetsMake(0, -20, 0, 0);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.imageView.image = [UIImage imageNamed:self.viewModel.imgArr[indexPath.row]];
            cell.textLabel.text = self.viewModel.titleArr[indexPath.row];
            NSLog(@"%f", self.viewModel.cacheSize);
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1fM",self.viewModel.cacheSize];
            
            return cell;

        }else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.imageView.image = [UIImage imageNamed:self.viewModel.imgArr[indexPath.row]];
            cell.textLabel.text = self.viewModel.titleArr[indexPath.row];
            cell.separatorInset = UIEdgeInsetsMake(0, -20, 0, 0);
            
            return cell;
        }
    }else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"loginOutCell"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"loginOutCell"];
        }
    
        cell.textLabel.font = H15;
        cell.textLabel.textColor = RGB(244, 0, 0);
        cell.textLabel.text = @"退出当前账号";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        UITableViewCell *cacheCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if ([cacheCell.detailTextLabel.text isEqualToString:@"0.0M"]) {
            [PromtView showAlert:@"暂无缓存" duration:1.5];
        }else {
            
            //确定清除缓存
            [self.viewModel clearCacheAction];
            NSLog(@"%.1f _countcache", self.viewModel.cacheSize);
            
            //刷新tableView
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
            [PromtView showMessage:@"已清除缓存" duration:1.5];
        }
    }else if (indexPath.row == 1) {
        //反馈
        MFFeedBackViewController *feedBackVC = [[MFFeedBackViewController alloc] init];
        [self.navigationController pushViewController:feedBackVC animated:YES];
    }else if (indexPath.row == 2) {
        //评分
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:QCGURL]];
    }else if (indexPath.row == 3) {
        //关于
        MFAboutViewController *aboutVC = [[MFAboutViewController alloc] init];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }else if (indexPath.section == 1)  {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"确定退出登录" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"取消");
        }];
        
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"确定退出");
            NSLog(@"controller:%@", [AppDelegate APP].user.token);
            
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[AppDelegate APP].user.token ,@"token", nil];
            RACSignal *signal = [self.viewModel.loginOutCommand execute:params];
            [signal subscribeNext:^(id x) {
                NSString *result = x;
                if ([result isEqualToString:@"YES"]) {
                    [self.tableView reloadData];
                    [PromtView showMessage:@"已退出当前登录账号" duration:1.5];
                }
            }];
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - action

@end
