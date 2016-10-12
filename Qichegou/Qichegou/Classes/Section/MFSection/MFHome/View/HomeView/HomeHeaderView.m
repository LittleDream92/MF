//
//  HomeHeaderView.m
//  Qichegou
//
//  Created by Meng Fan on 16/9/27.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "HomeHeaderView.h"

@interface HomeHeaderView ()<UIScrollViewDelegate>
{
    NSTimer *_timer;
    BOOL isNext;
}

@property (nonatomic, strong) UIScrollView *bannerView;
@property (nonatomic, strong) UIPageControl *pageContrl;

@property (nonatomic, strong) NSArray *imagesArr;

@end

@implementation HomeHeaderView

-(void)dealloc {
    //销毁计时器
    [_timer invalidate];
}


-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        isNext = YES;
        
        [self setUpView];
        [self AutoLayout];
    }
    return self;
}

- (void)setUpView {
    [self addSubview:self.bannerView];
    [self addSubview:self.pageContrl];
}

- (void)AutoLayout {
    [self.bannerView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.pageContrl makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.height.equalTo(30);
    }];
}


#pragma mark - lazyloading
-(UIScrollView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[UIScrollView alloc]init];
        
        _bannerView.showsHorizontalScrollIndicator = NO;
        _bannerView.showsVerticalScrollIndicator = NO;
        _bannerView.delegate = self;
        _bannerView.pagingEnabled = YES;//分页
        
    }
    return _bannerView;
}

-(UIPageControl *)pageContrl {
    if (!_pageContrl) {
        _pageContrl = [[UIPageControl alloc] init];
        
        _pageContrl.tintColor = kskyBlueColor;
        [_pageContrl addTarget:self action:@selector(pageControlAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageContrl;
}

#pragma mark -
- (void)createHeaderViewWithImages:(NSArray *)images {
    
    self.imagesArr = images;
    if ([images isKindOfClass:[NSArray class]] && images.count > 1) {
        
        NSInteger count = images.count;
        
        self.pageContrl.hidden = NO;
        self.pageContrl.numberOfPages = count;
        
        self.bannerView.contentSize = CGSizeMake(kScreenWidth*count, 0);
        
        for (int i = 0; i < count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*kScreenWidth, 0, kScreenWidth, self.frame.size.height)];
            imageView.image = [UIImage imageNamed:images[i]];
            [self.bannerView addSubview:imageView];
        }
        
        
        _timer = [NSTimer timerWithTimeInterval:2.0
                                         target:self
                                       selector:@selector(timerStart)
                                       userInfo:nil
                                        repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        
    }else {
        self.pageContrl.hidden = YES;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.frame.size.height)];
        [self.bannerView addSubview:imageView];
        
        if ([images isKindOfClass:[NSArray class]] && images.count == 1) {
            imageView.image = [UIImage imageNamed:images[0]];
        }else {
            imageView.image = [UIImage imageNamed:@""];
        }
    }
}

#pragma mark - action
- (void)pageControlAction:(UIPageControl *)sender {
    CGFloat xoffset = sender.currentPage*self.bannerView.bounds.size.width;
    CGPoint offset = CGPointMake(xoffset, 0);
    [self.bannerView setContentOffset:offset animated:YES];
}

- (void)timerStart {
    
    if ([self.imagesArr isKindOfClass:[NSArray class]] && self.imagesArr.count>1) {
        NSInteger index = self.pageContrl.currentPage;
        
        if (isNext) {
            if (index == (self.imagesArr.count-1)) {
                isNext = NO;
                index -= 1;
            }else {
                index += 1;
            }
        }else {
            if (index == 0) {
                isNext = YES;
                index += 1;
            }else {
                index -= 1;
            }
        }

        [self.pageContrl setCurrentPage:index];

        CGFloat xoffset = index*self.bannerView.bounds.size.width;
        CGPoint offset = CGPointMake(xoffset, 0);
        [self.bannerView setContentOffset:offset animated:YES];
    }
}

#pragma mark -UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //结束减速的时候
    NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    [self.pageContrl setCurrentPage:index];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //开始拖拽时取消计时器
    [_timer invalidate];
    _timer = nil;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //使用计时器
    _timer = [NSTimer timerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(timerStart)
                                   userInfo:nil
                                    repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}



@end
