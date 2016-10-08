//
//  MFSettingViewController.m
//  Qichegou
//
//  Created by Meng Fan on 16/9/29.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "MFSettingViewController.h"
#import "MFFeedBackViewController.h"
#import "AppDelegate.h"

static NSString *const cellID = @"settingCellID";
@interface MFSettingViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *titleArr;
    NSArray *imgArr;
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MFSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    titleArr = @[@"清除缓存", @"反馈", @"评分", @"关于"];
    imgArr = @[@"set_d", @"set_im", @"set_f", @"set_a"];
    
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
        
        
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    NSLog(@"token%@" , [AppDelegate APP].user.token);
//    if ([[AppDelegate APP].user.token isKindOfClass:[NSNull class]]) {
        return 2;
//    }else {
//      return 1;
//    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 4 : 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:imgArr[indexPath.row]];
        cell.textLabel.text = titleArr[indexPath.row];
        cell.separatorInset = UIEdgeInsetsMake(0, -20, 0, 0);
    }else {
        cell.frame = CGRectMake(0, 0, cell.contentView.width, cell.contentView.height);
        cell.textLabel.font = H15;
        cell.textLabel.textColor = RGB(244, 0, 0);
        cell.textLabel.text = @"退出当前账号";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 1) {
        //反馈
        MFFeedBackViewController *feedBackVC = [[MFFeedBackViewController alloc] init];
        [self.navigationController pushViewController:feedBackVC animated:YES];
    }
}

#pragma mark - action


@end
