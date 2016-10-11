//
//  HomeMenuCell.h
//  QiChegou
//
//  Created by Meng Fan on 16/9/18.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeMenuCell : UITableViewCell

@property (copy) void(^clickBrandBtn)();
@property (copy) void(^clickSaleBtn)();
@property (copy) void(^clickDaiBtn)();
@property (copy) void(^clickXianBtn)();

@end
