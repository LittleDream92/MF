//
//  UIView+ViewController.m
//  Project_Weibo47
//
//  Created by keyzhang on 15/9/18.
//  Copyright (c) 2015年 keyzhang. All rights reserved.
//

#import "UIView+ViewController.h"

@implementation UIView (ViewController)

- (UIViewController *)viewController
{
    UIResponder *next = self.nextResponder;
    
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        
        next = next.nextResponder;
        
    } while (next);
    
    return nil;
    
}


@end
