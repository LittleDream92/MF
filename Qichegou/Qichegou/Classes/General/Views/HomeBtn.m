//
//  HomeBtn.m
//  QiChegou
//
//  Created by Meng Fan on 16/9/18.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "HomeBtn.h"
#import "UIButton+WebCache.h"

@implementation HomeBtn

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = H14;
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect {
    
    return CGRectMake(contentRect.origin.x, 0, contentRect.size.width, contentRect.size.height-20);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(contentRect.origin.x, contentRect.size.height-20, contentRect.size.width, 20);
}

//取消高亮状态
-(void)setHighlighted:(BOOL)highlighted {
    
}


- (void)setUpButtonWithImageName:(NSString *)imgName title:(NSString *)title {
        NSLog(@"%@, %@", imgName, title);
    [self setTitleColor:TEXTCOLOR forState:UIControlStateNormal];
    self.titleLabel.font = H13;
    [self setTitle:title forState:UIControlStateNormal];
    [self sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_String, imgName]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bg_default"]];
    
}

@end
