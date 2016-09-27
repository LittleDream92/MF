//
//  CarInformationView.h
//  Qichegou
//
//  Created by Song Gao on 16/1/27.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseCarModel.h"

@interface CarInformationView : UIView
{
    UILabel *orderStautsLabel;
    UIButton *cancelBtn;
}

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet UILabel *buycarWayLabel;
@property (weak, nonatomic) IBOutlet UILabel *neishiLabel;
@property (weak, nonatomic) IBOutlet UILabel *buycarTimeLabel;

@property (weak, nonatomic) IBOutlet UIView *linView;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;

@property (weak, nonatomic) IBOutlet UILabel *promtLabel2;


@property (weak, nonatomic) IBOutlet UILabel *promtLabel;



- (void)createCellViewWithModel:(ChooseCarModel *)model;

@end
