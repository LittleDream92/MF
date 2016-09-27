//
//  PhotoCell.h
//  WXMovie47
//
//  Created by keyzhang on 15/8/24.
//  Copyright (c) 2015年 keyzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoScrollView.h"
#import "OtherModel.h"

@interface PhotoCell : UICollectionViewCell


@property (nonatomic, strong) PhotoScrollView *scrollView;

@property (nonatomic, strong) OtherModel *model;


@end
