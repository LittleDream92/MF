//
//  CarImagesView.h
//  Qichegou
//
//  Created by Meng Fan on 16/10/19.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarImagesView : UIView

//图片的数据源
@property (nonatomic, strong) NSArray *img1_arr;
@property (nonatomic, strong) NSArray *img2_arr;
@property (nonatomic, strong) NSArray *img3_arr;
@property (nonatomic, strong) NSArray *img4_arr;

-(instancetype)initWithArr1:(NSArray *)arr1 arr2:(NSArray *)arr2 arr3:(NSArray *)arr3 arr4:(NSArray *)arr4;

@end
