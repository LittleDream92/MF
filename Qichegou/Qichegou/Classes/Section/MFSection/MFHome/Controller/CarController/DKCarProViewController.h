//
//  DKCarProViewController.h
//  Qichegou
//
//  Created by Meng Fan on 16/4/15.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DKBaseViewController.h"

@interface DKCarProViewController : DKBaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) NSString *bid;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArr;

@end
