//
//  DKNeedsTableViewController.m
//  Qichegou
//
//  Created by Meng Fan on 16/3/18.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DKNeedsTableViewController.h"
#import "UIView+Extension.h"

static NSString *const cellID = @"ChooseInformationCell";
@interface DKNeedsTableViewController ()

@end

@implementation DKNeedsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //取到上次选中的
    NSInteger lastindexPathRow = [[[NSUserDefaults standardUserDefaults] objectForKey:self.title] integerValue];
    if (lastindexPathRow == 0) {
        self.lastIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }else {
        self.lastIndexPath = [NSIndexPath indexPathForRow:lastindexPathRow inSection:0];
    }
    
    self.tableView.rowHeight = 48;
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //初始化cell，不复用
    UITableViewCell *informationCell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (informationCell == nil) {
        informationCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
        //初始化
        checkmarkImgView = [UIImageView new];
        checkmarkImgView.tag = 201;
        checkmarkImgView.image = [UIImage imageNamed:@"icon_check"];
        [informationCell.contentView addSubview:checkmarkImgView];
        
        checkmarkImgView.size = [UIImage imageNamed:@"icon_check"].size;
        checkmarkImgView.x = kScreenWidth - 20;
        checkmarkImgView.centerY = 48/2;
    }
    
    if (indexPath != self.lastIndexPath) {
        checkmarkImgView.hidden = YES;
    }
    
    informationCell.textLabel.text = self.dataArray[indexPath.row];
    
    return informationCell;
}

#pragma mark - UITableViewDelegate
/*点击单元格触发的方法*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath != self.lastIndexPath ) {
        //取到上次的单元格隐藏,
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        UIImageView *newCheckVIew = (UIImageView *)[newCell viewWithTag:201];
        newCheckVIew.hidden = NO;
        
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:self.lastIndexPath];
        UIImageView *oldCheckView = (UIImageView *)[oldCell viewWithTag:201];
        oldCheckView.hidden = YES;
    }
    
    self.lastIndexPath = indexPath;
    
    //block传值
    if (self.returnBlock != nil) {
        NSString *color = self.dataArray[indexPath.row];
        self.returnBlock(color);
    }
    
    //关闭页面
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - view methods
//视图即将消失
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSString *indexStr = [NSString stringWithFormat:@"%ld",(long)self.lastIndexPath.row];
    [[NSUserDefaults standardUserDefaults] setObject:indexStr forKey:self.title];
}

//block的调用
- (void)returnText:(returnBlock)block {
    self.returnBlock = block;
}

@end
