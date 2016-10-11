//
//  PriceCell.m
//  MyDemo
//
//  Created by Meng Fan on 16/9/13.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "PriceCell.h"

#define LEFT_Padding 50
#define kThumbW 15

@interface PriceCell ()
{
    CGFloat leftX;
    CGFloat rightX;
}

@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIView *blueView;

@property (nonatomic, strong) UIImageView *thumb1;
@property (nonatomic, strong) UIImageView *thumb2;

@property (nonatomic, assign) CGFloat gestureH;

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
        
        WEAKSELF
        [self.contentView addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf);
            make.top.equalTo(15);
            make.size.equalTo(CGSizeMake(292, 28));
        }];
        
        leftX = kScreenWidth/2 - (292/2) + 3;
        rightX = kScreenWidth/2 + (292/2) - 9;
        
        self.gestureH = self.bgView.frame.origin.y;
        
        [self.contentView addSubview:self.blueView];
        [self.blueView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.bgView).offset(3);
            make.right.equalTo(weakSelf.bgView).offset(-9);
            make.bottom.equalTo(weakSelf.bgView);
            make.height.equalTo(9);
        }];
        
        [self.contentView addSubview:self.thumb1];
        [self.thumb1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kThumbW, kThumbW-2));
            make.centerX.equalTo(weakSelf.bgView.mas_left).offset(3);
            make.centerY.equalTo(weakSelf.bgView.mas_bottom).offset(5);
        }];

        [self.contentView addSubview:self.thumb2];
        [self.thumb2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kThumbW, kThumbW-2));
            make.centerX.equalTo(weakSelf.bgView.mas_right).offset(-9);
            make.centerY.equalTo(weakSelf.bgView.mas_bottom).offset(5);
        }];
        
    }
    return self;
}

#pragma mark - lazyloading
-(UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [[UIImageView alloc] init];
        _bgView.image = [UIImage imageNamed:@"Condation_bg"];
    }
    return _bgView;
}

-(UIView *)blueView {
    if (!_blueView) {
        _blueView = [[UIView alloc] init];
        _blueView.backgroundColor = kskyBlueColor;
    }
    return _blueView;
}

-(UIImageView *)thumb1 {
    if (!_thumb1) {
        _thumb1 = [[UIImageView alloc] init];
        _thumb1.userInteractionEnabled = YES;
        _thumb1.image = [UIImage imageNamed:@"upArow"];
        
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
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(thumbAction2:)];
        [_thumb2 addGestureRecognizer:pan];
    }
    return _thumb2;
}


#pragma mark - action
- (void)thumbAction1:(UIPanGestureRecognizer *)panGesture {
//    NSLog(@"thumb1");
    
    //初始位置
    static CGPoint center;
    if (panGesture.state ==UIGestureRecognizerStateBegan) {
        center = panGesture.view.center;
    }
    
    //手势滑动
    CGPoint point = [panGesture translationInView:self.contentView];
    
    CGFloat thub2X = CGRectGetMinX(self.thumb2.frame);

    CGFloat x = point.x+center.x;
    self.blueView.left = self.thumb1.center.x;
    self.blueView.width = self.thumb2.center.x - self.thumb1.center.x;
    
    panGesture.view.center = CGPointMake(x, center.y);

    if (panGesture.view.center.x < (self.bgView.origin.x+3)) {
        panGesture.view.center = CGPointMake(self.bgView.origin.x+3,center.y);
    }else if (panGesture.view.center.x > (thub2X-kThumbW/2) ) {
        panGesture.view.center = CGPointMake((thub2X-kThumbW/2), center.y);
    }

    
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        if (self.thumbMoveAction) {
            self.thumbMoveAction(self.thumb1.center.x, self.thumb2.center.x);
        }
    }
    
}

- (void)thumbAction2:(UIPanGestureRecognizer *)panGesture {

    static CGPoint center;
    //初始位置
    if (panGesture.state ==UIGestureRecognizerStateBegan) {
        center = panGesture.view.center;
    }
    
    //滑动位置
    CGPoint point = [panGesture translationInView:self.contentView];
    CGFloat x = center.x+point.x;
    self.blueView.width = x - self.thumb1.center.x;
    self.blueView.right = x;
    
    panGesture.view.center = CGPointMake(x, center.y);
    
    CGFloat thub1X = CGRectGetMaxX(self.thumb1.frame);
    if (panGesture.view.center.x < (thub1X+kThumbW/2)) {
        self.blueView.left = self.thumb1.center.x;
        self.blueView.width = (thub1X+kThumbW/2) - self.thumb1.center.x;
        
        
        panGesture.view.center = CGPointMake((thub1X+kThumbW/2), center.y);
    }else if (panGesture.view.center.x > rightX) {

        self.blueView.width = rightX - self.thumb1.center.x;
        self.blueView.right = rightX;
        
        panGesture.view.center = CGPointMake(rightX, center.y);
    }

    if (panGesture.state == UIGestureRecognizerStateEnded) {
        if (self.thumbMoveAction) {
            self.thumbMoveAction(self.thumb1.center.x, self.thumb2.center.x);
        }
    }
}


@end
