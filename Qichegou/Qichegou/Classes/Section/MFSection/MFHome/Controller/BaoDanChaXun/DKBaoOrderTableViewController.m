//
//  DKBaoOrderTableViewController.m
//  Qichegou
//
//  Created by Meng Fan on 16/6/20.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DKBaoOrderTableViewController.h"
#import "BaoDetailTableViewCell.h"
#import "BaoDetailCell.h"
#import "DetailFooterView.h"

#import "DKMainWebViewController.h"

@interface DKBaoOrderTableViewController ()

/* title数据源 */
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) DetailFooterView *footerView;

/* 数据源 */
@property (nonatomic, strong) InsuranceModel *dataModel;
@property (nonatomic, strong) NSMutableArray *mArray;

@end

@implementation DKBaoOrderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"保单详情";
    [self setClose:YES];
    
    self.mArray = [NSMutableArray array];
    
    self.titleArray = @[@[@"品牌型号", @"车架号", @"发动机号", @"车辆登记日期"],
                        @[@"姓名", @"手机号", @"证件类型", @"证件号码"],
                        @[@"保单号", @"交强险保单号", @"商业险生效日期", @"交强险生效日期"]];
    
    [self setupView];
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setupView
- (void)setupView {
    
    //设置尾视图
    
    self.footerView = [[[NSBundle mainBundle] loadNibNamed:@"DetailFooterView" owner:self options:nil]lastObject];
    UIButton *ruleBtn = (UIButton *)[self.footerView viewWithTag:112];
    [ruleBtn addTarget:self action:@selector(rulesAction:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = self.footerView;
}

#pragma mark - 响应事件
- (void)rulesAction:(UIButton *)sender {
    NSLog(@"rule url:%@", self.dataModel.tiaokuan_url);
    
    DKMainWebViewController *protocolVC = [[DKMainWebViewController alloc] init];
    protocolVC.title = @"服务协议";
    protocolVC.isRequest = NO;
    protocolVC.webString = self.dataModel.tiaokuan_url;
    [self.navigationController pushViewController:protocolVC animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return (section == 3 ? 1 : 4);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 3) {
        
        BaoDetailCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"BaoDetailCell" owner:self options:nil] lastObject];
        
        cell.model = self.dataModel;
        
        return cell;

        
    }else {
        BaoDetailTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"BaoDetailTableViewCell" owner:self options:nil] lastObject];
        
        cell.label.text = self.titleArray[indexPath.section][indexPath.row];
        
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell.detailLabel.text = self.dataModel.car;
            }else if (indexPath.row == 1) {
                cell.detailLabel.text = self.dataModel.chejia;
            }else if (indexPath.row == 2) {
                cell.detailLabel.text = self.dataModel.fadongji;
            }else {
                cell.detailLabel.text = self.dataModel.dengji;
            }
        }else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                cell.detailLabel.text = self.dataModel.user_name;
            }else if (indexPath.row == 1) {
                cell.detailLabel.text = self.dataModel.user_phone;
            }else if (indexPath.row == 2) {
                cell.detailLabel.text = self.dataModel.zheng_jian_type;
            }else {
                cell.detailLabel.text = self.dataModel.zheng_jian;
            }
        }else if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                cell.detailLabel.text = self.dataModel.business_NO;
            }else if (indexPath.row == 1) {
                cell.detailLabel.text = self.dataModel.jiaoqiang_NO;
            }else if (indexPath.row == 2) {
                cell.detailLabel.text = self.dataModel.business_date;
            }else if (indexPath.row == 3) {
                cell.detailLabel.text = self.dataModel.jiaoqiang_date;
            }
        }
        return cell;
    }
}

#pragma mark - UITableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return (section == 3 ? 10 : 30);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 3) {
        return 640;
    }else {
        return 44;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 3) {
        return nil;
    }
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 30)];
    label.backgroundColor = [UIColor clearColor];
    
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = RGB(254, 145, 0);// 254 145 0
    [headerView addSubview:label];
    
    if (section == 0) {
        label.text = @"车辆信息";
    }else if (section == 1) {
        label.text = @"车主信息";
    }else if (section == 2) {
        label.text = @"保险信息";
    }
    
    return headerView;
}


#pragma mark - 网络请求
- (void)requestData {
    
#define kSearchInsure @"/api/insure/search"
    
//    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"baodan001",@"no",
//                            @"4503241111111111111",@"sfz", nil];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.type,@"no",
                            self.idCard,@"sfz", nil];
    
    
    [DataService http_Post:kSearchInsure parameters:params success:^(id responseObject) {
        NSLog(@"保单查询success:%@", responseObject);
        
        if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
            
            if (![responseObject[@"data"] isKindOfClass:[NSNull class]]) {
                InsuranceModel *model = [[InsuranceModel alloc] initContentWithDic:[responseObject objectForKey:@"data"]];
                
                self.dataModel = model;
                
                //查询后刷新数据
                [self.footerView createFooterViewWithInsuranceModel:self.dataModel];
                [self.tableView reloadData];
            }else {
                [PromtView showAlert:@"查询信息为空" duration:1.5];
            }
        }else {
            [PromtView showAlert:PromptWord duration:1.5];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"保单查询error：%@", error);
        [PromtView showAlert:PromptWord duration:1.5];
    }];
}



@end
