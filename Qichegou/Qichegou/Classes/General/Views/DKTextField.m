//
//  DKTextField.m
//  QiChegou
//
//  Created by Meng Fan on 16/7/7.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DKTextField.h"

@implementation DKTextField

-(CGRect)leftViewRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 15;
    
    return iconRect;
}

//UITextField 文字与输入框的距离
- (CGRect)textRectForBounds:(CGRect)bounds{
    
    return CGRectInset(bounds, 45, 0);
    
}

//控制文本的位置
- (CGRect)editingRectForBounds:(CGRect)bounds{
    
    return CGRectInset(bounds, 45, 0);
}

@end
