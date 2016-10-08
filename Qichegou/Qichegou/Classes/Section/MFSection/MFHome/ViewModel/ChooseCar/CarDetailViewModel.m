//
//  CarDetailViewModel.m
//  Qichegou
//
//  Created by Meng Fan on 16/9/28.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "CarDetailViewModel.h"
#import "CarModel.h"

@implementation CarDetailViewModel

-(instancetype)init {
    self = [super init];
    if (self) {
        [self setUpCommand];
    }
    return self;
}

- (void)setUpCommand {
    [self carDetailCommandAction];
}

#pragma mark - request action
- (void)carDetailCommandAction {
    _carDetailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            //网络请求
            [DataService http_Post:DETAIL_CAR
                        parameters:input
                           success:^(id responseObject) {
                               NSLog(@"detail Car:%@", responseObject);
                               
                               if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
                                   NSDictionary *jsonDic = [responseObject objectForKey:@"car"];
                                   CarModel *detailModel = [[CarModel alloc] initContentWithDic:jsonDic];
                                   
                                   NSMutableArray *mArr = [NSMutableArray array];
                                   NSArray *carImgs = [jsonDic objectForKey:@"car_imgs"];
                                   if ([carImgs isKindOfClass:[NSArray class]] && carImgs.count > 0) {
                                       
                                       for (NSDictionary *jsonDic in carImgs) {
                                           NSString *imgURL = jsonDic[@"img"];
                                           [mArr addObject:imgURL];
                                       }
                                   }
                                   detailModel.color_imgs = (NSArray *)mArr;
                                   
                                   [subscriber sendNext:detailModel];
                                   
                               }else {
                                   
                                   NSLog(@"%@", [responseObject objectForKey:@"msg"]);
                                   [PromtView showAlert:[responseObject objectForKey:@"msg"] duration:1.5];
                               }
                               
                           } failure:^(NSError *error) {
                               [PromtView showAlert:PromptWord duration:1.5];
                           }];

            
            return nil;
        }];
        
        return signal;
    }];
}


@end
