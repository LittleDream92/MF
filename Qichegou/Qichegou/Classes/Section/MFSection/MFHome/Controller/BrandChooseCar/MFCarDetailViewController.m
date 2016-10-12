//
//  MFCarDetailViewController.m
//  Qichegou
//
//  Created by Meng Fan on 16/9/28.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "MFCarDetailViewController.h"
#import "DetailChooseCarHeader.h"
#import "CarModel.h"
#import "ParamsViewController.h"
#import "ImageViewController.h"
#import "CarDetailViewModel.h"
#import "DKCarNeedsVC.h"

static NSString *const cellID = @"commonCellID";
@interface MFCarDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    DetailChooseCarHeader *headerView;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *nextBtn;

@property (nonatomic, strong) CarDetailViewModel *viewModel;
//数据源
@property (nonatomic, strong) CarModel *detailModel;

@end

@implementation MFCarDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpNav];
    [self setUpViews];
    [self combineViewModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setUpViews
- (void)setUpNav {
    [self navBack:YES];
    self.title = @"选车";
}

- (void)setUpViews {
    WEAKSELF
    [self.view addSubview:self.nextBtn];
    [self.nextBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.height.equalTo(50);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(0);
        make.bottom.equalTo(weakSelf.nextBtn.mas_top);
    }];
    
    // 210 240 250
    CGFloat height = 0;
    if (kScreenHeight == 667) {
        height = 240;
    }else if (kScreenHeight > 667) {
        height = 250;
    }else {
        height = 210;
    }
    
    //头视图
    headerView = [[[NSBundle mainBundle] loadNibNamed:@"DetailChooseCarHeader" owner:self options:nil] lastObject];
    headerView.height = height;
    self.tableView.tableHeaderView = headerView;
}

- (void)combineViewModel {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.cid, @"cid", nil];
    RACSignal *signal = [self.viewModel.carDetailCommand execute:params];
    [signal subscribeNext:^(id x) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.detailModel = x;
            [headerView createHeaderScrollViewWithModel:self.detailModel];
            //最近浏览
            [self nearlyLookCarWithModel:self.detailModel];
        });
    }];
    
    [[self.nextBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        DKCarNeedsVC *carNeedsVC = [[DKCarNeedsVC alloc] init];
        carNeedsVC.chooseModel = self.detailModel;
        [self.navigationController pushViewController:carNeedsVC animated:YES];
    }];
}

#pragma mark - lazyloading
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

-(UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        _nextBtn.titleLabel.font = H16;
        _nextBtn.backgroundColor = kskyBlueColor;
//        [_nextBtn setBackgroundImage:[UIImage imageNamed:@"home_next"] forState:UIControlStateNormal];
//        [_nextBtn setBackgroundImage:[UIImage imageNamed:@"home_next_H"] forState:UIControlStateHighlighted];
    }
    return _nextBtn;
}

-(CarDetailViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[CarDetailViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark - action

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"参数配置";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case 1:
        {
            cell.textLabel.text = @"车型图片";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case 2:
        {
            UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"car_ad"]];
            imgView.frame = CGRectMake(0, 0, kScreenWidth, 150);
            [cell addSubview:imgView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        }
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 2 ? 150 : 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {   //参数配置
        ParamsViewController *carParamsVC = [[ParamsViewController alloc] init];
        carParamsVC.title = @"参数配置";
        carParamsVC.carID = self.detailModel.car_id;
        [self.navigationController pushViewController:carParamsVC animated:YES];
        
    }else if (indexPath.row == 1) {     //车型图片
        
        ImageViewController *imgsVC = [[ImageViewController alloc] init];
        imgsVC.title = @"车型图片";
        imgsVC.carID = self.detailModel.car_id;
        [self.navigationController pushViewController:imgsVC animated:YES];
    }
}

#pragma mark - 最近浏览
- (void)nearlyLookCarWithModel:(CarModel *)detailModel {
    //取出数组
    NSMutableArray *array = [[NSMutableArray alloc] init];
    array = [UserDefaults objectForKey:MYLOOKCAR];
    
    if (array) {
        NSLog(@"not nil");
        
        //存在此数组
        NSMutableArray *mArr = [[NSMutableArray alloc] initWithArray:array];
        
        //保存成字典，包含CID、phono、title
        NSDictionary *carDic = [NSDictionary dictionaryWithObjectsAndKeys:self.cid,@"cid",
                                detailModel.main_photo,@"imgName",
                                detailModel.car_subject,@"title",nil];
        
        if ([mArr containsObject:carDic]) {     //包含重复元素
            
            //删除重复元素
            [mArr removeObject:carDic];
        }
        
        if ([mArr count] >= 3) {    //>3
            
            //删除第一个元素
            [mArr removeObjectAtIndex:0];
        }
        
        [mArr addObject:carDic];
        NSLog(@"这次的mArr:%@", mArr);
        
        //操作数组
        [[NSUserDefaults standardUserDefaults] setObject:mArr forKey:MYLOOKCAR];
        
    }else {
        NSLog(@"nil");
        
        //初始化mArr
        NSMutableArray *mArr = [[NSMutableArray alloc] init];
        
        //保存成字典，包含CID、phono、title
        NSDictionary *carDic = [NSDictionary dictionaryWithObjectsAndKeys:self.cid,@"cid",
                                detailModel.main_photo,@"imgName",
                                detailModel.car_subject,@"title",nil];
        
        [mArr addObject:carDic];
        [[NSUserDefaults standardUserDefaults] setObject:mArr forKey:MYLOOKCAR];
    }
    
}


@end
