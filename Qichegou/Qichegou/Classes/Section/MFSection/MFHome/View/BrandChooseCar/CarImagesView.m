//
//  CarImagesView.m
//  Qichegou
//
//  Created by Meng Fan on 16/10/19.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "CarImagesView.h"
#import "BigCarImgVC.h"
#import "OtherModel.h"

@interface CarImagesView ()
<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation CarImagesView

-(instancetype)initWithArr1:(NSArray *)arr1 arr2:(NSArray *)arr2 arr3:(NSArray *)arr3 arr4:(NSArray *)arr4 {
    self = [super init];
    if (self) {
        self.img1_arr = arr1;
        self.img2_arr = arr2;
        self.img3_arr = arr3;
        self.img4_arr = arr4;
        
        [self setUpViews];
    }
    return self;
}


- (void)setUpViews {
    [self addSubview:self.collectionView];
    
    WEAKSELF
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(weakSelf);
    }];
    
    //注册单元格
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionCell"];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];//注册头/尾视图，视图类型必须为UICollectionReusableView或者其子类，kind设置为UICollectionElementKindSectionHeader或者UICollectionElementKindSectionFooter，最后设置标识
}

#pragma mark - lazyloading
-(UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        [flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowlayout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowlayout];
        _collectionView.backgroundColor = white_color;
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}


#pragma mark - UICollectionView 方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSArray *dataArray = [NSArray array];
    
    if (section == 0) {
        dataArray = self.img1_arr;
    }else if(section == 1) {
        dataArray = self.img2_arr;
    }else if (section == 2) {
        dataArray = self.img3_arr;
    }else {
        dataArray = self.img4_arr;
    }
    
    return dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    
//    cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    
    UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:111];
    if (!imgView) {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        imgView.tag = 111;
        [cell.contentView addSubview:imgView];
    }else {
        imgView.image = nil;
    }
    
    NSArray *dataArray = [NSArray array];
    
    if (indexPath.section == 0) {
        dataArray = self.img1_arr;
    }else if(indexPath.section == 1) {
        dataArray = self.img2_arr;
    }else if (indexPath.section == 2) {
        dataArray = self.img3_arr;
    }else {
        dataArray = self.img4_arr;
    }
    
    OtherModel *model = dataArray[indexPath.row];
    NSLog(@"%@", [NSString stringWithFormat:@"%@%@", URL_String, model.thumb_sm]);
    [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_String, model.thumb_sm]] placeholderImage:[UIImage imageNamed:@"bg_default"]];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"正在点击单元格");
    //点击单元格 push
    BigCarImgVC *bigImgVC = [[BigCarImgVC alloc] init];
    
    NSArray *dataArray = [NSArray array];
    
    if (indexPath.section == 0) {
        dataArray = self.img1_arr;
    }else if(indexPath.section == 1) {
        dataArray = self.img2_arr;
    }else if (indexPath.section == 2) {
        dataArray = self.img3_arr;
    }else {
        dataArray = self.img4_arr;
    }
    
    bigImgVC.data = dataArray;
    bigImgVC.index = indexPath.row;
    bigImgVC.title = @"车型图片";
    [self.viewController.navigationController pushViewController:bigImgVC animated:NO];
}

#pragma mark
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    CGFloat width = (kScreenWidth - 15*4)/3;
    
    return CGSizeMake(width, width);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(8, 10, 8, 10);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(kScreenWidth, 37);
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    //根据类型以及标识获取注册过的头视图,注意重用机制导致的bug
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
    
    for (UIView *view in headerView.subviews) {
        [view removeFromSuperview];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, headerView.frame.size.width - 15, headerView.frame.size.height)];
    
    [label createLabelWithFontSize:13 color:GRAYCOLOR];
    if (indexPath.section == 0) {
        label.text = @"外观颜色";
    }else if(indexPath.section == 1) {
        label.text = @"内饰颜色";
    }else if(indexPath.section == 2) {
        label.text = @"空间";
    }else {
        label.text = @"官方图";
    }
    
    [headerView addSubview:label];
    
    return headerView;
}


@end
