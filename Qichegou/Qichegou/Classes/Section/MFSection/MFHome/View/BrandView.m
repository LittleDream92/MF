//
//  BrandView.m
//  QiChegou
//
//  Created by Meng Fan on 16/9/26.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "BrandView.h"
#import "BrandCell.h"
#import "HotCarCell.h"
#import "CarModel.h"
//#import "MFProCarViewController.h"

static NSString *const cellID = @"brandTableViewCellID";
static NSString *const hotCarCellID = @"hotCarCellID";
@interface BrandView () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation BrandView


-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViews];
    }
    return self;
}

#pragma mark - setUpViews
- (void)setUpViews {
    [self addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
}

#pragma mark - lazyloading
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.sectionFooterHeight = 0;
        _tableView.sectionHeaderHeight = 37;
    }
    return _tableView;
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSArray *keys = [self.sectionDic allKeys];
    if ([keys isKindOfClass:[NSArray class]] && keys.count > 0) {
        return self.sectionArray.count + 1;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return [[self.sectionDic objectForKey:self.sectionArray[section-1]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        HotCarCell *cell = [tableView dequeueReusableCellWithIdentifier:hotCarCellID];
        
        if (cell == nil) {
            cell = [[HotCarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hotCarCellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        NSLog(@"hot hot : %@", self.hotArray);
        cell.hotArr = self.hotArray;
        
        if (self.hotArray != nil) {
            cell.hotArr = self.hotArray;
            [cell.collectionView reloadData];
        }
        
        return cell;
    }else {
        
        BrandCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (cell == nil) {
            cell = [[BrandCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        cell.brandModel = [self.sectionDic objectForKey:self.sectionArray[indexPath.section-1]][indexPath.row];
        
        return cell;
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *rightArr = [NSMutableArray arrayWithArray:@[@"热"]];
    [rightArr addObjectsFromArray:self.sectionArray];
    return rightArr;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 80;
    }
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 37)];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, 0, 21)];
    textLabel.font = H16;
    textLabel.textColor = GRAYCOLOR;
    [sectionView addSubview:textLabel];

    
    if (section == 0) {
        sectionView.backgroundColor = [UIColor whiteColor];
        textLabel.text = @"热销品牌";
    }else {
        sectionView.backgroundColor = BGGRAYCOLOR;
        textLabel.text = self.sectionArray[section-1];
    }
    [textLabel sizeToFit];
    
    
    return sectionView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section!=0) {
        CarModel *model = [self.sectionDic objectForKey:self.sectionArray[indexPath.section-1]][indexPath.row];
        
        if ([self.delegate respondsToSelector:@selector(clickBrandWithBrandID:)]) {
            [self.delegate clickBrandWithBrandID:model.brand_id];
        }
        
//        MFProCarViewController *proCarVC = [[MFProCarViewController  alloc] init];
//        proCarVC.title = model.brand_name;
//        proCarVC.proID = model.brand_id;
//        [self.viewController.navigationController pushViewController:proCarVC animated:YES];
    }
}

#pragma mark - action

@end
