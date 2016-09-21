//
//  HomeBannerCell.m
//  QiChegou
//
//  Created by Meng Fan on 16/9/18.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "HomeBannerCell.h"

@interface HomeBannerCell ()

@property (nonatomic, strong) UIImageView *bannerView;

@end

@implementation HomeBannerCell

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
            make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return self;
}

#pragma mark - lazyloading
-(UIImageView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[UIImageView alloc] init];
        _bannerView.contentMode = UIViewContentModeScaleToFill;
        _bannerView.backgroundColor = [UIColor greenColor];
    }
    return _bannerView;
}

@end


//@implementation HomeBannerCell
//
//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//    
//    // Configure the view for the selected state
//}
//
//-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        
//    }
//    return self;
//}
//
//@end