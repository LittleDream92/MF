//
//  MFCarDetailViewController.m
//  Qichegou
//
//  Created by Meng Fan on 16/10/17.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "MFCarDetailViewController.h"
#import "CarDetailViewModel.h"

#import "DetailChooseCarHeader.h"

#import "DetailCarInformationCell.h"
#import "ChooseCarCommonCell.h"

#import "DKNeedsTableViewController.h"

static NSString *const informationCell = @"informationcellID";
static NSString *const commonCell = @"CommonCellID";
@interface MFCarDetailViewController ()
<UITableViewDelegate,
UITableViewDataSource>
//控件
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *submmitButton;

@property (nonatomic, strong) DetailChooseCarHeader *headerView;

//viewModel
@property (nonatomic, strong) CarDetailViewModel *viewModel;

@end

@implementation MFCarDetailViewController

-(void)dealloc {
    //注销其他选项
    for (NSString *keyStr in self.viewModel.pushArray) {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:keyStr];
    }
}

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
    self.title = @"您的买车需求";
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
        //        [_submmitButton addTarget:self action:@selector(submmitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submmitButton;
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.haveLogin ? 3 : 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.viewModel.haveLogin ? 4 : 3;
    }else if (section == 1) {
        return self.viewModel.haveLogin ? 1 : 4;
    }else {
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index = self.viewModel.haveLogin ? 0 : 1;
    
    if (indexPath.section == (index-1)) {
        DetailCarInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:informationCell];
        if (cell == nil) {
            cell = [[DetailCarInformationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:informationCell];
        }
        
        if (indexPath.row != 2) {
            cell.lineView.hidden = YES;
            cell.getCodeBtn.hidden = YES;
            [cell.getCodeBtn addTarget:self action:@selector(getCodeAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        cell.iconImgView.image = [UIImage imageNamed:self.viewModel.imgNameArray[indexPath.row]];
        cell.writeTF.placeholder = self.viewModel.chooseTitleArray[indexPath.row];
        
        return cell;

    }else if (indexPath.section == index) {
        ChooseCarCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:commonCell];
        if (cell == nil) {
            cell = [[ChooseCarCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commonCell];
        }
        
        cell.imageView.image = [UIImage imageNamed:self.viewModel.imgNameArray[indexPath.row+3]];
        cell.textLabel.text = self.viewModel.chooseTitleArray[indexPath.row+3];
        
        NSString *keyString = self.viewModel.keyArray[indexPath.row];
        if ([[self.viewModel.getBackChooseDictionary allKeys] containsObject:keyString]) {
            [cell.textLabel createLabelWithFontSize:15 color:TEXTCOLOR];
            cell.textLabel.text = [self.viewModel.getBackChooseDictionary objectForKey:keyString];
        }else {
            [cell.textLabel createLabelWithFontSize:15 color:GRAYCOLOR];
            cell.textLabel.text = self.viewModel.chooseTitleArray[indexPath.row+3];
        }
        
        return cell;
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
    return section == 0 ? 12 : (section == 1 ? CGFLOAT_MIN : 40);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger index = self.viewModel.haveLogin ? 0 : 1;
    
    if (indexPath.section == index) {       //选择
        DKNeedsTableViewController *needsVC = [[DKNeedsTableViewController alloc] init];
        
        needsVC.title = self.viewModel.pushArray[indexPath.row];
        
        if (indexPath.row == 0) {
            needsVC.dataArray = (NSMutableArray *)self.viewModel.colorArray;
        }else {
            needsVC.dataArray = self.viewModel.pushTitleArr[indexPath.row-1];
        }
        
        [needsVC returnText:^(NSString *chooseColor) {
            
            NSString *keyString = self.viewModel.keyArray[indexPath.row];
            [self.viewModel.getBackChooseDictionary setValue:chooseColor forKey:keyString];
            
            //刷新tableView,
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
        }];
        [self.navigationController pushViewController:needsVC animated:YES];
    }
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
    
    RACSignal *colorSignal = [self.viewModel.carColorCommand execute:params];
    [colorSignal subscribeNext:^(id x) {
        dispatch_async(dispatch_get_main_queue(), ^{

        });
    }];
}

- (void)getCodeAction:(UIButton *)sender {
    DetailCarInformationCell *telCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    NSString *tel = telCell.writeTF.text;
    
    //此处优化：判断是否是11位 XXX 开头的手机号.
    if (tel.length == 0) {
        [PromtView showAlert:@"请输入11位手机号" duration:1.5];
    }else if (tel.length == 11) {
        [sender http_requestForCodeWithParams:tel];
    }else {
        [PromtView showAlert:@"手机号格式错误" duration:1.5];
    }
}

@end
