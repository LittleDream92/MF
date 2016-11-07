//
//  FirstOpenView.m
//  Qichegou
//
//  Created by Meng Fan on 16/11/7.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "FirstOpenView.h"

@interface FirstOpenView () <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *imgNameArr;
@property (nonatomic, strong) NSArray *pageImageName;

@property (nonatomic, strong) UIScrollView *scrollView;

@end


@implementation FirstOpenView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViews];
    }
    return self;
}


- (void)setUpViews {
    self.imgNameArr = @[@"guide1.png",@"guide2.png",@"guide3.png",@"guide4.png",@"guide5.png"];
    //添加索引图片
    self.pageImageName = @[@"guideProgress1",@"guideProgress2",@"guideProgress3",@"guideProgress4",@"guideProgress5"];
    

    //创建imgView添加到滑动视图上
    for (int i = 0; i < self.imgNameArr.count; i ++) {
        //创建图片视图
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, kScreenHeight)];
        imgView.image = [UIImage imageNamed:self.imgNameArr[i]];
        [self.scrollView addSubview:imgView];
    }
    self.scrollView.contentSize = CGSizeMake(kScreenWidth*(self.imgNameArr.count+1), kScreenHeight);
//    self.scrollView.contentSize = CGSizeMake(kScreenWidth*self.imgNameArr.count, kScreenHeight);
    [self addSubview:self.scrollView];
    
    UIImageView *pageImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 86.5) / 2, kScreenHeight - 13 - 30, 86.5, 13)];
    pageImageView.tag = 2015;
    pageImageView.image = [UIImage imageNamed:self.pageImageName[0]];
    [self addSubview:pageImageView];
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.backgroundColor = [UIColor cyanColor];
//    button.frame = CGRectMake(4*kScreenWidth+20, kScreenHeight-80, kScreenWidth-40, 40);
//    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.scrollView addSubview:button];
    
}

- (void)buttonAction:(UIButton *)sender {
    //0.5秒之后移除当前启动界面
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5];

}


#pragma mark - lazyloading
-(UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        
//        _scrollView.backgroundColor = [UIColor cyanColor];
        _scrollView.pagingEnabled = YES;
        
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger pageIndex = scrollView.contentOffset.x / kScreenWidth;
    UIImageView *pageImageView = (UIImageView *)[self viewWithTag:2015];
    
    if (pageIndex < self.pageImageName.count) {
        pageImageView.image = [UIImage imageNamed:self.pageImageName[pageIndex]];
    }else {
        //0.5秒之后移除当前启动界面
        [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5];
    }
    
    if (scrollView.contentOffset.x > scrollView.contentSize.width - 2 * kScreenWidth) {
        CGFloat xOffset = scrollView.contentOffset.x - scrollView.contentSize.width + 2 * kScreenWidth;
        NSLog(@"xOffset is %.2f", xOffset);
        
        pageImageView.left = (kScreenWidth - 86.5) / 2 -  xOffset;
    }
    
}



@end
