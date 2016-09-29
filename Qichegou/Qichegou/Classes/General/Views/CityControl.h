//
//  CityControl.h
//  Qichegou
//
//  Created by Meng Fan on 16/3/10.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityControl : UIControl

@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, strong) UIImageView *downArrowImgView;

//自定义初始化方法 一
-(instancetype)initWithFrame:(CGRect)frame
                  cityString:(NSString *)cityStr;

@end
