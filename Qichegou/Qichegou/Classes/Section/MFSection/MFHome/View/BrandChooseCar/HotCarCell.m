//
//  HotCarCell.m
//  QiChegou
//
//  Created by Meng Fan on 16/9/26.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "HotCarCell.h"
#import "HotCarCollectionCell.h"
#import "CarModel.h"
#import "MFCarDetailViewController.h"

static NSString *const hotCarCellID = @"hotCarCollectionCellID";
@interface HotCarCell ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, strong) UIView *line;

@end

@implementation HotCarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addSubview:self.line];
        [self.line makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(1);
            make.left.right.top.equalTo(0);
        }];
        
        [self addSubview:self.collectionView];
        [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(1, 0, 0, 0));
        }];
        
        //注册单元格
        [self.collectionView registerClass:[HotCarCollectionCell class] forCellWithReuseIdentifier:hotCarCellID];
    }
    return self;
}

#pragma mark - lazyloading 
-(UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = BGGRAYCOLOR;
    }
    return _line;
}

-(UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        
        //代理数据源
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
//        _collectionView.pagingEnabled = YES;
        
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.hotArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CGFloat width = kScreenWidth/4;
    CGFloat height = self.frame.size.height-1;
    return CGSizeMake(width, height + 10);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HotCarCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:hotCarCellID forIndexPath:indexPath];
    
    cell.model = self.hotArr[indexPath.item];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CarModel *model = self.hotArr[indexPath.item];
//    NSLog(@"index:%ld", indexPath.item);
    
    MFCarDetailViewController *detailCarVC = [[MFCarDetailViewController alloc] init];
    detailCarVC.cid = model.car_id;
    [self.viewController.navigationController pushViewController:detailCarVC animated:YES];
}

@end
