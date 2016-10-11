//
//  BrandView.h
//  QiChegou
//
//  Created by Meng Fan on 16/9/26.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BrandClickProtocol <NSObject>

@required
@optional
- (void)clickBrandWithBrandID:(NSString *)brandID;

@end


@interface BrandView : UIView
@property (nonatomic, strong) id<BrandClickProtocol> delegate;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *sectionArray;
@property (nonatomic, strong) NSDictionary *sectionDic;
@property (nonatomic, strong) NSArray *hotArray;

@end
