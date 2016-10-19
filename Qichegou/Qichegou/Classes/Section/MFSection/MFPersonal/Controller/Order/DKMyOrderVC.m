//
//  DKMyOrderVC.m
//  Qichegou
//
//  Created by Meng Fan on 16/4/11.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DKMyOrderVC.h"
#import "AppDelegate.h"
#import "MyOrderCell.h"

#import "CarOrderModel.h"

#import "DKPayMoneyVC.h"
#import "DKDetailOrderVC.h"

static NSString *const cellID = @"myOrderCell";

@interface DKMyOrderVC ()
<UITableViewDataSource,
UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UILabel *promtLabel;

//订单数据源
@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation DKMyOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNav];
    [self setUpViews];
    
    [self requestData];
}

#pragma  mark - setUp
- (void)setUpNav {
    [self navBack:YES];
    self.title = @"我的订单";
}

- (void)setUpViews {
    
    [self.view addSubview:self.promtLabel];
    [self.promtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(100);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 21));
    }];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    //设置header和footer
    self.tableView.sectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = 12;
    //调整inset
    self.tableView.contentInset = UIEdgeInsetsMake(-22, 0, 0, 0);
    
    //注册单元格
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyOrderCell class]) bundle:nil] forCellReuseIdentifier:cellID];
}

#pragma mark - setting and getting
-(UILabel *)promtLabel {
    if (_promtLabel == nil) {
        _promtLabel = [[UILabel alloc] init];
        _promtLabel.hidden = YES;
        _promtLabel.textAlignment = NSTextAlignmentCenter;
        [_promtLabel createLabelWithFontSize:16 color:RGB(221, 221, 221)];
        _promtLabel.text = @"您还没有订单呢，快去下单吧";
    }
    return _promtLabel;
}

#pragma mark - UITableView  Data  Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    UIButton *operationBtn = [cell viewWithTag:2121];
    operationBtn.tag = indexPath.section + 10;
    [operationBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    CarOrderModel *myOrderModel = self.dataArr[indexPath.section];
    //传值
    cell.model = myOrderModel;
    
    return cell;
}

#pragma mark - UITableView  delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DKDetailOrderVC *detailOrderVC = [[DKDetailOrderVC alloc] init];
    CarOrderModel *model = self.dataArr[indexPath.section];
    detailOrderVC.orderIDString = model.order_id;
    [self.navigationController pushViewController:detailOrderVC animated:YES];
}

#pragma mark - action
- (void)buttonAction:(UIButton *)button {
    
    NSInteger sectionNumber = button.tag - 10;
    CarOrderModel *model = self.dataArr[sectionNumber];
    
    DKPayMoneyVC *paymoneyVC = [[DKPayMoneyVC alloc] init];
    paymoneyVC.title = @"支付订金";
    paymoneyVC.orderIDString = model.order_id;
    [self.navigationController pushViewController:paymoneyVC animated:YES];
}

#pragma mark - view methods
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //更新订单状态，在订单详情取消或者其他操作后，回到这里来更新
    if (self.tableView) {
        [self requestData];
    }
}

#pragma mark - http_request
- (void)requestData {
    
    NSString *randomString = [BaseFunction ret32bitString];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", [BaseFunction getTimeSp]];
    NSString *md5String = [[BaseFunction md5Digest:[NSString stringWithFormat:@"%@%@%@", timeSp, randomString, APPSIGN]] uppercaseString];
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:randomString,@"nonce_str",
                            timeSp, @"time",
                            md5String, @"sign",
                            [AppDelegate APP].user.token,@"token", nil];
    NSLog(@"car orders params:%@", params);
    
    [DataService http_Post:MY_ORDER
                parameters:params
                   success:^(id responseObject) {
                       NSLog(@"orders :%@", responseObject);
                       if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
                           
                           NSArray *resultArr;
                           BOOL isOrders = NO;
                           if ([[responseObject objectForKey:@"data"] isKindOfClass:[NSArray class]] && [[responseObject objectForKey:@"data"] count]>0) {
                               //说明有订单,处理数据
                               NSArray *jsonArr = [responseObject objectForKey:@"data"];
                               
                               NSMutableArray *mArr = [NSMutableArray array];
                               for (NSDictionary *jsonDic in jsonArr) {
                                   CarOrderModel *model = [[CarOrderModel alloc] initContentWithDic:jsonDic];
                                   [mArr addObject:model];
                               }
                               resultArr = [NSArray arrayWithArray:mArr];
                               isOrders = YES;
                           }
                           
                           if (isOrders) {
                               self.promtLabel.hidden = YES;
                               self.dataArr = resultArr;
                               [self.tableView reloadData];
                               
                           }else {
                               self.promtLabel.hidden = NO;
                           }
                            [self.tableView reloadData];
                           
                       }else {
                           NSLog(@"%@", [responseObject objectForKey:@"msg"]);
                           [PromtView showAlert:responseObject[@"msg"] duration:1.5];
                       }
                       
                   } failure:^(NSError *error) {
                       
                       NSLog(@"error:%@", error);
                       [PromtView showAlert:PromptWord duration:1.5];
                   }];
}

@end
