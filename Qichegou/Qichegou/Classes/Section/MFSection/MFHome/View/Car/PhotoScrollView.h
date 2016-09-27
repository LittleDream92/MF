//
//  PhotoScrollView.h
//  WXMovie47
//
//  Created by keyzhang on 15/8/24.
//  Copyright (c) 2015年 keyzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OtherModel.h"

@interface PhotoScrollView : UIScrollView<UIScrollViewDelegate>
{
    UIImageView *_imgView;
    BOOL _isHidden;
}


@property (nonatomic, strong) OtherModel *model;

@end
