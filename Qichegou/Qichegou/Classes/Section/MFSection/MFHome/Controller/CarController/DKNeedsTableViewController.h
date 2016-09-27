//
//  DKNeedsTableViewController.h
//  Qichegou
//
//  Created by Meng Fan on 16/3/18.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DKBaseTableViewController.h"

//定义传值的block,block的声明
typedef void(^returnBlock)(NSString *chooseColor);

@interface DKNeedsTableViewController : DKBaseTableViewController
{
    UIImageView *checkmarkImgView;  //标记视图
}

//上次选择的
@property (nonatomic, strong) NSIndexPath *lastIndexPath;

//定义block属性
@property (nonatomic, copy) returnBlock returnBlock;

//block的调用
- (void)returnText:(returnBlock)block;

@end
