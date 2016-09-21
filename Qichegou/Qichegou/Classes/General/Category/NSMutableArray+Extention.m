//
//  NSMutableArray+Extention.m
//  Demo0824
//
//  Created by mac on 16/8/24.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "NSMutableArray+Extention.h"
#import <objc/runtime.h>

@implementation NSMutableArray (Extention)

+ (void)load
{
    Method originalMethod = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(addObject:));
    Method newMethod = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(exchange_addObject:));
    method_exchangeImplementations(originalMethod, newMethod);
}

- (void)exchange_addObject:(id)object
{
    if (object != nil) {
        [self exchange_addObject:object];
    }
}


@end
