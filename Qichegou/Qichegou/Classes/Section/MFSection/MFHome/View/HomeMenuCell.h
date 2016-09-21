//
//  HomeMenuCell.h
//  QiChegou
//
//  Created by Meng Fan on 16/9/18.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class HomeBtn;
@interface HomeMenuCell : UITableViewCell

@property (copy) void(^clickBrandBtn)();
@property (copy) void(^clickSaleBtn)();
@property (copy) void(^clickDaiBtn)();
@property (copy) void(^clickXianBtn)();

//@property (nonatomic, strong) HomeBtn *brandBtn;
//@property (nonatomic, strong) HomeBtn *saleBtn;
//@property (nonatomic, strong) HomeBtn *daiBtn;
//@property (nonatomic, strong) HomeBtn *xianBtn;

@end
