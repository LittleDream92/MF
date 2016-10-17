//
//  ChooseCarCommonCell.m
//  Qichegou
//
//  Created by Meng Fan on 16/10/17.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "ChooseCarCommonCell.h"

@interface ChooseCarCommonCell ()

@property (nonatomic, strong) UIView *line;

@end

@implementation ChooseCarCommonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageView.frame = CGRectMake(15, 7, 30, 30);
        [self.textLabel createLabelWithFontSize:15 color:GRAYCOLOR];
        
        [self.contentView addSubview:self.line];
        [self.line makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(0);
            make.height.equalTo(1);
        }];
    }
    return self;
}

#pragma mark - lazyloading
-(UIView *)line {
    if (!_line) {
        _line = [UIView new];
        _line.backgroundColor = BGGRAYCOLOR;
    }
    return _line;
}

@end
