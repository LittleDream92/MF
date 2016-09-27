//
//  ActivityViewModel.h
//  Qichegou
//
//  Created by Meng Fan on 16/9/23.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityViewModel : NSObject

//品牌
@property (nonatomic, strong, readonly) RACCommand *webViewCommand;

@end
