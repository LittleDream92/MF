//
//  CarProView.h
//  Qichegou
//
//  Created by Meng Fan on 16/9/28.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarProView : UIView

@property (nonatomic, copy) void(^tapAction)();
@property (nonatomic, copy) void(^clickItemAction)(NSString *proID);

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end
