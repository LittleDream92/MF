//
//  BuyCarNeedsHeaderview.h
//  Qichegou
//
//  Created by Meng Fan on 16/4/13.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyCarNeedsHeaderview : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

/*
 *  赋值传参
 *  参数
 */

- (void)createHeaderViewWithImgName:(NSString *)imgName
                              title:(NSString *)titleStr
                           priceStr:(NSString *)price;

@end
