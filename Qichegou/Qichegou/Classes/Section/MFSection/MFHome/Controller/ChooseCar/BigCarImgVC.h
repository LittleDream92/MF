//
//  BigCarImgVC.h
//  DKQiCheGou
//
//  Created by Song Gao on 16/1/21.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DKBaseViewController.h"

@interface BigCarImgVC : DKBaseViewController

@property (nonatomic, strong) NSArray *data; //数据源
@property (nonatomic, assign) NSInteger index; //当前需要滑动到的图片下标

@end
