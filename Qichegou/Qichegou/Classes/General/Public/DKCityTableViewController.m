//
//  DKCityTableViewController.m
//  Qichegou
//
//  Created by Meng Fan on 16/3/16.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DKCityTableViewController.h"
#import "OtherModel.h"
#import "UIView+Extension.h"

#define kCityCellIndex @"cityCellIndexKey"  //定位城市，userDefault写入选择的城市下标的key

static NSString *const CellID = @"cityLocationCellID";
@interface DKCityTableViewController ()

@end

@implementation DKCityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //设置标题和背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"切换城市";
    
    NSDictionary *dic = [UserDefaults objectForKey:kLocationAction];
    if (![[dic objectForKey:@"cityid"] isEqualToString:@"6"]) {
        
        NSUInteger myIndex = [[UserDefaults objectForKey:kCityCellIndex] integerValue];
        self.lastIndexPath = [NSIndexPath indexPathForRow:myIndex inSection:0];
        
    }else {
        
        self.lastIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    }

    [self createViews];
    [self dataRequest];
}

#pragma mark - createViews
- (void)createViews {
    //*******************初始化导航栏的关闭按钮**************************
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(0, 0, 40, 40);
    [closeBtn createButtonWithBGImgName:nil bghighlightImgName:nil titleStr:@"关闭" fontSize:17];
    [closeBtn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeBtn];
    
    self.tableView.sectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = 39;

    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - Click Action methods
- (void)btnClickAction:(UIButton *)btn {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - http request
- (void)dataRequest {
    [DataService http_Post:CITY_LIST
                parameters:nil
                   success:^(id responseObject) {
                       
                       NSLog(@"citys:%@ -> msg:%@", responseObject, [responseObject objectForKey:@"msg"]);
                       
                       NSDictionary *myDic = responseObject;
                       if ([[myDic objectForKey:@"status"] integerValue] == 1) {
                           
                           NSArray *jsonArr = [myDic objectForKey:@"citys"];
                           NSMutableArray *mArr = [NSMutableArray array];
                           for (NSDictionary *jsonDic in jsonArr) {
                               
                               OtherModel *model = [[OtherModel alloc] initContentWithDic:jsonDic];
                               [mArr addObject:model];
                           }
                           self.dataArray = mArr;
                           [self.tableView reloadData];
                       }else {
                           NSLog(@"城市列表请求失败:%@", responseObject[@"msg"]);
                           [PromtView showMessage:responseObject[@"msg"] duration:1.5];
                       }
                       
                   } failure:^(NSError *error) {
                       
                       NSLog(@"citys error:%@", error);
                       [PromtView showMessage:PromptWord duration:1.5];
                   }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cityCell = [tableView dequeueReusableCellWithIdentifier:CellID];
    //防止复用残留
    cityCell.imageView.image = nil;
    
    if (cityCell == nil) {
        //初始化
        cityCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
        
        //初始化标记视图
        _checkmarkImgView = [UIImageView new];
        _checkmarkImgView.tag = 120;
        _checkmarkImgView.image = [UIImage imageNamed:@"icon_check"];
        [cityCell.contentView addSubview:_checkmarkImgView];
        
        _checkmarkImgView.size = [UIImage imageNamed:@"icon_check"].size;
        _checkmarkImgView.centerY = 44/2;
        _checkmarkImgView.x = kScreenWidth - 25;
    }
    
    if (indexPath != self.lastIndexPath) {
        _checkmarkImgView.hidden = YES;
    }
    
    OtherModel *model = self.dataArray[indexPath.row];
    cityCell.textLabel.text = model.city_name;
    
    return cityCell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 39)];
    titleView.backgroundColor = [UIColor clearColor];
    
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:titleView.bounds];
    bgImgView.image = [UIImage imageNamed:@"bg_section"];
    [titleView addSubview:bgImgView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 300, 39)];
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel createLabelWithFontSize:18 color:[UIColor lightGrayColor]];

    titleLabel.text = @"全部城市(更多城市正在开通)";
    [titleView addSubview:titleLabel];
    
    return titleView;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /*取到上次选择的，隐藏标记视图*/
    UITableViewCell *oldCityCell = [tableView cellForRowAtIndexPath:self.lastIndexPath];
    UIImageView *oldCheckImgView = [oldCityCell viewWithTag:120];
    oldCheckImgView.hidden = YES;
    
    /*取到本次选择的，显示标记视图*/
    UITableViewCell *newCityCell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *newCheckImgView = [newCityCell viewWithTag:120];
    newCheckImgView.hidden = NO;
    
    self.lastIndexPath = indexPath;
    
    //关闭页面
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - view methods
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    OtherModel *cityModel = self.dataArray[self.lastIndexPath.row];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:cityModel.city_id,@"cityid",
                         cityModel.city_name,@"cityname", nil];
    [UserDefaults setObject:dic forKey:kLocationAction];
    
    //存储下标
    NSNumber *index = [NSNumber numberWithLong:self.lastIndexPath.row];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:index forKey:kCityCellIndex];
    
}

@end
