//
//  PhotoCollectionView.h
//  WXMovie47
//
//  Created by keyzhang on 15/8/24.
//  Copyright (c) 2015年 keyzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCollectionView : UICollectionView<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *data;

@end
