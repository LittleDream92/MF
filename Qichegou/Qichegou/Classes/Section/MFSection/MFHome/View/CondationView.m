//
//  CondationView.m
//  Qichegou
//
//  Created by Meng Fan on 16/9/29.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "CondationView.h"

@interface CondationView ()
//<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;


@end

@implementation CondationView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = white_color;
    }
    return self;
}


#pragma mark - lazyloading
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//        
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
        
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource



#pragma mark - UITableViewDelegate



#pragma mark - action


@end
