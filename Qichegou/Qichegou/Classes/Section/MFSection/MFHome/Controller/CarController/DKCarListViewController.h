//
//  DKCarListViewController.h
//  Qichegou
//
//  Created by Meng Fan on 16/4/20.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DKBaseViewController.h"

@interface DKCarListViewController : DKBaseViewController

//>>>>>>>>>>>>>>>>参数
/*条件选车传过来的*/
@property (nonatomic, copy) NSString *maxPrice;
@property (nonatomic, copy) NSString *minPrice;
@property (nonatomic, copy) NSString *modelID;

/*品牌选车传过来的*/
@property (nonatomic, copy) NSString *pid;

@end
