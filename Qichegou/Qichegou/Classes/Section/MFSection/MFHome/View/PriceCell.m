//
//  PriceCell.m
//  MyDemo
//
//  Created by Meng Fan on 16/9/13.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "PriceCell.h"

#define kThumbW 20

@interface PriceCell ()

@property (nonatomic, strong) UIView *sliderView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *blueView;

@property (nonatomic, strong) UIImageView *thumb1;
@property (nonatomic, strong) UIImageView *thumb2;

@end


@implementation PriceCell

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
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat height = 30;
        CGFloat padding = 10;
        
        WEAKSELF
        
        [self.contentView addSubview:self.sliderView];
        [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kScreenWidth, 80));
            make.top.equalTo(10);
            make.left.equalTo(weakSelf.contentView);
        }];
        
        [self.sliderView addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(height, padding, 40, padding));
        }];
        
        [self.sliderView addSubview:self.blueView];
        [self.blueView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(height, padding, 40, padding));
        }];
        
        [self.sliderView addSubview:self.thumb1];
        [self.thumb1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kThumbW, kThumbW+10));
            make.centerX.equalTo(weakSelf.sliderView.mas_left).offset(padding);
            make.centerY.equalTo(weakSelf.bgView.mas_bottom).offset(5);
        }];
        
        [self.sliderView addSubview:self.thumb2];
        [self.thumb2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kThumbW, kThumbW+10));
            make.centerX.equalTo(weakSelf.sliderView.mas_right).offset(-padding);
            make.centerY.equalTo(weakSelf.bgView.mas_bottom).offset(5);
        }];
        
    }
    return self;
}

#pragma mark - lazyloading
-(UIView *)sliderView {
    if (!_sliderView) {
        _sliderView = [[UIView alloc] init];
//        _sliderView.backgroundColor = [UIColor yellowColor];
    }
    return _sliderView;
}

-(UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor brownColor];
    }
    return _bgView;
}

-(UIView *)blueView {
    if (!_blueView) {
        _blueView = [[UIView alloc] init];
        _blueView.backgroundColor = ITEMCOLOR;
    }
    return _blueView;
}

-(UIImageView *)thumb1 {
    if (!_thumb1) {
        _thumb1 = [[UIImageView alloc] init];
        _thumb1.userInteractionEnabled = YES;
        _thumb1.image = [UIImage imageNamed:@"upArow"];
//        _thumb1.backgroundColor = [UIColor redColor];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(thumbAction1:)];
        [_thumb1 addGestureRecognizer:pan];
        
    }
    return _thumb1;
}

-(UIImageView *)thumb2 {
    if (!_thumb2) {
        _thumb2 = [[UIImageView alloc] init];
        _thumb2.userInteractionEnabled = YES;
        _thumb2.image = [UIImage imageNamed:@"upArow"];
//        _thumb2.backgroundColor = [UIColor cyanColor];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(thumbAction2:)];
        [_thumb2 addGestureRecognizer:pan];
    }
    return _thumb2;
}


#pragma mark - action
- (void)thumbAction1:(UIPanGestureRecognizer *)panGesture {
//    NSLog(@"thumb1");
    
    CGPoint point = [panGesture translationInView:self.sliderView];
    static CGPoint center;
    CGFloat thub2X = CGRectGetMinX(self.thumb2.frame);
    CGFloat blueViewX = CGRectGetMaxX(self.blueView.frame);
    
    //初始位置
    if (panGesture.state ==UIGestureRecognizerStateBegan) {
        center = panGesture.view.center;
    }
    
    CGFloat x = point.x+center.x;
    self.blueView.left = self.thumb1.center.x;
    self.blueView.width = blueViewX - self.thumb1.center.x;
    panGesture.view.center = CGPointMake(x, 45);
    
    if (panGesture.view.center.x < 10) {
        panGesture.view.center = CGPointMake(10,45);
    }else if (panGesture.view.center.x > thub2X ) {
        panGesture.view.center = CGPointMake(thub2X-15,45);
    }
    
    
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        if (self.thumbMoveAction) {
            self.thumbMoveAction(self.thumb1.center.x, self.thumb2.center.x);
        }
    }
    
}

- (void)thumbAction2:(UIPanGestureRecognizer *)panGesture {
//    NSLog(@"thumb2");
    
    CGFloat thub1X = CGRectGetMaxX(self.thumb1.frame);
    
    CGPoint point = [panGesture translationInView:self.sliderView];
    static CGPoint center;
    
    //初始位置
    if (panGesture.state ==UIGestureRecognizerStateBegan) {
        center = panGesture.view.center;
    }
    
    CGFloat x = center.x+point.x;
    self.blueView.width = x - self.thumb1.center.x;
    self.blueView.right = x;
    
    panGesture.view.center = CGPointMake(x, 45);
    
    if (panGesture.view.center.x < thub1X) {
        
        self.blueView.width = self.thumb2.center.x - self.thumb1.center.x;
        self.blueView.right = self.thumb2.center.x;
        
        panGesture.view.center = CGPointMake(thub1X+15,45);
    }
    if (panGesture.view.center.x > (kScreenWidth-10) ) {
        
        self.blueView.width = kScreenWidth-20;
        self.blueView.right = kScreenWidth-10;
        
        panGesture.view.center = CGPointMake(kScreenWidth-10,45);
    }
    
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        if (self.thumbMoveAction) {
            self.thumbMoveAction(self.thumb1.center.x, self.thumb2.center.x);
        }
    }
}


@end
