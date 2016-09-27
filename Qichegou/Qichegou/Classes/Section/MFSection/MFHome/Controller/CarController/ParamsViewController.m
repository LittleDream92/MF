//
//  ParamsViewController.m
//  QiChegou
//
//  Created by Meng Fan on 16/7/21.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "ParamsViewController.h"

static NSString *const identifier = @"ParamsCELL";
@interface ParamsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

//数据源
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *keyArr;
@property (nonatomic, strong) NSArray *valueArr;

@end

@implementation ParamsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpViews];
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setUpViews
- (void)setUpViews {
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.titleArr count];
}

- (NSInteger)
tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.keyArr[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = GRAYCOLOR;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
        cell.detailTextLabel.textColor = TEXTCOLOR;
        
    }
    
    cell.textLabel.text = self.keyArr[indexPath.section][indexPath.row];
    cell.detailTextLabel.text = self.valueArr[indexPath.section][indexPath.row];
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth-30, 30)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = GRAYCOLOR;
    titleLabel.text = self.titleArr[section];
    [headerView addSubview:titleLabel];
    
    return headerView;
}

#pragma mark - requestData
- (void)requestData {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.carID ,@"cid", nil];
    
    [DataService http_Post:PARAMSLIST
                parameters:params
                   success:^(id responseObject) {
                       NSLog(@"params success:%@", responseObject);
                       
                       if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
                           NSArray *responsArr = [responseObject objectForKey:@"params"];
                           
                           //处理参数
                           NSMutableArray *mArrTitle = [NSMutableArray array];
                           NSMutableArray *keyArray = [NSMutableArray array];
                           NSMutableArray *valueArray = [NSMutableArray array];
                           
                           for (NSDictionary *dic in responsArr) {
                               NSString *groupTitle = dic[@"group_name"];
                               [mArrTitle addObject:groupTitle];
                               
                               NSArray *keyValueArr = dic[@"params"];
                               NSMutableArray *keyArr = [NSMutableArray array];
                               NSMutableArray *valueArr = [NSMutableArray array];
                               for (NSDictionary *jsonDic in keyValueArr) {
                                   [keyArr addObject:jsonDic[@"param"]];
                                   [valueArr addObject:jsonDic[@"value"]];
                               }
                               
                               [keyArray addObject:keyArr];
                               [valueArray addObject:valueArr];
                           }
                           
                           self.titleArr = mArrTitle;
                           self.keyArr = keyArray;
                           self.valueArr = valueArray;
                           
                           [self.tableView reloadData];
                           
                       }else {
                           [PromtView showAlert:PromptWord duration:1.5];
                       }
                       
                   } failure:^(NSError *error) {
                       //
                       NSLog(@"params error:%@", error);
                       [PromtView showAlert:PromptWord duration:1.5];
                   }];
}

@end
