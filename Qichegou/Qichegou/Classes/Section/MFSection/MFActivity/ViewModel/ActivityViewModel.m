//
//  ActivityViewModel.m
//  Qichegou
//
//  Created by Meng Fan on 16/9/23.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "ActivityViewModel.h"

@implementation ActivityViewModel
-(instancetype)init {
    self = [super init];
    if (self) {
        [self setUpCommand];
    }
    return self;
}

- (void)setUpCommand {
    [self webViewCommandAction];
    
}

#pragma mark - request action
- (void)webViewCommandAction {
    _webViewCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            //网络请求
            [DataService request_post_html:[NSString stringWithFormat:@"%@%@", URL_String, ACTIVITYLIST]
                                    params:input
                            completedBlock:^(id responseObject) {
                                NSString *htmlStr = responseObject;
                                [subscriber sendNext:htmlStr];
                            } failure:^(NSError *error) {
                                
                            }];
            
            
            return nil;
        }];
        
        return signal;
    }];
}


@end
