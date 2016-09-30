//
//  CondationView.m
//  Qichegou
//
//  Created by Meng Fan on 16/9/29.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "CondationView.h"
#import "CondationCollectionCell.h"
#import "PriceCell.h"

static NSString *const identifier = @"CondationtvCollectionCell";
@interface CondationView ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
{
    //条件选车数组
    NSArray *imgNameArr;
    NSArray *titleArr;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UIButton *clearBtn;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSIndexPath *lastIndexPath;

@end

@implementation CondationView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpData];
        
        WEAKSELF
        [self addSubview:self.buttonView];
        [self.buttonView makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.height.equalTo(50);
        }];
        
        [self addSubview:self.tableView];
        [self.tableView makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(0);
            make.bottom.equalTo(weakSelf.buttonView.mas_top);
        }];
        
        [self.buttonView addSubview:self.clearBtn];
        [self.clearBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(0);
            make.width.equalTo(100);
        }];
        
        [self.buttonView addSubview:self.nextBtn];
        [self.nextBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.clearBtn.mas_right);
            make.right.top.bottom.equalTo(0);
        }];
    }
    return self;
}


- (void)setUpData {
    imgNameArr = @[@"car_1",@"car_2",@"car_3",@"car_4",@"car_5",@"car_6",@"car_7",@"car_8",@"car_9",@""];
    titleArr = @[@"微型", @"小型", @"紧凑型", @"中型", @"中大型", @"豪华型", @"MPV", @"SUV", @"跑车"];
}


#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"commonCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *textStr = indexPath.section == 0 ? @"价格" : @"级别";
        
        [cell.textLabel createLabelWithFontSize:13 color:TEXTCOLOR];
        cell.textLabel.text = textStr;
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = BGGRAYCOLOR;
        [cell.contentView addSubview:line];
        [line makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.height.equalTo(1);
        }];
        
        return cell;
    }else {
        if (indexPath.section == 0) {
            
            PriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
            if (cell == nil) {
                cell = [[PriceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellid"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }else {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"levelCellID"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell addSubview:self.collectionView];
            [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
            }];
            
            return cell;
        }
    }
   
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 30;
    }else {
        if (indexPath.section == 0) {
            return 80;
        }else {
            return 370;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 9;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {

    CGFloat width = kScreenWidth/3;
    CGFloat height = 110;
    return CGSizeMake(width, height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //第一组
    CondationCollectionCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
//    collectionCell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    
    collectionCell.carImgView.image = [UIImage imageNamed:imgNameArr[indexPath.item]];
    collectionCell.carLabel.text = titleArr[indexPath.item];
    
    return collectionCell;
}

#pragma mark - UICollection delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld", indexPath.item);
    CondationCollectionCell *lastCell = (CondationCollectionCell *)[collectionView cellForItemAtIndexPath:self.lastIndexPath];
    lastCell.carLabel.textColor = TEXTCOLOR;
    CondationCollectionCell *newCell = (CondationCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    newCell.carLabel.textColor = ITEMCOLOR;
    
    self.lastIndexPath = indexPath;
}

#pragma mark - action
- (void)clearAction:(UIButton *)sender {
    NSLog(@"clear");
}

- (void)pushNextAction:(UIButton *)sender {
    NSLog(@"push next");
    
    if (self.clickNextBtn) {
        self.clickNextBtn();
    }
}





#pragma mark - lazyloading
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

-(UIView *)buttonView {
    if (!_buttonView) {
        _buttonView = [[UIView alloc] init];
    }
    return _buttonView;
}

-(UIButton *)clearBtn {
    if (!_clearBtn) {
        _clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clearBtn createButtonWithBGImgName:@"btn_clear"
                          bghighlightImgName:@"btn_clear_2"
                                    titleStr:@"清空"
                                    fontSize:15];
        [_clearBtn setTitleColor:GRAYCOLOR forState:UIControlStateNormal];
        [_clearBtn addTarget:self action:@selector(clearAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearBtn;
}

-(UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextBtn setTitleColor:kBtnColor forState:UIControlStateNormal];
        [_nextBtn createButtonWithBGImgName:@"btn_find"
                         bghighlightImgName:@"btn_find_2"
                                   titleStr:@"找到0款车型"
                                   fontSize:15];
        [_nextBtn addTarget:self action:@selector(pushNextAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}

-(UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        
        //初始化
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        //代理数据源
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [self.collectionView registerClass:[CondationCollectionCell class] forCellWithReuseIdentifier:identifier];
    }
    return _collectionView;
}

@end
