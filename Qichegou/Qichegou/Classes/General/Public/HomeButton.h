//
//  HomeButton.h
//  Qichegou
//
//  Created by Meng Fan on 16/6/1.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeButton : UIButton

@property (nonatomic, assign) BOOL isAtHome;

- (void)setUpButtonWithImageName:(NSString *)imgName title:(NSString *)title;

@end
