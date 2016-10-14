//
//  MFDetailCarViewController.m
//  Qichegou
//
//  Created by Meng Fan on 16/10/14.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "MFDetailCarViewController.h"
#import "CarDetailViewModel.h"
#import "AppDelegate.h"

#import "DetailChooseCarHeader.h"
//#import "BuyCarNeedsTVC.h"
#import "DetailCarInformationCell.h"

static NSString *commonCell = @"commonCellID";
static NSString *chooseParamsCell = @"chooseParamsCellID";

@interface MFDetailCarViewController ()
<UITableViewDelegate,
UITableViewDataSource>

//控件
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *submmitButton;

@property (nonatomic, strong) DetailChooseCarHeader *headerView;


//viewModel
@property (nonatomic, strong) CarDetailViewModel *viewModel;

@end

@implementation MFDetailCarViewController

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
    self.title = @"买车";
}

- (void)setUpViews {
    [self.view addSubview:self.submmitButton];
    [self.view addSubview:self.tableView];
    
    WEAKSELF
    [self.submmitButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(40);
        make.right.equalTo(-40);
        make.height.equalTo(40);
        make.bottom.equalTo(-10);
    }];
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(0);
        make.bottom.equalTo(weakSelf.submmitButton.mas_top).offset(-10);
    }];
    
    self.tableView.tableHeaderView = self.headerView;
}

#pragma mark - lazyloading
-(CarDetailViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [CarDetailViewModel new];
    }
    return _viewModel;
}

-(UIButton *)submmitButton {
    if (!_submmitButton) {
        _submmitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submmitButton setTitle:@"立即下单" forState:UIControlStateNormal];
        _submmitButton.layer.cornerRadius = Button_H/8;
        _submmitButton.backgroundColor = kskyBlueColor;
    }
    return _submmitButton;
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

-(DetailChooseCarHeader *)headerView {
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"DetailChooseCarHeader" owner:self options:nil] lastObject];
        _headerView.height = 250;
    }
    return _headerView;
}

#pragma mark - action 
- (void)combineViewModel {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.cid, @"cid", nil];
    RACSignal *signal = [self.viewModel.carDetailCommand execute:params];
    [signal subscribeNext:^(id x) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.headerView createHeaderScrollViewWithModel:self.viewModel.carModel];
        });
    }];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        NSLog(@"第一组的个数:%d", self.viewModel.haveLogin);
        if (self.viewModel.haveLogin) {
            return 5;
        }else {
            return 8;
       }
    }else if (section == 1) {
        return 1;
    }else {
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commonCell];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commonCell];
        }
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.textLabel createLabelWithFontSize:15 color:TEXTCOLOR];
        cell.textLabel.text = @"下单、参数配置、车型图片";
        return cell;
    }else if (indexPath.section == 0) {
        if (self.viewModel.haveLogin) { //已登录：还有4个
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            cell.imageView.image = [UIImage imageNamed:self.viewModel.imgNameArray[indexPath.row- 1 + 3]];
            [cell.textLabel createLabelWithFontSize:15 color:GRAYCOLOR];
            cell.textLabel.text = self.viewModel.chooseTitleArray[indexPath.row-1 + 3];
            
            return cell;
        }else {     //未登录：还有7个
            if (indexPath.row > 3) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                }
                
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
                cell.imageView.image = [UIImage imageNamed:self.viewModel.imgNameArray[indexPath.row-1]];
                cell.imageView.frame = CGRectMake(15, 7, 30, 30);
                [cell.textLabel createLabelWithFontSize:15 color:GRAYCOLOR];
                cell.textLabel.text = self.viewModel.chooseTitleArray[indexPath.row-1];
                
                return cell;
            }else {
                DetailCarInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"carInformationCell"];
                
                if (cell == nil) {
                    cell = [[DetailCarInformationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"carInformationCell"];
                }
               
                if (indexPath.row != 3) {
                    cell.lineView.hidden = YES;
                    cell.getCodeBtn.hidden = YES;
                }
                
                cell.iconImgView.image = [UIImage imageNamed:self.viewModel.imgNameArray[indexPath.row-1]];
                cell.writeTF.placeholder = self.viewModel.chooseTitleArray[indexPath.row-1];
                
                return cell;
            }
        }
    }else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        
        cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
        
        return cell;
    }
    
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 12;
    }
    return 40;
}

@end
