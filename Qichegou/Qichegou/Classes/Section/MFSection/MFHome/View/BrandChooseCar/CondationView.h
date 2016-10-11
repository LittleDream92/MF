//
//  CondationView.h
//  Qichegou
//
//  Created by Meng Fan on 16/9/29.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CondationView : UIView

@property (nonatomic, strong) UICollectionView *collectionView;

//@property (nonatomic, strong) NSDictionary *carTypeDic;

@property (nonatomic, copy) void(^clickCarTypeItem)(NSString *mindID);
@property (nonatomic, copy) void(^clickNextBtn)(NSDictionary *params);

@end
