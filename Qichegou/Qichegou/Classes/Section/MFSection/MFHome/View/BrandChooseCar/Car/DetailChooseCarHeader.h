//
//  DetailChooseCarHeader.h
//  Qichegou
//
//  Created by Meng Fan on 16/4/14.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarModel.h"

@interface DetailChooseCarHeader : UIView<UIScrollViewDelegate>
{
    NSTimer *_timer;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIPageControl *pageContrl;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *guidPrice;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (nonatomic, strong) CarModel *model;

- (void)createHeaderScrollViewWithModel:(CarModel *)model;

@end
