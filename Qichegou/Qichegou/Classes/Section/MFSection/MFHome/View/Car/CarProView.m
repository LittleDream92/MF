//
//  CarProView.m
//  Qichegou
//
//  Created by Meng Fan on 16/9/28.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "CarProView.h"
#import "CarProTableViewCell.h"
#import "CarModel.h"

static NSString *const carProCellID = @"carProCellID";
@interface CarProView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *containView;

@end

@implementation CarProView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews {
//    self.backgroundColor = [UIColor cle];
    
    [self addSubview:self.containView];
    [self.containView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(0);
        make.width.equalTo(100);
    }];
    
    WEAKSELF
    [self addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(100);
        make.right.top.bottom.equalTo(0);
    }];
}

#pragma mark - lazyloading
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.rowHeight = 100;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

-(UIView *)containView {
    if (!_containView) {
        _containView = [[UIView alloc] init];
        _containView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenContainView)];
        [_containView addGestureRecognizer:tap];
    }
    return _containView;
}

#pragma mark - action

- (void)hiddenContainView {
    NSLog(@"hidden ya!");
    if (self.tapAction) {
        self.tapAction();
    }
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CarProTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"CarProTableViewCell" owner:self options:nil] lastObject];
    
    cell.model = self.dataArray[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CarModel *model = self.dataArray[indexPath.row];
    NSLog(@"%@", model.pro_id);
    
    if (self.clickItemAction) {
        self.clickItemAction(model.pro_id);
    }
}

@end
