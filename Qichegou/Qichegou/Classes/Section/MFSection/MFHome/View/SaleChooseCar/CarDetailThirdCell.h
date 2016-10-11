//
//  CarDetailThirdCell.h
//  Qichegou
//
//  Created by Meng Fan on 16/10/8.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarDetailThirdCell : UITableViewCell

@property (nonatomic, copy) void(^clickMoreBtn)();
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

@property (nonatomic, assign) BOOL isShowing;

@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *fiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *fiveDetailLabel;


@end
