//
//  MFPersonalViewController.m
//  Qichegou
//
//  Created by Meng Fan on 16/9/21.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "MFPersonalViewController.h"
#import "PersonalViewModel.h"
#import "HomeButton.h"

static NSString *const commentCell = @"commentCellID";
static NSString *const latestCell = @"latestCellID";

@interface MFPersonalViewController ()
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, strong) PersonalViewModel *viewModel;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footerView;

//控件
@property (nonatomic, strong) UIButton *iconBtn;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *telLabel;
@property (nonatomic, strong) UILabel *textLabel;

//data
@property (nonatomic, strong) NSArray *carIDArr;

@end

@implementation MFPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpData];
    [self setUpViews];
}


#pragma mark - setUp
- (void)setUpData {
    self.contrlArr = [NSMutableArray array];
}

- (void)setUpViews {
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    //注册单元格
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:commentCell];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:latestCell];
    
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
}

#pragma mark - lazyloading
- (PersonalViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[PersonalViewModel alloc] init];
    }
    return _viewModel;
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];

        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.sectionFooterHeight = CGFLOAT_MIN;
        _tableView.sectionHeaderHeight = 10;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

-(UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 175)];
    }
    return _headerView;
}

-(UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
        _footerView.backgroundColor = [UIColor cyanColor];
    }
    return _footerView;
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.titleArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 4 ? 2 : 1);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellID = indexPath.row == 0 ? commentCell : latestCell;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (indexPath.section == 4) {
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            [self setCellWithCell:cell indexPath:indexPath];
        }else {
            if (self.contrlArr.count>0) {
                //需要删除之前的control
                for (int i = 0; i < self.contrlArr.count; i++) {
                    
                    NSInteger tag = [self.contrlArr[i] integerValue];
                    HomeButton *control = (HomeButton *)[cell viewWithTag:tag];
                    [control removeFromSuperview];
                }
            }
            //最近浏览
            if (self.carIDArr) {
                
                NSMutableArray *mArr = [NSMutableArray array];
                for (NSDictionary *jsonDic in self.carIDArr) {
                    NSInteger tagValue = [[jsonDic objectForKey:@"cid"] integerValue]+ 2016;
                    [mArr addObject:[NSNumber numberWithInteger:tagValue]];
                }
                self.contrlArr = mArr;
                
                for (int i = 0; i < [self.carIDArr count]; i++) {
                    //初始化自定义Control
                    CGFloat ctrlY = 0;
                    CGFloat ctrlWidth = (kScreenWidth - 30)/3;
                    CGFloat ctrlHeight = 100;
                    
                    HomeButton *carCtrl = [[HomeButton alloc] initWithFrame:CGRectMake(15 + i*ctrlWidth, ctrlY, ctrlWidth, ctrlHeight)];
                    NSDictionary *myDic = self.carIDArr[i];
                    
                    carCtrl.tag = [[myDic objectForKey:@"cid"] integerValue] + 2016;
                    [carCtrl setUpButtonWithImageName:myDic[@"imgName"] title:myDic[@"title"]];
//                    [carCtrl addTarget:self action:@selector(ctrlClickAction:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:carCtrl];
                    
                }
            }
        }
        
    }else {
        [self setCellWithCell:cell indexPath:indexPath];
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
    }

    return cell;
}

- (void)setCellWithCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    cell.imageView.image = [UIImage imageNamed:self.viewModel.imgNamesArr[indexPath.section]];
    cell.textLabel.font = H16;
    cell.textLabel.textColor = TEXTCOLOR;
    cell.textLabel.text = self.viewModel.titleArr[indexPath.section];
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 44;
    }else {
        return self.carIDArr == nil ? 0 : 110;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
