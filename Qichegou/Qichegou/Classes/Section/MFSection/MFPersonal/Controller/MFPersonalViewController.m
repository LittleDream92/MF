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

//控件
@property (nonatomic, strong) UIButton *naviRightBtn;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, strong) UIImageView *headerBgView;
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
    
    self.contrlArr = [NSMutableArray array];
    
    [self setUpnav];
    [self setUpViews];
    [self combineViewModel];
}


#pragma mark - setUp
- (void)setUpnav {
    self.title = @"我的";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.naviRightBtn];
}

- (void)setUpViews {
    WEAKSELF
    
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    //注册单元格
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:commentCell];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:latestCell];
    
    self.tableView.tableHeaderView = self.headerView;
    
    [self.headerView addSubview:self.headerBgView];
    [self.headerBgView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.headerView addSubview:self.iconBtn];
    [self.iconBtn makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(96, 96));
        make.centerX.equalTo(weakSelf.headerView.mas_centerX);
        make.centerY.equalTo(weakSelf.headerView.mas_centerY);
    }];
    
    [self.headerView addSubview:self.nameLabel];
    [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.headerView.mas_centerX);
        make.bottom.equalTo(-10);
        make.size.equalTo(CGSizeMake(kScreenWidth, 21));
    }];
    
    self.tableView.tableFooterView = self.footerView;
    
    [self.footerView addSubview:self.telLabel];
    [self.telLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(5);
        make.size.equalTo(CGSizeMake(kScreenWidth, 21));
    }];
    
    [self.footerView addSubview:self.textLabel];
    [self.textLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.telLabel.mas_bottom).offset(5);
        make.size.equalTo(CGSizeMake(kScreenWidth, 21));
    }];
}

- (void)combineViewModel {
    [[self.naviRightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.viewModel.settingCommand execute:nil];
    }];
}

#pragma mark - lazyloading
- (PersonalViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[PersonalViewModel alloc] init];
    }
    return _viewModel;
}

-(UIButton *)naviRightBtn {
    if (_naviRightBtn == nil) {
        _naviRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_naviRightBtn setBackgroundImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
        [_naviRightBtn setBackgroundImage:[UIImage imageNamed:@"setting"] forState:UIControlStateHighlighted];
        _naviRightBtn.size = _naviRightBtn.currentBackgroundImage.size;
//        [_naviRightBtn addTarget:self action:@selector(ClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _naviRightBtn;
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
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    }
    return _footerView;
}

-(UIImageView *)headerBgView {
    if (!_headerBgView) {
        _headerBgView = [[UIImageView alloc] init];
        _headerBgView.image = [UIImage imageNamed:@"Pers_headerbg"];
    }
    return _headerBgView;
}

-(UIButton *)iconBtn {
    if (!_iconBtn) {
        _iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_iconBtn setBackgroundImage:[UIImage imageNamed:@"per_icon"] forState:UIControlStateNormal];
        
        _iconBtn.layer.masksToBounds = YES;
        _iconBtn.layer.cornerRadius = 96/2;
    }
    return _iconBtn;
}

-(UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        
        _nameLabel.font = H16;
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.text = @"点击头像登录";
    }
    return _nameLabel;
}

-(UILabel *)telLabel {
    if (!_telLabel) {
        _telLabel = [[UILabel alloc] init];
        _telLabel.textColor = ITEMCOLOR;
        _telLabel.font = H14;
        _telLabel.textAlignment = NSTextAlignmentCenter;
        _telLabel.text = @"400-169-0399";
    }
    return _telLabel;
}

-(UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = GRAYCOLOR;
        _textLabel.font = H10;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.text = @"汽车购为您服务（ 9:00 - 21:00 ）";
    }
    return _textLabel;
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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //观察滑动视图的偏移量
    CGFloat yOffset = scrollView.contentOffset.y + 64;
    //    NSLog(@"yOffset is %.2f", yOffset);
    if (yOffset < 0) {
        //往下拉
        //取出图片视图
        UIImageView *imgView = self.headerBgView;
        //计算宽度
        CGFloat width = kScreenWidth/175 * (175 - yOffset);
        imgView.frame = CGRectMake((kScreenWidth - width) / 2, yOffset, width, 175 - yOffset);
    }
}

#pragma mark - 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
