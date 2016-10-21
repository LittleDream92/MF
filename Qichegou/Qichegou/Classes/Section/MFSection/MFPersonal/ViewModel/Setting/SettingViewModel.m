//
//  SettingViewModel.m
//  Qichegou
//
//  Created by Meng Fan on 16/10/9.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "SettingViewModel.h"
#import "AppDelegate.h"

@implementation SettingViewModel

-(instancetype)init {
    self = [super init];
    if (self) {
        
        self.titleArr = @[@"清除缓存", @"反馈", @"评分", @"关于"];
        self.imgArr = @[@"set_d", @"set_im", @"set_f", @"set_a"];
        
        [self countCacheAction];
        [self loginOutAction];
    }
    return self;
}

#pragma mark - loginOutAction

- (void)loginOutAction {
    @weakify(self);
    _loginOutCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [DataService http_Post:CANCEL_LOGIN parameters:input success:^(id responseObject) {
                if ([responseObject[@"status"] integerValue] == 1) {
                    [AppDelegate APP].user = nil;
                    [subscriber sendNext:@"YES"];
                }else {
                    [PromtView showMessage:responseObject[@"msg"] duration:1.5];
                    [subscriber sendNext:@"NO"];
                }
            } failure:^(NSError *error) {
                [PromtView showMessage:PromptWord duration:1.5];
            }];
            
            return nil;
        }];
        
        return signal;
    }];
}



#pragma mark -
//计算缓存大小
- (void)countCacheAction {
    //找到沙盒路径
    NSString *homePath = NSHomeDirectory();
    
    //拼接出来缓存路径
    NSString *imgsPath = [homePath stringByAppendingPathComponent:@"Library/caches/default/com.hackemist.SDWebImageCache.default"];
    
    //文件管家（单例对象）
    NSFileManager *manager = [NSFileManager defaultManager];
    
    //用文件管家取出所有子文件的路径
    NSError *error = nil;
    NSArray *arr = [manager subpathsOfDirectoryAtPath:imgsPath error:&error];
    
    long long sum = 0;
    //遍历路径：拼接路径--》拿到文件属性 --》取到文件大小---》累加起来
    for (NSString *path in arr) {
        //拼接路径
        NSString *filePath = [imgsPath stringByAppendingPathComponent:path];
        //拿到文件属性
        NSDictionary *dic = [manager attributesOfItemAtPath:filePath error:&error];
        //取到文件大小
        NSNumber *fileSize = dic[NSFileSize];
        
        sum += [fileSize longLongValue];
    }
    
    self.cacheSize = sum / (1024.0 * 1024);
}

//清除缓存
- (void)clearCacheAction {
    [[SDImageCache sharedImageCache] clearDisk];
    
    self.cacheSize = 0.0;
}

@end
