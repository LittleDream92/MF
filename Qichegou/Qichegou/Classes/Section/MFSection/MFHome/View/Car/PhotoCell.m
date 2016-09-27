//
//  PhotoCell.m
//  WXMovie47
//
//  Created by keyzhang on 15/8/24.
//  Copyright (c) 2015年 keyzhang. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _createViews];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self _createViews];
}


- (void)_createViews
{
    _scrollView = [[PhotoScrollView alloc] initWithFrame:self.bounds];
    [self.contentView addSubview:_scrollView];
}


- (void)setModel:(OtherModel *)model
{
    if (_model != model) {
        _model = model;
        _scrollView.model = self.model;
    }
}


@end
