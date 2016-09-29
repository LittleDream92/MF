//
//  DKBaoDanViewController.m
//  Qichegou
//
//  Created by Meng Fan on 16/6/16.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DKBaoDanViewController.h"
#import "BaoDanTableViewCell.h"
#import "DKBaoDetailViewController.h"
#import "InsuranceModel.h"

#import "PurchesProcessView.h"

@interface DKBaoDanViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *titleArr;
    NSArray *imgArr;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footerView;

///* 网络请求数据源 */
//@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation DKBaoDanViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"保单查询";
    [self navBack:YES];
    
    titleArr = @[@"24小时服务热线95511", @"24小时服务热线95519", @"24小时服务热线95518"];
    imgArr = @[@"baodan_P", @"baodan_R", @"baodan_Z"];
    
    [self setupView];
//    [self requestData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - lazyloading
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.scrollEnabled = NO;
        
        _tableView.rowHeight = 75;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}


-(UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] init];
        
        _footerView.backgroundColor = white_color;
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 6, 0, 0)];
        textLabel.font = [UIFont boldSystemFontOfSize:15];
        textLabel.textColor = TEXTCOLOR;
        textLabel.text = @"购买流程";
        [textLabel sizeToFit];
        [_footerView addSubview:textLabel];
        
        PurchesProcessView *prossView = [[[NSBundle mainBundle] loadNibNamed:@"PurchesProcessView" owner:self options:nil] lastObject];
        prossView.frame = CGRectMake(0, 30, kScreenWidth, 100);
        [_footerView addSubview:prossView];
    }
    return _footerView;
}

#pragma mark - setupView
- (void)setupView {
    WEAKSELF
    [self.view addSubview:self.footerView];
    [self.footerView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.height.equalTo(130);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(0);
        make.bottom.equalTo(weakSelf.footerView.mas_top);
    }];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaoDanTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"BaoDanTableViewCell" owner:self options:nil] lastObject];
    
//    cell.model = self.dataArray[indexPath.section];
    cell.imageView.image = [UIImage imageNamed:imgArr[indexPath.row]];
    cell.label.text = titleArr[indexPath.row];
    
    return cell;
    
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //把保险种类push传递到下一页
    DKBaoDetailViewController *detailVC = [[DKBaoDetailViewController alloc] init];
//    InsuranceModel *model = self.dataArray[indexPath.section];
//    detailVC.titleStr = model.name;
    [self.navigationController pushViewController:detailVC animated:YES];
}

/*
#pragma mark - requestData
- (void)requestData {
    

    
    [DataService http_Post:kBaoXian parameters:nil success:^(id responseObject) {
        NSLog(@"保险公司success:%@", responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
            
            NSArray *insureArray = [responseObject objectForKey:@"datas"];
            if ([insureArray isKindOfClass:[NSArray class]] && insureArray.count > 0) {
                
                NSMutableArray *mArr = [NSMutableArray array];
                for (NSDictionary *jsonDic in insureArray) {
                    InsuranceModel *model = [[InsuranceModel alloc] initContentWithDic:jsonDic];
                    [mArr addObject:model];
                }
                self.dataArray = mArr;
                //刷新表视图
                [self.tableView reloadData];
            }
        }else {
            [PromtView showAlert:responseObject[@"msg"] duration:1.5];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"保险公司error:%@", error);
        [PromtView showAlert:PromptWord duration:1.5];
    }];
}*/

@end
