//
//  DKCarNeedsVC.h
//  DKQiCheGou
//
//  Created by Song Gao on 16/1/20.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DKBaseViewController.h"
#import "CarModel.h"

@interface DKCarNeedsVC : DKBaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_keyArray;
}

@property (weak, nonatomic) IBOutlet UITableView *needsTV;

//数据源
@property (nonatomic, strong) CarModel *chooseModel;

//外观颜色数据源
@property (nonatomic, strong) NSArray *colorArr;
//存储回传的参数的字典
@property (nonatomic, strong) NSMutableDictionary *getBackChooseDictionary;


@end
