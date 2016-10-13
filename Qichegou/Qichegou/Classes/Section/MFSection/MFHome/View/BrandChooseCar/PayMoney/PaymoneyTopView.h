//
//  PaymoneyTopView.h
//  DKQiCheGou
//
//  Created by Song Gao on 16/1/18.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CarOrderModel;
@interface PaymoneyTopView : UIView

/*
 * 网络请求后调用此方法赋值
 */
- (void)createTopViewWithChooseCarModel:(CarOrderModel *)model;


@end
