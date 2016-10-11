//
//  PhotoCollectionView.m
//  WXMovie47
//
//  Created by keyzhang on 15/8/24.
//  Copyright (c) 2015年 keyzhang. All rights reserved.
//

#import "PhotoCollectionView.h"
#import "PhotoCell.h"

@implementation PhotoCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    //为当前的PhotoCollectionView创建布局对象
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    //设置滑动方向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    //设置单元格的大小
    flowLayout.itemSize = frame.size;
    
    //设置最小间距
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if (self) {
        
        //自己实现自己的代理
        self.delegate = self;
        self.dataSource = self;
        
        //分页功能
        self.pagingEnabled = YES;
        
        //清除滑动条
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        //注册单元格
        [self registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"photoCell"];
        
    }
    return self;
}

#pragma mark -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.data.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    cell.model = self.data[indexPath.row];
    return cell;
}

//当单元格已经不在屏幕上显示的时候调用的协议方法
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(PhotoCell *)pCell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    pCell.scrollView.zoomScale = 1;
}


@end
