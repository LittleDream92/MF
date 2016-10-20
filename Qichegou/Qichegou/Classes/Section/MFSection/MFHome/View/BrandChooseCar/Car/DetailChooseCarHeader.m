//
//  DetailChooseCarHeader.m
//  Qichegou
//
//  Created by Meng Fan on 16/4/14.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DetailChooseCarHeader.h"
#import "CarModel.h"

@implementation DetailChooseCarHeader

-(void)dealloc {
    //销毁计时器
    [self.scrollTimer invalidate];
    self.scrollTimer = nil;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    [self setupViews];
}

- (void)setupViews {

    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;

//    self.pageContrl.backgroundColor = [UIColor grayColor];
    self.pageContrl.pageIndicatorTintColor = gray_color;
    self.pageContrl.currentPageIndicatorTintColor = kskyBlueColor;
}

- (IBAction)pageContrlAction:(UIPageControl *)sender {
    
    CGFloat xoffset = sender.currentPage*self.scrollView.bounds.size.width;
    CGPoint offset = CGPointMake(xoffset, 0);
    [self.scrollView setContentOffset:offset animated:YES];
}

#pragma mark - sxcrollView delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //结束减速的时候
    NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    [self.pageContrl setCurrentPage:index];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //开始拖拽时取消计时器
    [self.scrollTimer invalidate];
    self.scrollTimer = nil;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //使用计时器
    self.scrollTimer = [NSTimer timerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(timerStart)
                                   userInfo:nil
                                    repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.scrollTimer forMode:NSDefaultRunLoopMode];
}

#pragma mark -
- (void)createHeaderScrollViewWithModel:(CarModel *)model {
    
    self.model = model;
    
    if ([model.color_imgs isKindOfClass:[NSArray class]] && model.color_imgs.count > 0) {
        
        CGFloat imgX = 50;
        NSInteger count = model.color_imgs.count;

        for (int i = 0; i<count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*kScreenWidth + imgX, 0, kScreenWidth - 2*imgX, self.scrollView.frame.size.height)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_String , model.color_imgs[i]]] placeholderImage:[UIImage imageNamed:@"bg_default"]];
            [self.scrollView addSubview:imageView];
        }
        
        self.scrollTimer = [NSTimer timerWithTimeInterval:2.0
                                         target:self
                                       selector:@selector(timerStart)
                                       userInfo:nil
                                        repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.scrollTimer forMode:NSDefaultRunLoopMode];
        self.scrollView.contentSize = CGSizeMake(count*kScreenWidth, 100);
        self.pageContrl.numberOfPages = model.color_imgs.count;
    }else {
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.scrollView.frame.size.height)];
        img.contentMode = UIViewContentModeScaleAspectFit;
        [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_String , model.main_photo]] placeholderImage:[UIImage imageNamed:(@"bg_default")]];
        [self.scrollView addSubview:img];
        
        self.scrollView.contentSize = CGSizeMake(kScreenWidth, 0);
        self.pageContrl.hidden = YES;
    }
    
    NSString *titleString = [NSString stringWithFormat:@"%@  %@  %@  %@",
                             model.year,
                             model.brand_name ,
                             model.pro_subject ,
                             model.car_subject];
    self.titleLabel.text = titleString;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    self.priceLabel.text = [NSString stringWithFormat:@"%@万", model.price];
    
    NSString *textString = [NSString stringWithFormat:@"厂家指导价：%@万", model.guide_price];
    NSDictionary *attribtDic =  @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:textString attributes:attribtDic];
    self.guidPrice.attributedText = attribtStr;
}


- (void)timerStart {
    if (self.model) {
        NSInteger index = self.pageContrl.currentPage;
        if (index == (self.model.color_imgs.count-1)) {
            index = 0;
        }else {
            index += 1;
        }
        
        [self.pageContrl setCurrentPage:index];
        
        CGFloat xoffset = index*self.scrollView.bounds.size.width;
        CGPoint offset = CGPointMake(xoffset, 0);
        [self.scrollView setContentOffset:offset animated:YES];
    }
}

@end
