//
//  DKCityTableViewController.h
//  Qichegou
//
//  Created by Meng Fan on 16/3/16.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DKBaseTableViewController.h"

@interface DKCityTableViewController : DKBaseTableViewController
{
    UIImageView *_checkmarkImgView;  //标记视图
}

//上次选择的单元格的城市ID
@property (nonatomic, strong) NSIndexPath *lastIndexPath;

@end
