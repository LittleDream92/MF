//
//  HomeBannerCell.m
//  QiChegou
//
//  Created by Meng Fan on 16/9/18.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "HomeBannerCell.h"

@interface HomeBannerCell ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *bannerView;
@property (nonatomic, strong) UIPageControl *pageContrl;

@property (nonatomic, strong) NSArray *imagesArr;

@end

@implementation HomeBannerCell

//-(void)dealloc {
//    //销毁计时器
//    [_timer invalidate];
//}

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
        
        [self.contentView addSubview:self.bannerView];
        [self.bannerView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        [self.contentView addSubview:self.pageContrl];
        [self.pageContrl makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.height.equalTo(30);
        }];
    }
    return self;
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
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*kScreenWidth, 0, kScreenWidth, self.contentView.frame.size.height)];
            imageView.image = [UIImage imageNamed:images[i]];
            [self.bannerView addSubview:imageView];
        }
        
    }else {
        self.pageContrl.hidden = YES;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.contentView.frame.size.height)];
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
    
    NSLog(@"1");
//    if ([self.imagesArr isKindOfClass:[NSArray class]] && self.imagesArr.count>1) {
//        NSInteger index = self.pageContrl.currentPage;
//        if (index == (self.imagesArr.count-1)) {
//            index = 0;
//        }else {
//            index += 1;
//        }
//        
//        [self.pageContrl setCurrentPage:index];
//        
//        CGFloat xoffset = index*self.bannerView.bounds.size.width;
//        CGPoint offset = CGPointMake(xoffset, 0);
//        [self.bannerView setContentOffset:offset animated:YES];
//    }
}

#pragma mark -UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //结束减速的时候
    NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    [self.pageContrl setCurrentPage:index];
}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    //开始拖拽时取消计时器
//    [_timer invalidate];
//    _timer = nil;
//}
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    //使用计时器
//    _timer = [NSTimer timerWithTimeInterval:1.5
//                                     target:self
//                                   selector:@selector(timerStart)
//                                   userInfo:nil
//                                    repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
//}



@end