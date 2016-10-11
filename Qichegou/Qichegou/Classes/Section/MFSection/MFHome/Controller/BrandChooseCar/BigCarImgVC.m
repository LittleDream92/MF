//
//  BigCarImgVC.m
//  DKQiCheGou
//
//  Created by Song Gao on 16/1/21.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "BigCarImgVC.h"
#import "PhotoCollectionView.h"

@interface BigCarImgVC ()

@end

@implementation BigCarImgVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBack:YES];
    
    //设置导航栏的透明度
    self.navigationController.navigationBar.translucent = NO;
    
    [self _initViews];
}

#pragma mark - init methods
/*初始化视图*/
- (void)_initViews
{
    //*******************创建collectionView对象**************************
    PhotoCollectionView *collectionView = [[PhotoCollectionView alloc] initWithFrame:self.view.bounds];
    collectionView.data = self.data;
    collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:collectionView];
    
    /*
     滑动到某个图片
     */
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.index inSection:0];
    
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
}

#pragma mark - Click Action methods
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return self.navigationController.navigationBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationFade;
}

@end
