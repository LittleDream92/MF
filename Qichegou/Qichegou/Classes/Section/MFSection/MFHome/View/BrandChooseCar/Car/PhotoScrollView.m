//
//  PhotoScrollView.m
//  WXMovie47
//
//  Created by keyzhang on 15/8/24.
//  Copyright (c) 2015年 keyzhang. All rights reserved.
//

#import "PhotoScrollView.h"
#import "UIView+ViewController.h"

@implementation PhotoScrollView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化ImgView
        _imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        //设置图片的显示模式
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        _imgView.userInteractionEnabled = YES;
        [_imgView addGestureRecognizer:tap];
        
        [self addSubview:_imgView];
        
        //自己实现自己的滑动代理
        self.delegate = self;
        
        //设置最大、最小缩放倍数
        self.maximumZoomScale = 3;
        self.minimumZoomScale = 1;
        
        //隐藏滑动条
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        
    }
    return self;
}


- (void)tapAction:(UITapGestureRecognizer *)tap
{    
    if (!_isHidden) {
        self.viewController.navigationController.navigationBar.alpha = 0;
    }else {
        self.viewController.navigationController.navigationBar.alpha = 1;
    }
    _isHidden = !_isHidden;
}


- (void)setModel:(OtherModel *)model
{
    if (_model != model) {
        _model = model;
        [_imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_String, self.model.thumb_lg]] placeholderImage:[UIImage imageNamed:@"bg_default"]];
    }
}


#pragma mark -UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imgView;
}

@end
